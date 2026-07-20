# HOD Portal Test Guide: Plain Language

This is a manual test plan anyone can follow without knowing the codebase. It covers the
Head of Department (HOD) account: what it can reach, what works, and what is a known stub.

**Who you test as:** the account `hod@hit.ac.zw` (seeded as "Dr. T. Mturirio"). It holds
two roles at once: **lecturer + hod**. So it can do everything a lecturer can, plus the HOD
powers. Password: `password`.

**Where you test:** the live **staging** site (throwaway data). Never production.

**How to read each item:**
- **What it is**: plain description of the feature.
- **How to test**: numbered steps to do by hand.
- **Pass looks like**: what you should see if it works.
- **Known issue**: a bug we already know about. If you hit exactly this, it is *not* a
  new bug. Anything different *is* a new bug worth reporting.

**One thing to keep open the whole time:** your browser's developer tools, on the
**Network** and **Console** tabs. Several pages fail silently: the request errors but no
message appears on screen. The error only shows in Network (a red 4xx/5xx row) or Console.

---

## The big caveat before you start (read this)

Staging has **no payment system connected**. Almost the entire student lifecycle is gated
on payment, so a lot of downstream data simply does not exist yet:

- No exam results, no module marks, no graduates, and **no paid applicants to select**.
- So these pages **will look empty**: your HOD Dashboard counts, the Marks Approval queue,
  Applicant Selection, Student Performance, Exemptions, Class Attendance, and anything built
  from marks.

**Empty here means "no data", not "broken".** For those pages, test only the *mechanics*:
do filters work, does validation fire, does the empty-state message show, are you blocked
where you should be. Do not expect a full mark-to-graduation flow to work unless a developer
first seeds module assignments, marks, and a department you actually head.

**One extra dependency for the HOD:** most HOD powers are **scoped to the department you
head** (on the back-end, "the department whose `hod_id` is you"). If the seeded HOD account
is not set as the head of any department, your Marks Approval queue and Student Performance
will be **empty even if marks exist**, and any approval attempt will be refused as
out-of-department. Ask a developer to confirm you head a department before testing approvals.

---

## 1. Before you begin (environment check)

- [ ] The website loads.
- [ ] Log in works (you reach a page, not an error).
- [ ] You know how to reset the data if it gets messy: re-run the database seeders to
      return to a clean starting point. Ask a developer if unsure.
- [ ] Dev tools open on Network + Console (see above).
- [ ] (For approval tests) a developer has confirmed you are the head of at least one
      department and there are pending marks in it.

---

## 2. What this account can and cannot reach (the key idea)

There are **two separate locks** in the system, and they do not always agree. Spotting
where they disagree is the single most valuable thing this test finds.

- **The front-end lock is by role.** It decides which sections of the site you can open.
  This account can open the **Academic** portal and **E-Learning** only. It **cannot** open
  the Admin, HR, or Student portals.
- **The back-end lock is by permission.** It decides what the server actually lets you do.
  The HOD holds: `academics.read`, `academics.write`, `students.read`,
  `marks.approve.coursework`, `results.decisions.propose`, `modules.assign`,
  `exemptions.review.department`, plus the e-learning permissions
  (`elearning.view.hod`, `elearning.obe.chairperson`, `elearning.view.lecturer`).

**What the HOD adds over a plain lecturer.** In one line each:
- **Coursework approval.** Approve or reject the coursework marks lecturers submit, for
  your department. This is your main governance step.
- **Propose result decisions.** Propose transcript decisions (Pass/Fail/Supplementary etc.)
  to the Academic Board, limited to your own department.
- **Department exemption review.** Approve or reject course-exemption applications at the
  department stage.
- **Applicant selection.** Recommend accept/waitlist/reject on paid applicants for your
  programmes (admissions selection step).
- **OBE chairperson tools** in e-learning (programme learning outcomes, portfolio review).

**One thing the HOD does NOT have, despite the name "academics.write".** The academic-
structure screens (create/edit schools, departments, programmes, modules, regulations) live
in the Admin portal, which the HOD cannot reach at all. And even if reached, the server
gates those writes on a *different* permission (`academics.manage`), which the HOD does not
hold. So the HOD cannot change academic structure.

**The marks governance chain (for context).** A mark moves like this:
lecturer enters marks → **chairperson/HOD approves coursework (and forwards exam marks to
the dean)** → dean approves exam marks → exams-office verifies → academic board (VC)
approves → registry publishes → student sees it. **This account owns the second step.** It
cannot approve exam marks (that is the dean), verify, do board approval, or publish.

