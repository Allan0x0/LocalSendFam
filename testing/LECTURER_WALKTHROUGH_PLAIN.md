# Lecturer Portal Test Guide: Plain Language

This is a manual test plan anyone can follow without knowing the codebase. It covers the
lecturer account: what it can reach, what works, and what is a known stub.

**Who you test as:** the account `lecturer@hit.ac.zw` (seeded as "Dr. S. Moyo"). It holds
one role: **lecturer**. Password: `password`.

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

- No exam results, no module marks, no graduates, and no paid applicants to select.
- So these pages **will look empty**: your Lecturer Dashboard tiles (if no modules are
  assigned to you), the mark tables inside Marks Entry, Class Attendance, Student Records,
  and anything built from marks.

**Empty here means "no data", not "broken".** For those pages, test only the *mechanics*:
do filters work, does validation fire, does the empty-state message show, are you blocked
where you should be. Do not expect a full mark-to-graduation flow to work unless a
developer first seeds module assignments and marks for you.

---

## 1. Before you begin (environment check)

- [ ] The website loads.
- [ ] Log in works (you reach a page, not an error).
- [ ] You know how to reset the data if it gets messy: re-run the database seeders to
      return to a clean starting point. Ask a developer if unsure.
- [ ] Dev tools open on Network + Console (see above).

---

## 2. What this account can and cannot reach (the key idea)

There are **two separate locks** in the system, and they do not always agree. Spotting
where they disagree is the single most valuable thing this test finds.

- **The front-end lock is by role.** It decides which sections of the site you can open.
  This account can open the **Academic** portal and **E-Learning** only. It **cannot**
  open the Admin, HR, or Student portals.
- **The back-end lock is by permission.** It decides what the server will actually let you
  do once a request reaches it. This lecturer account is deliberately **read-only** on
  academics: it holds `academics.read`, `students.read`, and `elearning.view.lecturer`.
  It has **no** marks-approval permission and **no** academic-write permission.

**What this means in practice:** the lecturer's real power is **entering marks** on modules
assigned to them. Everything else on the academic side is view-only. The lecturer **owns
one step** of the marks governance chain and no more.

**The marks governance chain (for context).** A mark moves like this:
lecturer enters marks → chairperson/HOD approves coursework (and forwards exam marks) →
dean approves exam marks → exams-office verifies → academic board (VC) approves → registry
publishes → student sees it. **This account owns only the first step: entering marks.** It
cannot approve, verify, publish, or reverse anything after submission.

---

## 3. Login and session

- [ ] **Log in** as `lecturer@hit.ac.zw`. You should land on the **Lecturer Dashboard**
      (`/academic/lecturer`).
- [ ] The left menu shows only academic items plus **E-Learning** and **My Portal**. There
      is **no** Admin, HR, or Student menu.
- [ ] **Refresh the page** mid-session. You stay logged in and stay in the academic portal
      (the app re-checks your roles with the server on load).
- [ ] **Idle test:** the login token lasts 15 minutes. Leave a tab untouched for over 15
      minutes, then click something. It should refresh quietly and keep working (revisit
      this in §11).
- [ ] **Log out**, then try to open an academic page directly by URL. You should be bounced
      to the login page.

**Menu-vs-landing quirk to note:** you land on `/academic/lecturer` (the real dashboard
with your modules), but the sidebar **"Dashboard"** link points to `/academic`, which is a
**different, hardcoded page** (see §4.6). So clicking "Dashboard" does not return you to the
dashboard you started on. This is a known drift.

---

## 4. The pages you can reach

### 4.1 Lecturer Dashboard (`/academic/lecturer`): your home page
**What it is:** summary tiles (My Modules, Total Students, Pending Marks, Submitted Marks)
and a card per module you teach, each with an **Enter Marks** button.
**How to test:**
1. Log in; you land here.
2. Confirm the tiles and module cards render.
3. Click **Enter Marks** on a module → you go to the Marks Entry page (§4.2).
**Pass looks like:** tiles show real counts; each assigned module appears as a card.
**Empty state:** if no modules are assigned to your account, you see **"No modules assigned
yet."** On staging this is likely until a developer seeds module assignments for you. That
is a data state, not a bug. The list is scoped to modules where you are the assigned
lecturer, so you only ever see your own.

### 4.2 Marks Entry (`/academic/marks-entry/{moduleId}`): the one thing you own
**What it is:** the real, working mark-capture screen. This is the start of the whole marks
workflow: saving here creates **pending** approval rows for the chairperson/HOD.
**How to test:**
1. From the dashboard or Modules page, click **Enter Marks** on a module.
2. Pick an assessment tab (Assignment, Test, Practical, Exam, or the programme's configured
   types). Each tab shows its weight, e.g. "(30%)".
3. Type a mark for a student. Watch the live grade letter and Pass/Fail badge update, and
   the progress bar fill.
