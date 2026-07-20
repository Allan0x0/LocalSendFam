# HR Portal Test Guide: Plain Language

This is a hand-test plan for the HR portal, written so anyone can follow it without
knowing the codebase. Every claim here was checked against the actual code, so where a
button is dead or a page talks to a server route that does not exist, this guide says so
plainly.

**Who you test as:** the account `hr@hit.ac.zw`, password `password`. It holds two roles
at once: hr_manager and hr_officer. Together these open the whole HR portal, including
payroll.

**Where you test:** the live **staging** site (throwaway data). Never production.

**How to read each item:**
- **What it is**: plain description of the feature.
- **How to test**: what to do by hand.
- **Pass looks like**: what you should see if it works.
- **Known issue**: a problem we already know about. If you hit exactly this, it is *not*
  a new bug. Anything different *is* a new bug worth reporting.

**One thing to keep open the whole time:** your browser's developer tools, on the
**Network** and **Console** tabs. Several HR pages fail silently: the request errors, or
the page quietly shows made-up numbers, but nothing on screen tells you. The truth only
shows in Network (a red 4xx/5xx row) or Console.

---

## The big caveat before you start (read this)

HR does not have a payment gate the way admissions does, so most HR data (employees, leave,
recruitment) is really there and really works. But four kinds of surface are inert or
misleading on staging, and you must not mistake them for working features:

1. **Pages that silently show fake data when their server route is missing.** The
   **Analytics** page (§6.2) calls server routes that do not exist in the HR backend. When
   they 404, the page falls back to `Math.random()` and hardcoded numbers, so the charts
   look real but are invented and change on every reload. Only the plain **Dashboard**
   (§6.1) reads a real endpoint.

2. **A page whose server routes do not exist at all.** The **Onboarding** page (§11) talks
   to `/hr/onboarding` endpoints that live only in the developer mock layer, not the real
   backend. On staging it will 404 and show an empty or broken page.

3. **A payroll flow wired to the wrong backend contract.** The **Payroll Run Wizard** (§7.2)
   posts to a "runs" API that the backend does not have. The working payroll path is the
   plain **Payroll Runs** page plus the period detail page (§7.1). Use that, not the wizard.

4. **No money actually moves.** Payroll *computes* net pay and can *export* statutory files,
   but there is no bank or disbursement rail. Producing figures and CSV files is the end of
   the line; nobody gets paid. That is by design on staging, not a bug.

For all of these, test only the *mechanics* (does validation fire, does the empty state
show, are you blocked where you should be). Do not certify an end-to-end flow through any of
them.

---

## 1. Before you begin (environment check)

- [ ] The website loads.
- [ ] Log in works (you reach a page, not an error).
- [ ] You know how to reset the data if it gets messy: re-run the database seeders to
      return to a clean starting point. Ask a developer if unsure.
- [ ] Dev tools open on Network + Console (see above).
- [ ] You are on **staging**, not production, before creating or deleting anything.

---

## 2. What this account can and cannot reach (the key idea)

There are **two separate locks** in the system, and they do not always agree. Spotting
where they disagree is the single most valuable thing this test finds.

- **The front-end lock is by role.** It decides which sections of the site you can open.
  This account holds hr_manager and hr_officer, so it can open the **HR portal only**. It
  **cannot** open Admin, Academic, Student, or E-Learning. (Confirmed in
  `frontend/src/lib/portals.ts` and `frontend/src/lib/elearningAccess.ts`: the HR roles are
  not listed for any other portal, and are not in the e-learning access list.)
- **The back-end lock is by permission.** It decides what the server will actually let you
  do once a request reaches it. This account's permissions are: `hr.read`, `hr.write`,
  `hr.manage`, `payroll.read`, `payroll.periods.create`, `payroll.process`,
  `payroll.approve`, `payroll.payslips.view_all`.

**Why this matters:** because the account has `hr.manage`, almost every write in the HR
portal (create employee, approve leave, configure payroll definitions, run recruitment) is
allowed. And because it has the four payroll permissions, it can run the entire payroll
lifecycle: create a period, run it, approve it, finalise it, and export the statutory files.

