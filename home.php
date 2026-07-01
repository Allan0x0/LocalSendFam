<?php   
session_start();
include '../db.php';

// Check if user is logged in and has admin role
if (!isset($_SESSION['username']) || $_SESSION['role'] != 1) {
    header('location: index.php');
    exit();
}

$facultyid = $_SESSION['facultyid'];
$username = $_SESSION['username'];

// Get statistics
$total_students = 0;
$total_lecturers = 0;
$total_programmes = 0;
$active_period = "Not Set";

// Count total students
$stmt = $conn->prepare("SELECT COUNT(*) as count FROM registration_confirmed where programme_name in (select name from programme where facultyid = ?)");
$stmt->bind_param("i", $facultyid);
$stmt->execute();
$stmt->bind_result($total_students);
$stmt->fetch();
$stmt->close();

// Count total lecturers - Simplified for PHP 5.5 compatibility
$stmt = $conn->prepare("SELECT COUNT(DISTINCT al.id) AS count
    FROM all_lecturers al
    JOIN programme p ON p.facultyid = ?
    WHERE al.role IN (1,2,3,4)
    AND (
        al.programmeid = p.id 
        OR FIND_IN_SET(al.programmeid, CONCAT(',', p.id, ',')) > 0
    )");
$stmt->bind_param("i", $facultyid);
$stmt->execute();
$stmt->bind_result($total_lecturers);
$stmt->fetch();
$stmt->close();

// Count total programmes
$stmt = $conn->prepare("SELECT COUNT(*) as count FROM programme where facultyid = ?");
$stmt->bind_param("i", $facultyid);
$stmt->execute();
$stmt->bind_result($total_programmes);
$stmt->fetch();
$stmt->close();

// Get active period
$stmt = $conn->prepare("SELECT periodid FROM activeperiod_markscapturing LIMIT 1");
$stmt->execute();
$stmt->bind_result($period_id);
if ($stmt->fetch()) {
    $active_period = "Period " . $period_id;
}
$stmt->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - HIT Academics System</title>
    <link href="../assets/css/hit-theme.css" rel="stylesheet">
    <link href="../assets/css/hit-bootstrap-override.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .dashboard-header {
            background: linear-gradient(135deg, var(--hit-primary) 0%, var(--hit-secondary) 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 4px solid var(--hit-primary);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
        }
        
        .stat-icon.students { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-icon.lecturers { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .stat-icon.programmes { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .stat-icon.period { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--hit-primary);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: var(--hit-text-secondary);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .action-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
            border: 1px solid #e9ecef;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        
        .action-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin: 0 auto 1rem;
        }
        
        .action-icon.users { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .action-icon.programmes { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .action-icon.periods { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .action-icon.settings { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        
        .action-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--hit-text-primary);
            margin-bottom: 0.5rem;
        }
        
        .action-description {
            color: var(--hit-text-secondary);
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-weight: bold;
            color: var(--hit-primary);
            font-size: 1.5rem;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--hit-primary) 0%, var(--hit-secondary) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        
        .welcome-section {
            background: linear-gradient(135deg, rgba(30, 58, 138, 0.1) 0%, rgba(15, 118, 110, 0.1) 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(30, 58, 138, 0.2);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <img src="../assets/images/HIT_logo.png" alt="HIT Logo" height="40" class="me-2">
                <span class="d-none d-md-inline">Admin Portal</span>
            </a>
            
            <div class="user-info">
                <div class="user-avatar">
                    <?php echo strtoupper(substr($username, 0, 1)); ?>
                </div>
                <div>
                    <div class="fw-bold"><?php echo htmlspecialchars($username); ?></div>
                    <small class="text-muted">Administrator</small>
                </div>
                <a href="logout.php" class="btn btn-outline-danger btn-sm ms-3">
                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="mb-2">
                            <i class="fas fa-tachometer-alt me-3"></i>
                            Welcome back, <?php echo htmlspecialchars($username); ?>!
                        </h1>
                        <p class="mb-0 opacity-75">Manage the entire HIT Academics System efficiently</p>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="welcome-section">
                            <h5 class="mb-2">System Overview</h5>
                            <p class="mb-0 small">Monitor and control all system operations</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon students">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div class="stat-number"><?php echo $total_students; ?></div>
                    <div class="stat-label">Total Students</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon lecturers">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stat-number"><?php echo $total_lecturers; ?></div>
                    <div class="stat-label">Total Staff</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon programmes">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="stat-number"><?php echo $total_programmes; ?></div>
                    <div class="stat-label">Total Programmes</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon period">
                        <i class="fas fa-calendar"></i>
                    </div>
                    <div class="stat-number"><?php echo $active_period; ?></div>
                    <div class="stat-label">Active Period</div>
                </div>
            </div>

            <!-- Action Cards -->
            <div class="action-cards">
                <div class="action-card">
                    <div class="action-icon users">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <div class="action-title">Add Chairperson</div>
                    <div class="action-description">
                        Add, new departmental chairperson.
                    </div>
                    <a href="insert_chairperson.php" class="btn btn-primary">
                        <i class="fas fa-user-cog me-2"></i>Add Chairperson
                    </a>
                </div>
                <div class="action-card">
                    <div class="action-icon users">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <div class="action-title">Add Chairperson</div>
                    <div class="action-description">
                        Add, new exams officer.
                    </div>
                    <a href="insert_exams.php" class="btn btn-primary">
                        <i class="fas fa-user-cog me-2"></i>Add Chairperson
                    </a>
                </div>
                <div class="action-card">
                    <div class="action-icon programmes">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="action-title">Manage Programmes</div>
                    <div class="action-description">
                        Create and manage academic programmes in your faculty. 
                        Configure programme structures and requirements.
                    </div>
                    <a href="manage_programmes.php" class="btn btn-success">
                        <i class="fas fa-book me-2"></i>Manage Programmes
                    </a>
                </div>

                <div class="action-card">
                    <div class="action-icon programmes">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="action-title">Manage Weights</div>
                    <div class="action-description">
                        Create and manage academic programmes in your faculty. 
                        Configure programme structures and requirements.
                    </div>
                    <a href="select_module.php" class="btn btn-success">
                        <i class="fas fa-book me-2"></i>Manage Programmes
                    </a>
                </div>

                <div class="action-card">
                    <div class="action-icon programmes">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="action-title">Bulk Manage Weights</div>
                    <div class="action-description">
                        Configure assessment weights for multiple modules at once.
                    </div>
                    <a href="batch_weights_parallel.php" class="btn btn-success">
                        <i class="fas fa-book me-2"></i>Bulk Manage Weights
                    </a>
                </div>


                <!-- <div class="action-card">
                    <div class="action-icon periods">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="action-title">Academic Periods</div>
                    <div class="action-description">
                        Set active academic periods and manage semester configurations. 
                        Control when marks capturing is available.
                    </div>
                    <a href="manage_periods.php" class="btn btn-info">
                        <i class="fas fa-clock me-2"></i>Manage Periods
                    </a>
                </div> -->

                <!-- <div class="action-card">
                    <div class="action-icon settings">
                        <i class="fas fa-cogs"></i>
                    </div>
                    <div class="action-title">System Settings</div>
                    <div class="action-description">
                        Configure system parameters, backup data, and manage 
                        overall system configuration and security.
                    </div>
                    <a href="system_settings.php" class="btn btn-warning">
                        <i class="fas fa-tools me-2"></i>System Settings
                    </a>
                </div> -->
            </div>

            <!-- Quick Actions -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-bolt me-2"></i>
                                Quick Actions
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <a href="view_all_students.php" class="btn btn-outline-primary w-100 mb-3">
                                        <i class="fas fa-users me-2"></i>View All Students
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="system_reports.php" class="btn btn-outline-success w-100 mb-3">
                                        <i class="fas fa-chart-bar me-2"></i>System Reports
                                    </a>
                                </div>
                                <!-- <div class="col-md-3">
                                    <a href="backup_restore.php" class="btn btn-outline-info w-100 mb-3">
                                        <i class="fas fa-database me-2"></i>Backup & Restore
                                    </a>
                                </div> -->
                                <div class="col-md-3">
                                    <a href="audit_logs.php" class="btn btn-outline-warning w-100 mb-3">
                                        <i class="fas fa-history me-2"></i>Audit Logs
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