---

## 3. Login and session

- [ ] **Log in** as `hod@hit.ac.zw`. You should land on the **HOD Dashboard**
      (`/academic/hod`).
- [ ] The left menu shows academic items for a HOD (Dashboard, HOD Dashboard, Applicant
      Selection, Marks Approval, Modules, Student Records, Exemptions, Attendance,
      Timetable, Settings) plus **E-Learning** and **My Portal**. There is **no** Admin,
      HR, or Student menu.
- [ ] **Refresh the page** mid-session. You stay logged in and stay in the academic portal
      (the app re-checks your roles with the server on load).
- [ ] **Idle test:** the login token lasts 15 minutes. Leave a tab untouched for over 15
      minutes, then click something. It should refresh quietly and keep working (revisit
      this in §12).
- [ ] **Log out**, then try to open an academic page directly by URL. You should be bounced
      to the login page.

**Menu-vs-landing quirk to note:** you land on `/academic/hod` (the real HOD dashboard),
but the sidebar **"Dashboard"** link points to `/academic`, a **different, hardcoded page**
(see §11). Clicking "Dashboard" does not return you to the HOD dashboard.

---

## 4. HOD Dashboard (`/academic/hod`)

**What it is:** your home page. Tiles for Total Lecturers, Total Students, Total Modules,
and Pending Approvals, plus a Quick Actions card and a Department Overview card.
**How to test:**
1. Log in; you land here.
2. Confirm the tiles render (they read your department's real figures).
3. Click **Review Pending Marks** → goes to the Marks Approval queue (§5).
4. Click **Manage Modules** → goes to the Modules list (§9).
**Pass looks like:** tiles show counts for the department you head; the two Quick Action
buttons navigate correctly.
**Empty state:** if you head no department, the tiles show 0 and the department name is
blank. That is a data state, not a bug.

---

## 5. Marks Approval (`/academic/marks-approval`): the step you own

**What it is:** the queue of **pending coursework marks** (and pending exam marks) submitted
by lecturers in your department, waiting for your decision.
**How to test:**
1. Open Marks Approval from the menu or the HOD dashboard.
2. Filter by module or lecturer (free-text, case-insensitive).
3. Click **Review** on a row to open the approval dialog; approve (optional comment) or
   reject (comment required).
4. Or tick several rows and use **Approve (N)** / **Reject (N)** for a bulk action. Bulk
   approve asks for a confirm; bulk reject prompts for a reason.
5. Click **Workflow** on a row to see that mark's pipeline stages and history.
**Pass looks like:** the approved/rejected mark leaves the pending queue. A **coursework**
mark you approve becomes "approved"; an **exam** mark you approve is **forwarded to the dean**
(status "pending dean"): the HOD is the first checkpoint for exam marks too.
**What the server enforces (probe these):**
- You can only act on marks for **your own department**. A mark outside it is refused with
  **403 "You may only verify marks for your own department."**
- Only **pending** marks can be approved or rejected (422 otherwise).
- Approving needs the coursework permission; a plain lecturer hitting this endpoint gets a
  **403**.
**Empty state:** **empty on staging** (no marks exist, or you head no department). The
approval mechanics cannot be exercised without seeded data.

---

## 6. Applicant Selection (`/academic/selection`)

**What it is:** the admissions selection step. A list, grouped by programme, of **paid,
un-reviewed first-choice applicants** for your programmes. You recommend Select, Waitlist,
or Reject; admissions finalises afterwards.
**How to test:**
1. Open Applicant Selection.
2. Expand an applicant row to see their details, qualifications, and documents.
3. Click **Select**, **Waitlist**, or **Reject**.
**Pass looks like:** a toast confirms the recommendation and the row updates.
**Empty state:** **empty on staging**: applicants only appear once they have **paid** and
selection is **open** for the programme. With no payment rail, expect "No applicants
awaiting selection." An error banner ("You may not have any programmes assigned, or
selection is closed") means exactly that: you head no programmes, or selection is closed.
This reads the student service, so confirm that service is up if it errors.

---

## 7. Course Exemption Review (`/academic/exemptions`): department stage

**What it is:** exemption applications routed Department → School → Senate (HIT §10). As a
HOD you act on the **Department** stage.
**How to test:**
1. Open Exemptions; filter by status if you like.
2. Click a row to open the review dialog. It shows the source course, syllabus-match %, and
   regulation checks (thresholds read from the active regulation, not hardcoded).
3. If the application is at the **Department** stage, you see Approve / Reject controls.
   Reject requires a reason.
**Pass looks like:** approving advances the application to the School stage (or to Senate if
required); rejecting closes it with your reason. The server also gates this: it only lets
the department-review permission act on a department-stage application.
**What you cannot do:** act on an application already at the **School** or **Senate** stage.
The dialog shows "Awaiting School/Senate review. You cannot act on this stage." (The School
stage belongs to the dean; Senate to the board.)
**Empty state:** **empty on staging** ("No exemption applications to review.").

---

## 8. Student Performance (`/academic/hod/students/performance`)

**What it is:** a department-wide academic overview: stat cards (Total Students, First
Class+, Average CGPA, At Risk), a GPA distribution chart, a filterable/sortable table, and
an **Export CSV** button that actually works (it builds the file in your browser).
**How to test:** open it from the HOD dashboard area; try the search, programme, and status
filters; sort by CGPA or name; click **Export CSV**.
**Pass looks like:** the table filters and sorts; Export downloads a CSV.
**Empty state:** the page **swallows a failed fetch and shows an empty table** on staging
(no marks). "No students match the filters." is expected. This sub-page is HOD-gated on the
front-end, so a plain lecturer is redirected away from it.

---

## 9. Modules, Student Records, Attendance (shared academic pages)

These behave the same as for any academic user; the HOD gets no extra write power here.

### 9.1 Modules (`/academic/modules`)
Read-only, searchable list (search by code/name; filter by semester). **Known issue:** the
**"View Details" button does nothing**; despite the "manage" wording there is no
create/edit/delete. The HOD dashboard's "Manage Modules" button lands here. Because the HOD
also holds the lecturer role, module cards still show an **Enter Marks** shortcut.

### 9.2 Student Records (`/academic/students`)
Read-only, searchable table of enrolled students. **Known issue:** the **"Export" and per-row
"View Details" buttons do nothing.** Empty on staging.

### 9.3 Class Attendance (`/academic/attendance`)
Read-only eligibility view: pick a module, set semester and year, see each student against
the exam-eligibility bar. No way to record attendance here. Empty on staging.

### 9.4 Marks Entry (`/academic/marks-entry/{moduleId}`)
Because the HOD also holds the lecturer role, you can enter marks on modules assigned to you
(same working screen a lecturer uses: assessment tabs, auto-save on blur, submit for
approval, grade/pass badges, class-list and bulk-upload). Empty student list on staging.

---

## 10. E-Learning (HOD / OBE chairperson view)

**What it is:** open **E-Learning** from the menu (or go to `/elearning`). Because this
account has both the HOD and lecturer e-learning roles, you land on the **Chairperson**
workspace by default, and you can also reach the lecturer workspace.
**The Chairperson tabs (your OBE chairperson tools):** PLO Builder (programme learning
outcomes), Portfolio Review (approve/reject lecturers' course portfolios), Department
Analytics, Course Analytics, Report Center.
**Also reachable:** the **Lecturer** workspace at `/elearning/lecturer/*` (Course Portfolio,
Teaching Workspace, Content Bank, Assessments, Attendance, Gradebook, Course Analytics,
Virtual Classes), because you hold the lecturer role too.
**How to test:** open each tab and confirm it loads; on Portfolio Review, try starting a
review and approving/rejecting a portfolio.
**Good news:** these are **real, working pages**, not placeholders. Every tab talks to a
live e-learning back-end and its buttons actually persist. There are no fake-data screens.
**But: they need the back-end running.** Unlike the admin/HR pages (which use in-browser
test mocks), the e-learning pages have **no mocks**. If the e-learning back-end is down,
these pages show **empty or error states**, never fake data. An empty tab may mean the
service is down, not a broken feature; check the Network tab.
**Rough edges to expect (not bugs, just unpolished):**
- **Department Analytics** asks you to type a **numeric department ID** by hand (no
  dropdown).
- **Course Analytics** (opened on its own) asks for a course ID by hand.
- **Report Center** filters are raw numeric-ID inputs; you need to know the real IDs.
- The **lecturer** Course Portfolio has a development override (editable in any status) : 
  see the lecturer notes; harmless for HOD testing.
**Note on the role slug:** the HOD slug maps cleanly to the chairperson view, so you are
routed correctly. (The known slug mismatch in the shell only affects the admin/superadmin
and VC views.)
**Immersive learn player:** you can also reach `/elearning/learn` directly by URL; confirm
it loads.

---

## 11. Things that must be blocked (negative tests)

The front-end blocks whole portals by role, so:

- [ ] Type `/admin` (and sub-pages) into the URL → redirected to `/dashboard`.
- [ ] Type `/hr` → redirected to `/dashboard`.
- [ ] Type `/student` → redirected to `/dashboard`.
- [ ] Type `/academic/dean` → redirected to `/dashboard` (that sub-dashboard requires the
      dean role, which you do not have).
- [ ] Confirm no Admin/HR/Student menu items appear anywhere.

**Important nuance: reachable but powerless.** Inside the academic portal, only the HOD and
dean *sub-dashboards* are role-gated on the front-end. Other academic pages
(`/academic/exam-marks-approval`, `/academic/board`, `/academic/vc`) have **no per-page
front-end gate**, so typing their URLs will **render the page**, but you have **no menu
links** to them. If you open one:

- [ ] The lists come back **empty** (scoped to a role/faculty you do not hold, or need data
      that does not exist).
- [ ] Any action you trigger (approve exam marks, board approve, publish) is refused by the
      server with **403**, because you lack the permission. Confirm the 403 in the Network
      tab.
- [ ] **Sidebar quirk to note:** the "Marks Approval" nav item and "Applicant Selection"
      item are shared with the dean, but for exam-mark *approval* the dean-only page is
      "Exam Approval", which you do not see. Your "Marks Approval" is coursework only.

**Extra dead-page note:** the sidebar's **Timetable** and **Settings** links open
"Coming Soon" placeholders (§13), not real pages.

---

## 12. The permission-timing trap (subtle but important)

Your roles and permissions are **stamped into your login token when you log in.** Services
trust that token and do not re-check on every request. So:

- [ ] If an admin grants or removes a role, you will still have the **old** access until your
      token is re-issued. This is correct behaviour, not a bug.
- [ ] Log out and back in (or wait past the 15-minute token life) for the change to take
      effect. **Always re-issue the token before checking a permission change**: testing
      too quickly shows stale access and looks like a bug.
- [ ] There is **no instant force-revoke** when a role changes. A still-valid token keeps
      working until it expires.
- [ ] Note for security review: revocation is **fail-open**: if the cache (Redis) is down,
      revoked tokens are still accepted.

---

## 13. Known issues at a glance (do NOT report these as new bugs)

If you hit exactly one of these, it is expected. A *different* failure is a new bug.

1. **Academic Dashboard (`/academic`) is fake.** The sidebar "Dashboard" link opens a page
   of hardcoded numbers (156/1,247/23/87.5%) and a fake activity feed, with no real
   requests; two of its three quick-action buttons are dead. (`AcademicDashboard.tsx`)
2. **Sidebar "Dashboard" drift.** You land on `/academic/hod` (real) but the nav "Dashboard"
   link goes to `/academic` (the fake page). (`AcademicLayout.tsx:8`)
3. **Timetable and Settings are "Coming Soon" stubs.** (`App.tsx:286-287`)
4. **Modules page "View Details" is a dead button**, and it is view-only despite "manage"
   wording. (`ModulesManagement.tsx:167`)
5. **Student Records "Export" and per-row "View Details" are dead buttons.**
   (`StudentRecordsPage.tsx:52-58, 155`)
6. **HOD powers are silently department-scoped.** If you head no department, Marks Approval
   and Student Performance are empty and approvals are refused, with no on-screen hint that
   the cause is scope rather than "no data." (`ChairpersonController.php:267-305`)
7. **Student Performance swallows a failed fetch** and shows an empty table rather than an
   error. (`StudentPerformance.tsx:63-70`)
8. **Exam-mark/board/VC pages are reachable by URL** but you have no menu link and no
   permission; they render empty and any action returns 403.
   (`AppServiceProvider.php:30-47`)
9. **E-Learning has no test mocks:** its pages need the live back-end; an empty tab may mean
   the service is down, not a bug. (no `/elearning/*` entries in `mocks/handlers.ts`)
10. **E-Learning rough UX:** Department Analytics, Course Analytics, and Report Center
    require typing raw numeric IDs (no dropdowns).
11. **Staging has no payment rail**, so marks, students, selection, and exemption data are
    empty by data state, not by bug.

---

## 14. Sign-off

- [ ] All the normal (happy-path) checks in §3-§10 pass, ignoring the known issues in §13.
- [ ] All the "must be blocked" checks in §11 are confirmed blocked.
- [ ] You understand and have verified the permission-timing behaviour in §12.
- [ ] With seeded data in a department you head, Marks Approval (§5) and Exemption Review
      (§7) work end to end (the steps this account truly owns).
- [ ] No *new* (undescribed) failures found: or each new one logged separately.

Tester: __________   Date: __________   Build/commit: __________