> **The one permission it lacks: and why it does not matter here.** This account does
> **not** hold `payroll.write`. You might expect that to block payroll editing. It does not:
> searching the whole HR service, **no route is gated on `payroll.write`** (it appears only
> in test helper code, `services/hr/tests/Concerns/IssuesTestJwt.php`). Every payroll write
> the UI needs is gated on `hr.manage` (the definitions pages) or on the specific
> `payroll.*` permissions this account has. So the missing `payroll.write` blocks nothing
> you can reach. Note it, but do not expect a failure from it.

> **The other permission gap: webhooks.** The backend has a webhook manager gated on
> `hr.webhooks.manage` (`services/hr/routes/api.php:509`), which this account does **not**
> hold. But there is **no webhooks page in the front-end at all**, so you cannot reach it
> through the UI. If you probe the API directly you should get a 403. Otherwise ignore it.

---

## 3. Login and session

- [ ] **Log in** as `hr@hit.ac.zw`. You should land on `/hr` (the HR dashboard). This is the
      hr_manager landing preference in `portals.ts`.
- [ ] The sidebar shows HR sections only: Overview, People, Leave Management, Payroll,
      Payroll Definitions, Employee Lifecycle, Talent, Compliance, Configuration. No Admin,
      Academic, Student, or E-Learning links appear.
- [ ] **Refresh the page** mid-session. You stay logged in and stay in HR (the app re-checks
      your roles with the server on load).
- [ ] **Idle test:** the login token lasts 15 minutes (`services/auth/config/jwt.php`:
      `ttl` = 900 seconds). Leave a tab untouched for over 15 minutes, then click something.
      It should refresh quietly and keep working (revisit this in §12).
- [ ] **Log out**, then try to open an HR page directly by URL. You should be bounced to the
      login page.

---

## 4. Dashboard, Analytics, Org Chart (Overview)

### 4.1 (see §6 for the full Overview breakdown)

*(Overview items are numbered §6 below so payroll and people, the heavier areas, come
first. Jump to §6 for Dashboard, Analytics, and Org Chart.)*

---

## 5. Employees (People)

### 5.1 Employee list
**What it is:** a paginated, searchable table of employees; rows open a profile, and a
header button adds a new employee. (`EmployeeList.tsx`)
**How to test:** type in the search box; page through results; click a row; click Add
Employee.
**Pass looks like:** search is **debounced (300ms)** and runs against the server (no Enter
needed, no minimum characters); the table shows 10 per page with "Showing X-Y of N"; an
empty search shows "No employees match your search." A row opens `/hr/employees/:id`.

### 5.2 Employee create / edit
**What it is:** one form for both create and edit. (`EmployeeFormPage.tsx` +
`components/hr/EmployeeForm.tsx`, validated by `schemas/employeeSchema.ts`.)
**How to test:** create an employee with valid data, then edit one.
**Validation (real and strict, via zod):** first and last name at least 2 characters; a
valid email; EC number matching `EC-` then 3 to 6 digits; a department and a job grade
(both required); an employment type; a status; a hire date. Phone is optional but if given
must be 10 digits starting with 0. **Cross-field rule:** if employment type is "contract",
a contract end date becomes required.
**Pass looks like:** create and edit both persist (real POST/PUT as multipart form data),
show a toast, and navigate back to the list.
**Known issue:** after create or edit, **the list may not refresh on its own.** The form
clears the cache key `['employees']` but the list is cached under `['hr-employees']`
(`EmployeeFormPage.tsx:39,52` vs `EmployeeList.tsx:81`). Reload the list page to see your
change. This is a known cache-key mismatch, not a lost save.

### 5.3 Employee profile
**What it is:** a tabbed profile: Info, System Access, Leave, Payroll, Allowances,
Deductions, Contracts, Documents. (`EmployeeProfile.tsx`)
**How to test:** open a profile and click through every tab.
**Pass looks like:** Info, Leave, Payroll, Allowances, and Deductions all load real data.
Allowances support create, edit, toggle, and delete (with a confirm). Deductions support
create, edit, and toggle.
**Known issues:**
- **Deductions have no delete** (edit only; `EmployeeProfile.tsx:726`).
- **Contracts and Documents tabs are stubs.** They render the text "Contracts: coming in
  next sprint." and "Documents: coming in next sprint." (`EmployeeProfile.tsx:46-52`,
  `990-991`). Do not test them.
- The **Payroll tab uses a raw `fetch('/api/v1/...')`** instead of the shared client
  (`EmployeeProfile.tsx:72`), so it skips the auth and refresh handling every other call
  uses. Watch the Network tab; if it 401s where other tabs succeed, that is why.