4. **Auto-save:** clicking out of a mark field (blur) saves that one student immediately.
5. Or fill several and click **Submit for Approval** to save the whole tab at once.
6. Try **Manage Class** (add/remove students) and **Bulk Upload** (CSV).
**Validation to probe:**
- A mark above the max turns the field red with "Exceeds max"; the value is also clamped to
  the max as you type.
- Submitting an empty tab shows "No marks entered".
**Pass looks like:** a green "Marks saved successfully" toast; the tab gets a green check.
Failure shows "Failed to save marks" (a red toast).
**Empty state:** "No students enrolled in this module." on staging (no registrations).
**Note on assessment types:** if the programme has no configured assessment types, the page
falls back to a generic set (Assignment/Test/Practical/Exam) and submits marks by name
rather than by id. Both paths should save; watch the Network tab to confirm which was used.

### 4.3 Modules (`/academic/modules`)
**What it is:** a searchable, filterable **read-only** list of modules (search by code or
name; filter Semester 1 / Semester 2).
**How to test:** search and toggle the semester filters.
**Pass looks like:** cards filter correctly; empty search shows "No modules found."
**Known issues:** the **"View Details" button does nothing** (no handler). The page header
says "View and manage academic modules", but there is **no create/edit/delete here** for
you: only lecturers get an **Enter Marks** shortcut on each card. Treat this as a viewer,
not a manager.

### 4.4 Student Records (`/academic/students`)
**What it is:** a read-only, searchable table of enrolled students (search by number or
name; filter by level). It reads the academic service, the authoritative enrolled store.
**How to test:** search and change the level filter.
**Pass looks like:** rows render; no match shows "No students found."
**Known issues:** the **"Export" button does nothing** (no handler), and the per-row
**"View Details" button does nothing** (no handler). Expect **empty on staging** if no
students are enrolled.

### 4.5 Class Attendance & Eligibility (`/academic/attendance`)
**What it is:** a read-only view of each student's attendance against the exam-eligibility
bar (HIT §3.6.11). Below the bar means exam-barred (graded Incomplete).
**How to test:** pick one of your modules, then set semester and academic year.
**Pass looks like:** the bar percentage shows (read from the governing regulation), and each
student gets an eligible/barred/no-record badge.
**Watch for:** if the regulation threshold has not loaded you see "Threshold unresolved : 
eligibility cannot be computed." With no attendance records (staging), students show "—"
and "no record." This is a data state, not a bug. There is no way to *record* attendance
from this screen; it is view-only.

### 4.6 Academic Dashboard (`/academic`): the sidebar "Dashboard" link
**What it is:** a generic overview page reached by the sidebar "Dashboard" link.
**Known issue: do not trust the numbers:** this page shows **hardcoded fake figures** (156
modules, 1,247 students, 23 pending, 87.5% pass rate) and a **fake "Recent Activity" feed**
(CSC301, CSC405, timetable). It makes **no real requests**. Of its three "Quick Actions",
only **Enter Marks** works (it opens the Modules page); **Manage Modules** and **Student
Records** are **dead buttons**. Treat this whole page as a placeholder.

### 4.7 Timetable and Settings (sidebar links)
**Known issue:** both `/academic/timetable` and `/academic/settings` are **"Coming Soon"
placeholders**: they render a single line of text and nothing else.

---

## 5. E-Learning (lecturer view)

**What it is:** open **E-Learning** from the menu (or go to `/elearning`). Because this
account has the lecturer e-learning role, you land on the **Lecturer** workspace.
**The tabs you get:** Course Portfolio, Teaching Workspace, Content Bank, Assessments,
Attendance, Gradebook, Course Analytics, Virtual Classes.
**How to test:** open each tab and confirm it loads without an error.
**Good news:** these are **real, working pages**, not placeholders. Every tab talks to a
live e-learning back-end and its buttons actually persist. There are no fake-data screens
here.
**But: they need the back-end running.** Unlike the admin/HR pages (which use in-browser
test mocks), the e-learning pages have **no mocks**. If the e-learning back-end is down,
these pages show **empty or error states**, never fake data. So an empty e-learning tab may
mean the service is down, not that the feature is broken; check the Network tab.
**Rough edges to expect (not bugs, just unpolished):**
- **Course Portfolio (`PortfolioBuilder`)** has a **development override**: it is editable
  in *any* status. Normally a submitted or published portfolio should lock, but right now
  you can still edit one. This is a deliberate temporary shortcut, marked in the code
  (`PortfolioBuilder.tsx:66`). Do not report it as a bug; do flag it if it survives to
  production.
- **Virtual Classes** asks you to type a **numeric course ID** by hand (no dropdown).
- **Course Analytics** (opened on its own) also asks for a course ID by hand.
- **Content Bank** "upload" only records a link or file path; there is no real file-picker
  widget.
