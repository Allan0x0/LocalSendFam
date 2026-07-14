<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ExamController extends Controller
{
    private $baseUrl;

    public function __construct()
    {
        $this->baseUrl = config('app.api_base_url');
    }

    private function getSpringSessionId(Request $request): ?string
    {
        return $request->cookie('spring_session_id') ?? session('spring_session_id');
    }

    public function showPayFeesPage()
    {
        return view('pay-fees');
    }
    
    public function showExamTimetable(Request $request)
    {
        // Retrieve the session ID from the cookie or from Laravel session as fallback
        $sessionId = $this->getSpringSessionId($request);

        if (is_null($sessionId)) {
            return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
        }
        
        // Fetch exam timetable from API
        $response = Http::withHeaders(['Cookie' => 'JSESSIONID=' . $sessionId])
            ->get("{$this->baseUrl}/api/exam-timetable");

        if ($response->failed()) {
            if ($response->status() === 401) {
                session()->flush();
                return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
            }
            return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
        }

        $timetableData = $response->json();
        
        // Check if timetableData is null or not an array
        if (!is_array($timetableData)) {
            $timetableData = [];
        }
        
        // Sort timetable by date only if we have data
        if (!empty($timetableData)) {
            usort($timetableData, function($a, $b) {
                $dateA = strtotime($a['session_starttime'] ?? '0');
                $dateB = strtotime($b['session_starttime'] ?? '0');
                return $dateA <=> $dateB;
            });
        }
        
        // Fetch personal details from API (same as home page)
        $personalDetailsResponse = Http::withHeaders(['Cookie' => 'JSESSIONID=' . $sessionId])
            ->get("{$this->baseUrl}/api/personal-details");
        
        $personalDetails = $personalDetailsResponse->successful() ? $personalDetailsResponse->json() : [];
        
        return view('exam-timetable', compact('timetableData', 'personalDetails'));
    }


    public function showExamResults(Request $request)
    {
        // Retrieve the session ID from the cookie or from Laravel session as fallback
        $sessionId = $this->getSpringSessionId($request);

        if (is_null($sessionId)) {
            session()->flush();
            return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
        }
        
        // Log if a specific period was selected
        $selectedPeriod = $request->query('period');
        if ($selectedPeriod) {
            // Get user information for the log
            $personalDetails = session('personalDetails');
            $regnum = $personalDetails['regnum'] ?? 'unknown';
            $name = ($personalDetails['firstnames'] ?? '') . ' ' . ($personalDetails['surname'] ?? '');
            
            // Log the period selection with user details
            \Illuminate\Support\Facades\Log::info('User selected exam period', [
                'period' => $selectedPeriod,
                'regnum' => $regnum,
                'name' => $name,
                'timestamp' => now()->toDateTimeString(),
                'ip' => $request->ip()
            ]);
        }
        
        // Check balance from the new checkBalance method
        $balanceResponse = $this->checkBalance($request);

        // If balance check fails, handle it accordingly
        if ($balanceResponse->getStatusCode() !== 200) {
            return redirect()->route('view.results')->with('message', $balanceResponse->getData()->error ?? 'Failed to check balance.');
        }

        $balanceData = json_decode($balanceResponse->getContent(), true);
        if ($balanceData['status'] === 'due') {
            session(['balanceAmount' => $balanceData['balance'] ?? 'Unknown']);
            // Redirect to the pay fees page if balance is due
            return redirect()->route('pay.fees');
        }

        // Fetch exam results if balance is cleared
        $response = Http::withHeaders(['Cookie' => 'JSESSIONID=' . $sessionId])
            ->get("{$this->baseUrl}/api/results");

        if ($response->failed()) {
            return redirect()->route('view.results')->with('message', 'Failed to fetch exam results.');
        }

        $examResults = $response->json();

        // Withhold Part 3 results for these engineering programmes (registry request).
        // academicyear === 3 marks a Part 3 result; drop those rows so no period shows them.
        $withheldPart3Programmes = [
            'BACHELOR OF TECHNOLOGY HONOURS DEGREE IN BIOMEDICAL ENGINEERING',
            'BACHELOR OF TECHNOLOGY HONOURS DEGREE IN CHEMICAL AND PROCESS SYSTEMS ENGINEERING',
            'BACHELOR OF TECHNOLOGY HONOURS DEGREE IN ELECTRONIC ENGINEERING',
            'BACHELOR OF TECHNOLOGY HONOURS DEGREE IN INDUSTRIAL AND MANUFACTURING ENGINEERING',
            'BACHELOR OF TECHNOLOGY HONOURS DEGREE IN MATERIALS TECHNOLOGY AND ENGINEERING',
            'BACHELOR OF TECHNOLOGY HONOURS DEGREE IN POLYMER TECHNOLOGY AND ENGINEERING',
        ];

        if (is_array($examResults)) {
            $examResults = array_values(array_filter($examResults, function ($result) use ($withheldPart3Programmes) {
                // A pending lecturer-evaluation prompt takes priority over the withhold rule.
                if (($result['coursecode'] ?? '') === 'Missing Evaluation') {
                    return true;
                }
                $isPart3    = (int) ($result['academicyear'] ?? 0) === 3;
                $isWithheld = in_array(strtoupper(trim($result['programme'] ?? '')), $withheldPart3Programmes, true);
                return !($isPart3 && $isWithheld); // keep everything except Part 3 in these programmes
            }));
        }

        // Organize data for the view
        $resultsByPeriod = [];
        $studentDetails = [];

        foreach ($examResults as $result) {
            // Filter for "CERTIFICATE IN HIGHER AND TERTIARY EDUCATION"
            if (strpos($result['programme'], 'CERTIFICATE IN HIGHER AND TERTIARY EDUCATION') !== false) {
                continue; // Skip if the program does not match
            }

            // Set student details if not already set
            if (empty($studentDetails)) {
                $studentDetails = [
                    'regnum' => $result['regnum'] ?? '----',
                    'programme' => $result['programme'] ?? '----',
                ];
            }

            $period = $result['period'] ?? 'Unknown Period';

            if (!isset($resultsByPeriod[$period])) {
                $resultsByPeriod[$period] = [
                    'description' => $period,
                    'modules' => [],
                ];
            }

            $resultsByPeriod[$period]['modules'][] = [
                'coursecode' => $result['coursecode'] ?? 'N/A',
                'coursename' => $result['coursename'] ?? 'N/A',
                'grade' => $result['grade'] ?? 'N/A',
                'gradestatus' => $result['gradestatus'] ?? 'N/A',
                'regdecision' => $result['regdecision'] ?? 'N/A',
            ];
        }

        // Sort resultsByPeriod by parsing the start date of the period in descending order
        uksort($resultsByPeriod, function ($a, $b) {
            // Extract the starting month and year from the period (e.g., February 2023 - June 2023)
            $startA = strtotime(explode(' - ', $a)[0]);
            $startB = strtotime(explode(' - ', $b)[0]);

            return $startB <=> $startA; // Compare timestamps for descending order
        });
        
        // Get the selected period from the request
        $selectedPeriod = $request->query('period');
        
        // General handling for any period - normalize period names to handle inconsistencies in API data
        if ($selectedPeriod) {
            // Normalize the selected period by trimming whitespace
            $normalizedPeriod = trim($selectedPeriod);
            
            // Create a map of normalized periods to handle inconsistencies in API data
            $normalizedPeriodMap = [];
            foreach ($examResults as $result) {
                $apiPeriod = $result['period'] ?? '';
                $normalizedApiPeriod = trim($apiPeriod);
                $normalizedPeriodMap[$normalizedApiPeriod] = $apiPeriod;
            }
            
            // Check if the normalized period exists in our map
            if (isset($normalizedPeriodMap[$normalizedPeriod])) {
                $originalApiPeriod = $normalizedPeriodMap[$normalizedPeriod];
                
                // If the period exists in the API but not in our organized data, create it
                if (!isset($resultsByPeriod[$normalizedPeriod])) {
                    $resultsByPeriod[$normalizedPeriod] = [
                        'description' => $normalizedPeriod,
                        'modules' => []
                    ];
                    
                    // Add all modules for this period
                    foreach ($examResults as $result) {
                        if (trim($result['period'] ?? '') === $normalizedPeriod) {
                            $resultsByPeriod[$normalizedPeriod]['modules'][] = [
                                'coursecode' => $result['coursecode'] ?? 'N/A',
                                'coursename' => $result['coursename'] ?? 'N/A',
                                'grade' => $result['grade'] ?? 'N/A',
                                'gradestatus' => $result['gradestatus'] ?? 'N/A',
                                'regdecision' => $result['regdecision'] ?? 'N/A'
                            ];
                        }
                    }
                }
                
                // Update selected period to normalized version
                $selectedPeriod = $normalizedPeriod;
            }
        }
        
        // If a period is selected, make it easily accessible in the view
        $selectedPeriodResults = null;
        if ($selectedPeriod && isset($resultsByPeriod[$selectedPeriod])) {
            $selectedPeriodResults = $resultsByPeriod[$selectedPeriod];
        }

        return view('exam-results', compact('studentDetails', 'resultsByPeriod', 'selectedPeriod', 'selectedPeriodResults'));
    }



    public function showTECExamResults(Request $request)
    {
        // Retrieve the session ID from the cookie
        $sessionId = $this->getSpringSessionId($request);
    
        if (is_null($sessionId)) {
            session()->flush();
            return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
        }
    
        // Check balance
        $balanceResponse = $this->checkBalance($request);
    
        // If balance check fails, handle it accordingly
        if ($balanceResponse->getStatusCode() !== 200) {
            return redirect()->route('view.results')->with('message', $balanceResponse->getData()->error ?? 'Failed to check balance.');
        }
    
        $balanceData = json_decode($balanceResponse->getContent(), true);
    
        if ($balanceData['status'] === 'due') {
            // Pass the balance amount to the pay fees page
            return redirect()->route('pay.fees')->with('balanceAmount', $balanceData['balance'] ?? 'Unknown');
        }
    
        // Fetch exam results if balance is cleared
        $response = Http::withHeaders(['Cookie' => 'JSESSIONID=' . $sessionId])
            ->get("{$this->baseUrl}/api/results");
    
        if ($response->failed()) {
            return redirect()->route('view.results')->with('message', 'Failed to fetch exam results.');
        }
    
        $examResults = $response->json();
    
        // Organize data for the view
        $resultsByPeriod = [];
        $studentDetails = [];
    
        foreach ($examResults as $result) {
            if (strpos($result['programme'], 'CERTIFICATE IN HIGHER AND TERTIARY EDUCATION') === false) {
                continue; // Skip if the program does not match
            }
    
            if (empty($studentDetails)) {
                $studentDetails = [
                    'regnum' => $result['regnum'] ?? '----',
                    'programme' => $result['programme'] ?? '----',
                ];
            }
    
            $period = $result['period'] ?? 'Unknown Period';
    
            if (!isset($resultsByPeriod[$period])) {
                $resultsByPeriod[$period] = [
                    'description' => $period,
                    'modules' => [],
                ];
            }
    
            $resultsByPeriod[$period]['modules'][] = [
                'coursecode' => $result['coursecode'] ?? 'N/A',
                'coursename' => $result['coursename'] ?? 'N/A',
                'grade' => $result['grade'] ?? 'N/A',
                'gradestatus' => $result['gradestatus'] ?? 'N/A',
                'regdecision' => $result['regdecision'] ?? 'N/A',
            ];
        }
    
        return view('tec-results', compact('studentDetails', 'resultsByPeriod'));
    }
    

    
   public function showExamPersonal(Request $request)
{
    // Retrieve the session ID from the cookie or Laravel session as fallback
        $sessionId = $this->getSpringSessionId($request);

    if (is_null($sessionId)) {
        session()->flush();
        return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
    }

    // Call Java backend API
    $response = Http::withHeaders([
        'Cookie' => 'JSESSIONID=' . $sessionId
    ])->get("{$this->baseUrl}/api/results");

        if ($response->failed()) {
            if ($response->status() === 401) {
                session()->flush();
                return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
            }
            return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
        }

    // Decode JSON safely
    $examResults = $response->json();

    // Ensure examResults is an array
    if (!is_array($examResults)) {
        \Log::error('Invalid exam results response', [
            'status' => $response->status(),
            'body'   => $response->body()
        ]);

        session()->flush();
        return redirect()->route('login')->with('error', 'Your session has expired. Please log in again.');
    }

    $uniquePrograms = [];

    foreach ($examResults as $result) {

        // Skip invalid records
        if (!is_array($result) || !isset($result['programme'])) {
            continue;
        }

        $program = trim($result['programme']);

        // Add only unique programs
        if (!in_array($program, $uniquePrograms)) {
            $uniquePrograms[] = $program;
        }
    }

    // Log for debugging
    \Log::info('Unique Programs Count', [
        'count' => count($uniquePrograms)
    ]);

    return view('check-balance', compact('uniquePrograms'));
}

    public function checkBalance(Request $request){
        // Retrieve the session ID from the cookie
        $sessionId = $this->getSpringSessionId($request);

        if (is_null($sessionId)) {
            return response()->json(['error.page' => 'Session ID is not set.'], 400);
        }

        // Fetch overall balance from the API
        $balanceResponse = Http::withHeaders(['Cookie' => 'JSESSIONID=' . $sessionId])
            ->get("{$this->baseUrl}/api/transactions/overall-balance");

        if ($balanceResponse->failed()) {
            return response()->json(['error.page' => 'Failed to fetch balance'], 500);
        }

        $overallBalance = $balanceResponse->json()['overallBalance'] ?? 0;

        if ($overallBalance > 0) {
            return response()->json([
                'status' => 'due',
                'balance' => $overallBalance,
                'message' => 'Pay your fees first to view results.'
            ]);
        } else {
            return response()->json([
                'status' => 'cleared',
                'balance' => $overallBalance,
                'message' => 'Your balance is cleared. You can now view your results.'
            ]);
        }
    }
}