### 5.4 System Access (provision a login) and the cross-service handoff
**What it is:** the System Access tab on a profile creates or updates a login account for
that employee, assigning roles. (`POST /hr/employees/:id/account`.)
**Also cross-service:** creating an employee at all (§5.2) publishes an
`employee_onboarded` event on the Redis event bus
(`services/hr/app/Services/EmployeeService.php:45` via `HrEventPublisher.php:31`). Two other
services listen: **auth** provisions a login account
(`services/auth/app/Services/StaffProvisioningService.php`), and **notification** sends a
welcome email (`services/notification/app/Listeners/SendWelcomeEmployeeListener.php`).
**How to test:** create an employee with a valid email, then check (with a developer) that a
login account and a welcome email were produced downstream. This is the key handoff between
three services.
**Validation:** System Access blocks saving with no role selected ("Select at least one
role"; button disabled until a role is picked).
**Pass looks like:** the account is created/updated with a toast, and the downstream login
and email appear.

### 5.5 Qualification verification queue
**What it is:** a queue of employee qualifications awaiting verification; verify or reject
with a reason. (`QualificationVerificationQueue.tsx`, gated on `hr.manage`.)
**How to test:** verify one; reject one (reason required).
**Pass looks like:** real mutations with optimistic removal from the queue and rollback on
error; empty state "No qualifications pending verification."
**Known issue:** there is **no link to the actual certificate document** in the queue, even
though these are academic certificates being verified. You verify blind.

---

## 6. Overview pages (Dashboard, Analytics, Org Chart)

### 6.1 HR dashboard
**What it is:** the HR landing page: KPI cards, two department charts, a recent-hires list,
and a pending-leave table. (`HRDashboard.tsx`)
**How to test:** open `/hr/dashboard`. It calls `GET /hr/dashboard/stats`, which is a real
endpoint gated on `hr.manage` (`services/hr/routes/api.php:98`), which this account has.
**Pass looks like:** cards and lists fill from real data; empty sections show messages like
"No recent hires in the last 30 days" and "No pending leave requests."
**Known issues:**
- Before data loads, or if the call fails, the page shows a **hardcoded fallback set of
  KPI cards** with fake values (247 employees, 12 pending leave, 5 vacancies, payroll "On
  Track", next run "31 May 2026"; `HRDashboard.tsx:60-106`). The payroll-status and
  next-run cards **exist only in this fake set** and never appear once real data loads.
- The per-row **eye button on the pending-leave table is inert** (no click handler;
  `HRDashboard.tsx:424-426`).

### 6.2 HR analytics
**What it is:** an analytics dashboard: headcount trend, leave utilisation, and
payroll-by-department charts with a USD/ZWG toggle. (`HRAnalytics.tsx`)
**Known issue (important):** this page calls `GET /hr/dashboard`,
`/hr/analytics/headcount-trend`, `/hr/analytics/leave-utilisation`, and
`/hr/analytics/payroll-by-department`. **None of these routes exist in the HR backend**
(they are not in `services/hr/routes/api.php`; a code-wide search finds no controller for
them). When they 404, three of the four charts **silently fall back to invented data**:
headcount uses `Math.random()` so it shows **different numbers on every reload**, and leave
and payroll use hardcoded rows (`HRAnalytics.tsx:293-324`; ZWG is just USD times 25, not a
real rate). So the page looks like it works but is fiction. Confirm in the Network tab that
these calls 404, and treat every chart here as unverified.

### 6.3 Org chart
**What it is:** a collapsible department-and-employee tree with client-side search.
(`OrgChart.tsx`)
**How to test:** expand and collapse; type in the search box.
**Pass looks like:** the tree renders. It first tries `GET /hr/org-chart` (which also does
**not** exist in the backend), then **falls back to `GET /hr/employees?per_page=500`** and
builds the tree client-side (`OrgChart.tsx:66,70`). So it works via the fallback, on real
employee data. Search is client-side, on every keystroke, matching name / EC number /
position / department.

---

## 7. Payroll

The real backend lifecycle for a payroll period is: **create period → run (compute) →
approve → finalise (confirm) → export statutory files / download payslip PDFs.** This
account holds every permission this needs (`payroll.periods.create`, `payroll.process`,
`payroll.approve`, `payroll.payslips.view_all`). Note there is **no money-movement step**;
it ends at figures and files.

### 7.1 Payroll runs (the working path)
**What it is:** the list of payroll periods, with per-currency totals, and the buttons to
create, run, and approve. (`PayrollDashboard.tsx`; the period detail and finalise live on
`PayrollRunPage.tsx`.)
**How to test:**
1. Create a period (the Create button is disabled until name, start, and end are all
   filled). This calls the real `POST /hr/payroll/periods`.
2. On a **draft** period, click Run. This calls the real `POST /hr/payroll/periods/{id}/run`
   (`api/hr.ts:146`), which computes net pay for every **active** employee. The period moves
   to "submitted".
3. On a **submitted** period, click Approve (`PUT /hr/payroll/periods/{id}/approve` with
   action "approve"). It moves to "approved".
4. Open the period (`PayrollRunPage`) and click Finalize on a period; it calls
   `POST /hr/payroll/{id}/finalize` and moves to "confirmed".
**Pass looks like:** each step advances the status and the buttons for the next step appear.
The backend enforces the order (run only from draft/submitted, approve only from submitted,
finalise only from approved), so out-of-order actions return a clear 422.
**Things to probe:**
- Run computes only for employees with `status = active`; an employee missing a salary grade
  is **skipped** and reported in the response `errors` list, not failed. If nothing computes,
  check that employees are active and have grades.
- The **row checkboxes / select-all on the period detail page are inert** (state is tracked
  but no action uses it; `PayrollRunPage.tsx`). Dead UI.
- Create/run/approve buttons are shown only to hr_manager; this account qualifies.

### 7.2 Payroll Run Wizard
**What it is:** a 3-step wizard (select period → preview → approve and finalise).
(`PayrollRunWizard.tsx`)
**Known issue: do not use this path.** The wizard posts to
`POST /hr/payroll/periods/{id}/runs`, `POST /hr/payroll/runs/{id}/process`, and
`POST /hr/payroll/runs/{id}/approve` (`PayrollRunWizard.tsx:78,89,100`). **None of these
"runs"-based routes exist in the backend** (`services/hr/routes/api.php` only has the
period-based routes used in §7.1). So the wizard will 404 at the first "Create & Process
Run" step. Use the Payroll Runs page (§7.1) instead. Report only if it fails *differently*.

### 7.3 Payslips
**What it is:** a month/year-filtered list of all employees' payslips, with View and
Download PDF. (`PayslipPage.tsx`; single payslip in `PayslipViewer.tsx`.)
**How to test:** pick a month and year; click View; click Download PDF.
**Pass looks like:** the list reads the real `GET /hr/payslips/all` (gated on
`payroll.payslips.view_all`, which this account has). View opens the payslip. Download PDF
calls the real `GET /hr/payroll/periods/{periodId}/payslips/{employeeId}/pdf`, which streams
a genuine server-generated PDF (unlike the admin portal's print-only "PDF").
**Known issues:**
- **PDF download failures are silent** on this page and in the wizard (the error is
  swallowed by an empty `catch`; `PayslipPage.tsx:138`). If nothing downloads, check the
  Network tab. Only the single-payslip viewer shows an alert on failure.
- The year dropdown is **hardcoded to 2024-2026** (`PayslipPage.tsx:58`); today is
  2026-07-20, so 2027 is not selectable.
- In the single-payslip viewer, several fields are **placeholder, not real data**: the NSSA
  employer contribution is computed on the client as the employee deduction times 3.5/3
  (`PayslipViewer.tsx:279-280`), and the leave summary, loan summary, employer name, and pay
  method are hardcoded. The core earnings and deductions figures are real; these specific
  panels are not. Print here uses the browser print dialog.

### 7.4 Payroll definitions (salary grades, allowance types, deduction types)
**What it is:** three configuration pages under Payroll Definitions. (`SalaryGrades.tsx`,
`AllowanceTypes.tsx`, `DeductionTypes.tsx`; all gated on `hr.manage`.)
**How to test:** create, edit, and (where allowed) delete in each.
**Pass looks like:** all three persist via real mutations against `/hr/payroll/*` routes.
Allowance and deduction types support create, edit, delete (with a confirm dialog, and the
backend error surfaced in an alert), plus plan tiers and bulk-assign to employees. Salary
grades support create and edit, and link allowances/deductions per grade.
**Known issue:** **salary grades cannot be deleted**: there is an Edit button but no delete
anywhere on that page (`SalaryGrades.tsx`). Allowance and deduction types *can* be deleted.
**Validation:** grade needs a code and a title; allowance/deduction type needs a code and a
name (code auto-uppercased); bulk-assign needs at least one employee plus a plan or a custom
amount.

### 7.5 Statutory exports (ZIMRA / NSSA): present in backend, missing in UI
**What it is:** the backend can export ZIMRA PAYE and NSSA contribution CSV files for a
period (`services/hr/routes/api.php:290-293`, gated on `payroll.process`, which this account
has; the export returns a real streamed CSV or a 422 if the period has no runs).
**Known issue:** **no front-end page or button calls these exports.** The feature exists on
the server but has no UI. You cannot test it from the browser; a developer would need to hit
the API directly. Note the gap.

---

## 8. Leave management

### 8.1 Leave calendar
**What it is:** a month grid of approved team leave, colour-coded by leave type.
(`LeaveCalendar.tsx`, reads `GET /hr/leave/applications` filtered to approved.)
**Pass looks like:** approved leave shows as coloured dots; prev/next month navigation
works; on error a "Failed to load leave data." banner with Retry appears. Read-only.

### 8.2 Request leave
**What it is:** self-service to view your own balances and submit a leave request.
(`LeaveRequestPage.tsx`)
**How to test:** submit a request.
**Validation:** start date, end date, and reason are all required; end date cannot precede
start; the **Submit button is disabled if the requested days exceed your remaining balance**
(an over-balance warning shows). Duration is counted inclusive of both ends.
**Pass looks like:** a real `POST /hr/leave/applications`; on success the form resets and
balances refresh. The Cancel button just navigates away (it is not a mutation).
**Known issue (minor):** the leave-type dropdown here is a **hardcoded list**
(`LeaveRequestPage.tsx:16-22`) separate from the API-managed types in §8.4, so the two can
drift. Worth a consistency check.

### 8.3 Leave approval queue
**What it is:** the queue of pending requests, with approve and reject dialogs.
(`LeaveApprovalQueue.tsx`)
**How to test:** approve one (comment optional); reject one (reason required).
**Pass looks like:** both are real mutations (`PUT /hr/leave/applications/{id}/approve` and
`.../reject`; `api/hr.ts:121,128`: both use correct paths) with optimistic updates and
rollback on failure; the queue refreshes. Actions show only to hr_manager / hr_officer,
which this account is. Empty state "No pending applications."

### 8.4 Leave types (Configuration)
**What it is:** admin CRUD for leave-type definitions plus a per-type approval-chain
dialog. (`LeaveTypes.tsx`, gated on `hr.manage`.)
**How to test:** create, edit, deactivate a leave type; configure an approval chain.
**Pass looks like:** all persist via real mutations. "Delete" is a **soft deactivate** (the
type shows Inactive, not removed) and asks for confirmation.
**Known issue (weak validation):** the save handler does **no client-side required-field
check** (`LeaveTypes.tsx:199-205`), so an empty name or label can be submitted and the
server must reject it. The approval-chain dialog also lets you save an empty chain. The
approver-role dropdown is a hardcoded role list that can drift from real roles.

### 8.5 Department leave view
**What it is:** a read-only per-department leave overview with department / year / status
filters and expandable approval-step rows. (`DepartmentLeaveView.tsx`)
**Pass looks like:** filters are real and server-side; expanding a row lazily loads its
approval steps; empty state "No leave requests found for this department."
**Known issue (minor):** the year input is a free number field with no range guard; any
value refetches.

---

## 9. Talent (recruitment, training, disciplinary, budgets)

### 9.1 Vacancy board
**What it is:** a card grid of vacancies with manager-only create/edit/delete, and links
into applications, ranking, and evaluation. (`VacancyBoard.tsx`)
**How to test:** create a vacancy, edit it, delete it (confirm dialog).
**Validation:** only the **title** is required; the Submit button is disabled until title is
non-empty. Everything else (department, grade, closing date, positions) is optional.
**Pass looks like:** create/edit/delete all persist via real mutations against
`/hr/recruitment/vacancies`; empty state "No open vacancies at the moment." with a "Post the
first vacancy" button.
**Known issue (minor):** the status dropdown offers only open/closed/filled, so a vacancy
that arrives in "draft" status cannot be changed from the board.

### 9.2 Recruitment kanban (application pipeline)
**What it is:** a drag-and-drop board grouping applications into five status columns.
(`RecruitmentKanban.tsx`)
**How to test:** drag a card to another column.
**Pass looks like:** the move **persists**: dropping into a column fires
`PUT /hr/applications/{id}` with the new status and refetches.
**Known issue:** the code comments claim an "optimistic" update but there is **none**
(`RecruitmentKanban.tsx:72`); the card only moves after the refetch completes, so expect a
visible lag and no rollback if the save fails. Also note the column names here (screening,
offer) differ from the status words used on the recruitment dashboard (screened,
shortlisted, selected): a taxonomy inconsistency, not a failure.

### 9.3 Recruitment dashboard
**What it is:** recruitment analytics: stats, a funnel, a paginated applicant table,
reports, an audit trail, and background exports. (`RecruitmentDashboard.tsx`)
**How to test:** open it; request an export (pick a type and a format).
**Pass looks like:** the stat/funnel/table/report/audit sections read real endpoints
(`/hr/recruitment/dashboard`, `/applicants`, `/reports`, `/audit-logs`;
`api/hr.ts:263-293`, all correct forward-slash paths). Export uses the proper
**request-then-poll-then-download** pattern: it POSTs `/hr/recruitment/exports`, polls the
status up to 30 times at 1-second intervals, and downloads the blob when ready. This is a
**real, working** export (unlike the admin portal's dead download buttons).

### 9.4 Recruitment ranking
**What it is:** automated candidate ranking per vacancy, with editable screening-rule
weights and a per-criterion score breakdown. (`RecruitmentRanking.tsx`)
**How to test:** edit weights (clamped 0-100), Save, then Re-score.
**Pass looks like:** Save (`PUT .../screening-rules`) and Re-score (`POST .../rescore`) are
real calls with toast feedback; empty state "No applicants scored yet."

### 9.5 Recruitment evaluation and shortlisting
**What it is:** recruiter evaluation, criteria editor, auto-shortlist, combined ranking,
per-applicant scoring, and workflow-stage changes. (`RecruitmentEvaluation.tsx`)
**How to test:** save criteria, then score an applicant, set a stage, toggle a manual
shortlist, run auto-shortlist.
**Validation:** submitting an evaluation requires at least one scored criterion ("Score at
least one criterion"); the evaluate panel only appears once criteria are saved.
**Pass looks like:** every action is a real call against `/hr/recruitment/...` with toast
feedback and a refresh.
**Thing to probe:** auto-shortlist always sends both `top_n` and `threshold` set to the same
value regardless of mode (`RecruitmentEvaluation.tsx:41`); confirm the backend picks the
right one and does not mis-shortlist.

### 9.6 Training requests
**What it is:** a list of training requests with a multi-stage approval flow (HOD approve →
HR approve → Complete) plus reject. (`TrainingRequests.tsx`)
**How to test:** create a request (employee, course, cost required); move it through the
stages; reject one (reason required).
**Pass looks like:** all stages are real mutations; the right action buttons show per status;
empty state "No training requests found."

### 9.7 Disciplinary cases
**What it is:** a list of cases with create and a status-transition workflow.
(`DisciplinaryCases.tsx`, gated on `hr.manage`.)
**How to test:** report a case (employee, category, description, incident date required);
move it through the allowed next statuses.
**Pass looks like:** create and update are real; transitions are limited to the allowed next
states; empty state "No disciplinary cases found."

### 9.8 Department budgets
**What it is:** per-department training budgets by fiscal year, with a utilisation bar.
(`DepartmentBudgets.tsx`)
**How to test:** allocate or edit a budget.
**Validation:** save needs department, fiscal year, and amount; when editing an existing
budget only the amount is editable.
**Known issue:** the department dropdown is **built only from departments that already have
a budget in the selected year** (`DepartmentBudgets.tsx:104-113`), so a department with no
budget yet **cannot be selected to create its first one**. Verify whether that is intended.

---

## 10. Employee lifecycle (probation, terminations, contracts)

All three are gated on `hr.manage`, which this account has. All actions are real mutations
with no stubs.

### 10.1 Probation tracker
**What it is:** probation records with create, extend, confirm, terminate, and a
"due for review" banner. (`ProbationTracker.tsx`)
**How to test:** create (employee, start, end required); extend, confirm, terminate.
**Known issue (minor):** no cross-field date check: an end date before the start date is
accepted.

### 10.2 Termination management
**What it is:** terminations with an expandable per-row clearance checklist; each item is
cleared or marked not-applicable, then the termination is completed.
(`TerminationManagement.tsx`)
**How to test:** initiate a termination (employee, type, effective date required); clear each
checklist item; complete.
**Pass looks like:** "Complete Termination" appears only once every item is processed and the
status is not already complete.

### 10.3 Contract tracker
**What it is:** contracts expiring within a chosen window, with a renew action.
(`ContractTracker.tsx`)
**How to test:** pick a window (30/60/90/180 days); renew a contract (start date required).
**Known issue (minor):** no check that the new end date is after the new start date.

---

## 11. Onboarding

**What it is:** a page meant to track new-hire onboarding checklists. (`OnboardingPage.tsx`)
**Known issue: mock-only, will not work on staging.** This page calls `GET /hr/onboarding`
and `PUT /hr/onboarding/{id}/update-checklist`. **These routes exist only in the developer
mock layer** (`frontend/src/mocks/handlers.ts:2797-2810`); there is **no backend route** for
them in `services/hr/routes/api.php`. The mock layer runs only in local development, not on
staging. So on staging the page will 404 and show its empty state ("No employees in
onboarding") or an error. Do not test onboarding as a working feature; confirm only that it
degrades to the empty state rather than crashing.

---

## 12. Performance reviews

**What it is:** a dashboard of performance reviews with four stat cards, a review list, and a
per-review metrics panel. (`PerformanceReviewPage.tsx`)
**How to test:** open `/hr/performance`; click a review row.
**Pass looks like:** it reads the real `GET /hr/performance-reviews` (a real flat route,
`services/hr/routes/api.php:394`); selecting a review shows its metrics.
**Known issue:** this page is **read-only**. The **"New Review" button is inert** (no click
handler; `PerformanceReviewPage.tsx:116-119`), and the per-row eye "view" button is also
inert (`254-256`; the row's own click selects it). There is **no create, edit, or delete**
here at all. The four stat cards are computed from the fetched list, so they all read 0 when
the list is empty.

---

## 13. Configuration (HR settings)

**What it is:** a key/value table of system-wide HR settings. (`HrSettings.tsx`, gated on
`hr.manage`; also holds the Leave Types page, §8.4.)
**How to test:** add a setting, edit one inline, delete one (confirm dialog).
**Pass looks like:** all three persist via real mutations against `/hr/settings`.
**Known issues (minor):** a new row's Save is disabled until a key is entered, but the
**inline edit Save has no guard**, so you can save an empty value. The edit trigger on an
existing row uses a floppy-disk (save) icon rather than a pencil, which is misleading.

---

## 14. Things that must be blocked (negative tests)

The front-end blocks by role, and there is no override for HR, so:

- [ ] Type `/admin` (and sub-pages) into the URL → you should be redirected to
      `/dashboard`. This account has HR permissions only; it is not in the Admin portal
      roles.
- [ ] Type `/academic` → redirected to `/dashboard`.
- [ ] Type `/student` → redirected to `/dashboard`.
- [ ] Type `/elearning` → redirected. The HR roles are **not** in `ELEARNING_ACCESS_ROLES`
      (`frontend/src/lib/elearningAccess.ts`), so e-learning is blocked. (Confirm the
      redirect target: the ProtectedRoute guard bounces unauthorised users; the admin guide
      documents `/dashboard`.)
- [ ] Confirm no Admin / Academic / Student / E-Learning menu items appear anywhere in the
      HR sidebar.
- [ ] **Optional deeper check:** the HR portal itself has a second guard,
      `HRRoleGuard`, that shows an "Access Denied" screen (not a redirect) if a
      non-HR-role user reaches `/hr`. Since this account holds HR roles it passes; a
      differently-roled account should hit the Access Denied page instead.

---

## 15. The permission-timing trap (subtle but important)

Your roles and permissions are **stamped into your login token when you log in.** Services
trust that token and do not re-check on every request. (Same auth service as the admin
portal; `services/auth/config/jwt.php`.)

- [ ] Give a test user a new role, then log in **as that user immediately** in another
      browser. They will still have the **old** access. This is correct behaviour, not a bug.
- [ ] Have them log out and back in (or wait past the 15-minute token life). The new access
      now takes effect. **Always re-issue the token before checking a permission change** : 
      testing too quickly shows stale access and looks like a bug.
- [ ] Note: there is **no instant force-revoke** when a role changes. A still-valid token
      keeps working until it expires (15 minutes for the access token; the refresh token
      lasts 14 days).
- [ ] Note for security review: revocation is **fail-open**: if the cache (Redis) is down,
      revoked tokens are still accepted. (Same behaviour documented for the admin portal.)

---

## 16. Known issues at a glance (do NOT report these as new bugs)

If you hit exactly one of these, it is expected. A *different* failure is a new bug.

**Server routes that do not exist (page shows fake or empty data):**
1. **Analytics** (§6.2): `/hr/dashboard` and `/hr/analytics/*` routes do not exist; the
   page silently shows random / hardcoded chart data (`HRAnalytics.tsx:293-324`).
2. **Onboarding** (§11): `/hr/onboarding` routes exist only in the dev mock layer
   (`mocks/handlers.ts:2797-2810`), not the backend; 404s on staging.
3. **Payroll Run Wizard** (§7.2): posts to a "runs" API the backend does not have
   (`PayrollRunWizard.tsx:78,89,100`); use the Payroll Runs page instead.
4. **Org chart** (§6.3): `/hr/org-chart` does not exist, but the page falls back to
   `/hr/employees` and works (`OrgChart.tsx:66,70`).

**Dead / stub / read-only UI:**
5. **Performance reviews** (§12): read-only; "New Review" and the row eye button are inert
   (`PerformanceReviewPage.tsx:116-119, 254-256`).
6. **Employee profile** (§5.3): Contracts and Documents tabs are "coming in next sprint"
   stubs (`EmployeeProfile.tsx:46-52`); deductions have no delete.
7. **HR dashboard** (§6.1): hardcoded fallback KPI cards (247/12/5/On Track/31 May 2026);
   pending-leave eye button inert (`HRDashboard.tsx:60-106, 424-426`).
8. **Salary grades** (§7.4): no delete (edit only).
9. **Payroll period detail** (§7.1): row checkboxes / select-all are inert.
10. **Statutory exports** (§7.5): ZIMRA/NSSA export exists in the backend but has no UI.

**Data / behaviour quirks:**
11. **Employee create/edit** (§5.2): list does not auto-refresh (cache-key mismatch
    `['employees']` vs `['hr-employees']`); reload to see the change.
12. **Payslip viewer** (§7.3): NSSA employer contribution, leave summary, loan summary,
    employer name, and pay method are placeholder, not real (`PayslipViewer.tsx:279-280`).
13. **Payslip PDF download failures are silent** (§7.3) on the list and wizard; only the
    single-payslip viewer alerts.
14. **Payroll tab** on the employee profile uses a raw `fetch('/api/v1/...')` that skips the
    shared auth handling (`EmployeeProfile.tsx:72`).
15. **Recruitment kanban** (§9.2): no real optimistic update despite the comment; laggy card
    moves, no rollback.
16. **Department budgets** (§9.8): cannot allocate a first budget to a department that has
    none yet in the selected year.
17. **Leave types** (§8.4): no client-side required-field validation; empty leave type or
    empty approval chain can be submitted.
18. **Payslips year dropdown** hardcoded to 2024-2026 (`PayslipPage.tsx:58`).
19. Hardcoded leave-type lists appear in three places independent of the API-managed types
    (leave request, calendar legend, approval-queue badges) and can drift.

**Permission notes (not bugs):**
20. This account lacks `payroll.write`, but **no HR route requires it**, so nothing breaks
    (§2).
21. The webhook manager needs `hr.webhooks.manage` (not held) and has **no UI**; a direct
    API call would 403 (§2).

---

## 17. Sign-off

- [ ] All the normal (happy-path) checks in §3-§13 pass, ignoring the known issues in §16.
- [ ] All the "must be blocked" checks in §14 are confirmed blocked (including `/elearning`).
- [ ] You understand and have verified the permission-timing behaviour in §15.
- [ ] The four inert/fake surfaces in the big caveat (Analytics, Onboarding, Run Wizard, no
      disbursement) were confirmed to degrade safely, not certified as working.
- [ ] No *new* (undescribed) failures found: or each new one logged separately.

Tester: __________   Date: __________   Build/commit: __________