- **Attendance** saves one record per student in sequence, so a large class saves slowly.
**Immersive learn player:** you can also reach `/elearning/learn` (a standalone course
player) directly by URL. Confirm it loads.
**Note on the role slug:** the e-learning shell maps roles by slug. The lecturer slug
matches cleanly, so you are routed to the lecturer view without trouble. (The known slug
mismatch in the shell only affects the admin/superadmin and VC views, not the lecturer.)

---

## 6. Things that must be blocked (negative tests)

The front-end blocks whole portals by role, so:

- [ ] Type `/admin` (and sub-pages) into the URL → you should be redirected to
      `/dashboard`.
- [ ] Type `/hr` → redirected to `/dashboard`.
- [ ] Type `/student` → redirected to `/dashboard`.
- [ ] Type `/academic/hod` → redirected to `/dashboard` (that sub-dashboard requires the
      HOD role, which you do not have).
- [ ] Type `/academic/dean` → redirected to `/dashboard` (requires the dean role).
- [ ] Confirm no Admin/HR/Student menu items appear anywhere.

**Important nuance: reachable but powerless.** Inside the academic portal, only the HOD and
dean *sub-dashboards* are role-gated on the front-end. The other academic pages
(`/academic/marks-approval`, `/academic/exam-marks-approval`, `/academic/selection`,
`/academic/board`, `/academic/vc`, `/academic/exemptions`) have **no per-page front-end
gate**, so typing their URLs will **render the page**. You have **no menu links** to them,
which is correct. If you do open one:

- [ ] The lists come back **empty** (they are scoped to a department/faculty you do not
      head, or need marks that do not exist), so there is nothing to act on.
- [ ] If you somehow trigger an action (approve, reject, verify, publish), the **server
      refuses with 403** because you lack the permission. Confirm the 403 in the Network
      tab. This is the back-end lock doing its job.

---

## 7. The permission-timing trap (subtle but important)

Your roles and permissions are **stamped into your login token when you log in.** Services
trust that token and do not re-check on every request. So:

- [ ] If an admin grants you a new role, you will still have the **old** access until your
      token is re-issued. This is correct behaviour, not a bug.
- [ ] Log out and back in (or wait past the 15-minute token life) for the new access to take
      effect. **Always re-issue the token before checking a permission change**: testing
      too quickly shows stale access and looks like a bug.
- [ ] There is **no instant force-revoke** when a role changes. A still-valid token keeps
      working until it expires.
- [ ] Note for security review: revocation is **fail-open**: if the cache (Redis) is down,
      revoked tokens are still accepted.

---

## 8. Known issues at a glance (do NOT report these as new bugs)

If you hit exactly one of these, it is expected. A *different* failure is a new bug.

1. **Academic Dashboard (`/academic`) is fake.** Hardcoded numbers, fake activity feed, no
   real requests; two of its three quick-action buttons are dead. (`AcademicDashboard.tsx`)
2. **Sidebar "Dashboard" drift.** You land on `/academic/lecturer` (real) but the nav
   "Dashboard" link goes to `/academic` (the fake page above). (`AcademicLayout.tsx:8`)
3. **Timetable and Settings are "Coming Soon" stubs.** (`App.tsx:286-287`)
4. **Modules page "View Details" is a dead button**, and the page is view-only despite the
   "manage" wording. (`ModulesManagement.tsx:167`)
5. **Student Records "Export" and per-row "View Details" are dead buttons.**
   (`StudentRecordsPage.tsx:52-58, 155`)
6. **Approval/board/VC pages are reachable by URL but you have no menu link and no
   permission.** They render empty and any action returns 403. (`App.tsx:274-283`,
   front-end gate only covers hod/dean sub-dashboards; back-end gate in
   `AppServiceProvider.php:24-47`)
7. **Sidebar role label is cosmetic.** It shows your first role ("lecturer").
   (`AcademicLayout.tsx:37`)
8. **E-Learning Course Portfolio dev override:** editable in any status (submitted/published
   should lock, but do not yet). Temporary shortcut. (`PortfolioBuilder.tsx:66`)
9. **E-Learning has no test mocks:** its pages need the live back-end; an empty tab may mean
   the service is down, not a bug. (no `/elearning/*` entries in `mocks/handlers.ts`)
10. **Staging has no payment rail**, so marks, students, and attendance data are empty by
   data state, not by bug.

---

## 9. Sign-off

- [ ] All the normal (happy-path) checks in §3-§5 pass, ignoring the known issues in §8.
- [ ] All the "must be blocked" checks in §6 are confirmed blocked.
- [ ] You understand and have verified the permission-timing behaviour in §7.
- [ ] Marks Entry (§4.2) saves marks and shows the success toast (the one feature this
      account truly owns).
- [ ] No *new* (undescribed) failures found: or each new one logged separately.

Tester: __________   Date: __________   Build/commit: __________
