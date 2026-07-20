# Dean Portal Test Guide: Plain Language

This is a manual test plan anyone can follow without knowing the codebase. It covers the
Dean account: what it can reach, what works, and what is a known stub.

**Who you test as:** the account `dean@hit.ac.zw` (seeded as "Prof. K. Chigwedere"). It
holds two roles at once: **lecturer + dean**. So it can do everything a lecturer can, plus
the dean powers. Password: `password`.

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
- So these pages **will look empty**: the Exam Marks Approval queue, Applicant Selection,
  Exemptions, Class Attendance, Student Records, and anything built from marks.

**Empty here means "no data", not "broken".** For those pages, test only the *mechanics*:
do filters work, does validation fire, does the empty-state message show, are you blocked
where you should be. Do not expect a full mark-to-graduation flow to work unless a developer
first seeds marks and a faculty you actually head.

**One extra dependency for the dean:** most dean powers are **scoped to the faculty you
head** (on the back-end, "departments whose faculty's `dean_id` is you"). If the seeded dean
account is not set as the dean of any faculty, the Exam Marks Approval queue will be **empty
even if marks exist**, and any approval attempt would be refused as out-of-faculty. Ask a
developer to confirm you head a faculty before testing approvals.

---

## 1. Before you begin (environment check)

- [ ] The website loads.
- [ ] Log in works (you reach a page, not an error).
- [ ] You know how to reset the data if it gets messy: re-run the database seeders to
      return to a clean starting point. Ask a developer if unsure.
- [ ] Dev tools open on Network + Console (see above).
- [ ] (For approval tests) a developer has confirmed you are the dean of at least one
      faculty and there are exam marks pending your approval in it.

---

## 2. What this account can and cannot reach (the key idea)

There are **two separate locks** in the system, and they do not always agree. Spotting
where they disagree is the single most valuable thing this test finds.

- **The front-end lock is by role.** It decides which sections of the site you can open.
  This account can open the **Academic** portal and **E-Learning** only. It **cannot** open
  the Admin, HR, or Student portals.
- **The back-end lock is by permission.** It decides what the server actually lets you do.
  The dean holds: `academics.read` (note: **read only, not write**), `students.read`,
  `marks.approve.exam`, `programmes.approve`, `exemptions.approve.school`, plus the
  e-learning permissions (`elearning.view.dean`, `elearning.obe.dean`,
  `elearning.view.lecturer`).

**What the dean adds over a plain lecturer.** In one line each:
- **Exam-mark approval.** Approve or reject the exam marks that reach the dean stage, for
  your faculty. This is your main governance step.
- **School exemption approval.** Approve or reject course-exemption applications at the
  School stage.
- **Applicant selection.** Recommend accept/waitlist/reject on paid applicants for your
  faculty's programmes.
- **OBE dean tools** in e-learning (NQF levels, programme-type NQF mapping, faculty-wide
  portfolio oversight).

**The dean is READ-ONLY on academic structure.** Unlike the HOD, the dean does **not** hold
`academics.write` at all: only `academics.read`. So the dean can view schools, departments,
programmes, and modules but cannot create, edit, or delete any of them. Those management
screens live in the Admin portal anyway, which the dean cannot reach.

**A permission with no wired screen (verify).** The dean holds `programmes.approve`, but no
reachable dean screen currently performs a "programme approval" action: the Dean Dashboard's
"View Programmes" button is inert, and the e-learning dean Programmes tab is read-only. Treat
programme approval as a permission that exists but has no exercisable UI yet; verify with a
developer if you are asked to certify it.

**The marks governance chain (for context).** A mark moves like this:
lecturer enters marks → chairperson/HOD approves coursework (and forwards exam marks) →
**dean approves exam marks** → exams-office verifies → academic board (VC) approves →
registry publishes → student sees it. **This account owns the third step: approving exam
marks.** It cannot approve coursework (that is the HOD), verify, do board approval, or
publish.

---

## 3. Login and session

- [ ] **Log in** as `dean@hit.ac.zw`. You should land on the **Dean Dashboard**
      (`/academic/dean`).
- [ ] The left menu shows academic items for a dean (Dashboard, Applicant Selection, Marks
      Approval, Dean Dashboard, Exam Approval, Modules, Student Records, Exemptions,
      Attendance, Timetable, Settings) plus **E-Learning** and **My Portal**. There is
      **no** Admin, HR, or Student menu.
- [ ] **Refresh the page** mid-session. You stay logged in and stay in the academic portal
      (the app re-checks your roles with the server on load).
- [ ] **Idle test:** the login token lasts 15 minutes. Leave a tab untouched for over 15
      minutes, then click something. It should refresh quietly and keep working (revisit
      this in §12).
- [ ] **Log out**, then try to open an academic page directly by URL. You should be bounced
      to the login page.

**Menu-vs-landing quirk to note:** you land on `/academic/dean` (the real Dean dashboard),
but the sidebar **"Dashboard"** link points to `/academic`, a **different, hardcoded page**
(see §11). Clicking "Dashboard" does not return you to the Dean dashboard.

---

## 4. Dean Dashboard (`/academic/dean`)

**What it is:** your home page. Faculty stat cards (Departments, Programmes, Students,
Pending Approvals), a "This Month's Activity" summary, a Departments list, and Quick
Actions.
**How to test:**
1. Log in; you land here.
2. Click **Review Exam Marks** → goes to the Exam Marks Approval queue (§5).
**Known issues: do not trust most of this page:**
- The **faculty stat cards show hardcoded placeholder numbers** from the server
  (Engineering and Technology / FET / 5 departments / 1,250 students / 45 staff / 8
  programmes), not your real faculty. (`DeanController.php:29-45`)
- The **"Pending Approvals", "Total Exam Marks", "Approved/Rejected this month" tiles and
  the Departments list come out blank or zero** because the page reads field names the
  server does not send (the page expects `pending_exam_approvals`; the server returns
  `pending_approvals`, an empty `departments` list, and no monthly totals).
  (`DeanDashboard.tsx` vs `DeanController.php`)
- The **"Manage Departments" and "View Programmes" buttons are dead** (no handler). Only
  **Review Exam Marks** navigates.
Treat this dashboard as mostly cosmetic; the real work is on the pages below.

---

## 5. Exam Marks Approval (`/academic/exam-marks-approval`): the step you own

**What it is:** the queue of exam marks that have reached the **dean** stage (already passed
the chairperson), waiting for your approval. Approving forwards a mark to the Exams Office;
rejecting sends it back.
**How to test:**
1. Open **Exam Approval** from the menu or the Dean dashboard.
2. Filter by module, department, or programme (free-text).
3. Click **Review** on a row to open the dialog; approve (optional comment) or reject
   (reason required).
4. Or tick several rows and use the bulk **Approve (N)** / **Reject (N)** buttons.
**Pass looks like:** the mark leaves the pending queue and moves to the Exams Office stage.
**Known issue: the approval actions currently fail (important).** In the present code the
Approve, Reject, and bulk buttons POST to endpoints the academic service **does not
define**: the page calls `/academic/dean/exam-marks/{id}/approve`,
`/academic/dean/exam-marks/{id}/reject`, and `/academic/dean/exam-marks/bulk-action`, but
the service only defines `/dean/marks/{id}/approve` and `/dean/marks/{id}/reject` (and no
bulk action at all). Expect these to **fail with a 404**, shown on screen as a "Failed to
process exam mark" / "Failed to approve exam marks" toast. Confirm the 404 in the Network
tab. (`api/dean.ts:17-34` vs `services/academic/routes/api.php:74-77`) The **queue itself
loads** (that endpoint, `/dean/exam-marks/pending`, does exist): so you can test filters
and the empty state, just not a successful approval, until the endpoints are aligned.
**What the server would enforce (once the endpoints match):**
- You can only act on marks in **your own faculty**; anything else is refused with **403
  "You may only verify marks for departments in your own faculty."**
- Only marks at the **dean** stage can be approved (422 otherwise).
- Approving needs the exam-mark permission; a lecturer or HOD hitting the endpoint gets 403.
**Empty state:** **empty on staging** (no marks, or you head no faculty).

---

## 6. Applicant Selection (`/academic/selection`)

**What it is:** the admissions selection step. A list, grouped by programme, of **paid,
un-reviewed first-choice applicants** for your faculty's programmes. You recommend Select,
Waitlist, or Reject; admissions finalises afterwards.
**How to test:**
1. Open Applicant Selection.
2. Expand an applicant row to see details, qualifications, and documents.
3. Click **Select**, **Waitlist**, or **Reject**.
**Pass looks like:** a toast confirms the recommendation and the row updates.
**Empty state:** **empty on staging**: applicants only appear once they have **paid** and
selection is **open**. Expect "No applicants awaiting selection." An error banner ("You may
not have any programmes assigned, or selection is closed") means you head no programmes, or
selection is closed. This reads the student service; confirm that service is up if it errors.

---

## 7. Course Exemption Review (`/academic/exemptions`): School stage

**What it is:** exemption applications routed Department → School → Senate (HIT §10). As a
dean you act on the **School** stage.
**How to test:**
1. Open Exemptions; filter by status if you like.
2. Click a row to open the review dialog. It shows the source course, syllabus-match %, and
   regulation checks (thresholds read from the active regulation, not hardcoded).
3. If the application is at the **School** stage, you see Approve / Reject controls. Reject
   requires a reason.
**Pass looks like:** approving advances the application toward Senate (if required) or to
approved; rejecting closes it with your reason. The server also gates this: it only lets the
school-approval permission act on a school-stage application.
**What you cannot do:** act on an application still at the **Department** stage (that belongs
to the HOD) or at the **Senate** stage (the board). The dialog shows "Awaiting
Department/Senate review. You cannot act on this stage."
**Empty state:** **empty on staging** ("No exemption applications to review.").

---

## 8. Modules, Student Records, Attendance, Marks Entry (shared academic pages)

These behave the same as for any academic user; the dean gets no extra write power here
(the dean is read-only on academic structure).

### 8.1 Modules (`/academic/modules`)
Read-only, searchable list (search by code/name; filter by semester). **Known issue:** the
**"View Details" button does nothing**; there is no create/edit/delete despite the "manage"
wording. Because the dean also holds the lecturer role, module cards still show an **Enter
Marks** shortcut.

### 8.2 Student Records (`/academic/students`)
Read-only, searchable table of enrolled students. **Known issue:** the **"Export" and per-row
"View Details" buttons do nothing.** Empty on staging.

### 8.3 Class Attendance (`/academic/attendance`)
Read-only eligibility view: pick a module, set semester and year, see each student against
the exam-eligibility bar. No way to record attendance here. Empty on staging.

### 8.4 Marks Entry (`/academic/marks-entry/{moduleId}`)
Because the dean also holds the lecturer role, you can enter marks on modules assigned to you
(same working screen a lecturer uses: assessment tabs, auto-save on blur, submit for
approval, grade/pass badges). Empty student list on staging.

---

## 9. E-Learning (Dean / OBE dean view)

**What it is:** open **E-Learning** from the menu (or go to `/elearning`). Because this
account has both the dean and lecturer e-learning roles, you land on the **Dean** workspace
by default, and you can also reach the lecturer workspace.
**The Dean tabs (your OBE dean tools):** Dashboard (faculty analytics), NQF Levels (create
and order national-qualifications-framework levels and descriptors), Departments,
Programmes, Courses (course catalogue with portfolio review, PLO review, analytics, and
approve/reject/publish), Portfolio Status (faculty-wide portfolio readout), and a Report
Center (reachable from the Dashboard's Reports link).
**Also reachable:** the **Lecturer** workspace at `/elearning/lecturer/*`, because you hold
the lecturer role too.
**How to test:** open each tab and confirm it loads; on Courses, try a portfolio
approve/reject; on NQF Levels, try creating and reordering a level.
**Good news:** these are **real, working pages**, not placeholders. Every tab talks to a
live e-learning back-end and its buttons actually persist. There are no fake-data screens.
**But: they need the back-end running.** Unlike the admin/HR pages (which use in-browser
test mocks), the e-learning pages have **no mocks**. If the e-learning back-end is down,
these pages show **empty or error states**, never fake data. An empty tab may mean the
service is down, not a broken feature; check the Network tab.
**Rough edges to expect (not bugs, just unpolished):**
- **Course Analytics** (opened on its own) asks you to type a **numeric course ID** by hand.
- **Report Center** filters are raw numeric-ID inputs; you need to know the real IDs.
- The **lecturer** Course Portfolio has a development override (editable in any status) : 
  see the lecturer notes; harmless for dean testing.
**Note on the role slug:** the dean slug maps cleanly to the dean view, so you are routed
correctly. (The known slug mismatch in the shell only affects the admin/superadmin and VC
views.)
**Immersive learn player:** you can also reach `/elearning/learn` directly by URL; confirm
it loads.

---

## 10. A sidebar item that lies (worth checking)

The sidebar shows **"Marks Approval"** for the dean (it is shared with the HOD). But **marks
approval here means *coursework* approval, which the dean does NOT have permission for**
(that is the HOD's job). If you open `/academic/marks-approval`:

- [ ] The queue is scoped to a department you head as HOD: you head none: so it is
      **empty**.
- [ ] If you did try to approve a coursework mark, the server refuses with **403** ("You may
      only verify marks for your own department" / permission denied). Confirm the 403.

So the dean's real approval page is **Exam Approval** (§5), not **Marks Approval**. The
"Marks Approval" nav item appearing for the dean is misleading and worth flagging.

---

## 11. Things that must be blocked (negative tests)

The front-end blocks whole portals by role, so:

- [ ] Type `/admin` (and sub-pages) into the URL → redirected to `/dashboard`.
- [ ] Type `/hr` → redirected to `/dashboard`.
- [ ] Type `/student` → redirected to `/dashboard`.
- [ ] Type `/academic/hod` → redirected to `/dashboard` (that sub-dashboard requires the HOD
      role, which you do not have).
- [ ] Confirm no Admin/HR/Student menu items appear anywhere.

**Important nuance: reachable but powerless.** Inside the academic portal, only the HOD and
dean *sub-dashboards* are role-gated on the front-end. Other academic pages
(`/academic/marks-approval` (see §10), `/academic/board`, `/academic/vc`) have **no per-page
front-end gate**, so typing their URLs will **render the page**, but you have no menu links
to the board/VC pages. If you open one:

- [ ] The lists come back **empty** (scoped to a role/faculty you do not hold, or need data
      that does not exist).
- [ ] Any action you trigger (coursework approve, board approve, publish) is refused by the
      server with **403**, because you lack the permission. Confirm the 403 in the Network
      tab.

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

1. **Dean Dashboard exam-approval actions fail.** Approve/Reject/bulk on Exam Marks Approval
   POST to endpoints the academic service does not define (`/dean/exam-marks/{id}/approve`,
   `/reject`, `/bulk-action`); the service only has `/dean/marks/{id}/approve|reject`. Expect
   a 404 and a "Failed to process exam mark" toast. (`api/dean.ts:17-34` vs
   `services/academic/routes/api.php:74-77`)
2. **Dean Dashboard shows fake/blank data.** Faculty stat cards are hardcoded placeholders;
   the Pending Approvals / Total Exam Marks / monthly tiles and the Departments list come out
   blank or zero due to a field-name mismatch. (`DeanDashboard.tsx` vs `DeanController.php`)
3. **"Marks Approval" nav item is misleading for the dean**: it is coursework approval,
   which the dean cannot do; the queue is empty and any action 403s. Use "Exam Approval"
   instead. (`AcademicLayout.tsx:11`)
4. **`programmes.approve` has no exercisable screen.** The dean holds the permission, but no
   reachable dean action performs a programme approval; the dashboard "View Programmes"
   button is dead and the e-learning Programmes tab is read-only. (verify)
5. **Academic Dashboard (`/academic`) is fake.** The sidebar "Dashboard" link opens hardcoded
   numbers and a fake activity feed, with two dead quick-action buttons.
   (`AcademicDashboard.tsx`)
6. **Sidebar "Dashboard" drift.** You land on `/academic/dean` (real) but the nav "Dashboard"
   link goes to `/academic` (the fake page). (`AcademicLayout.tsx:8`)
7. **Timetable and Settings are "Coming Soon" stubs.** (`App.tsx:286-287`)
8. **Modules "View Details" and Student Records "Export"/"View Details" are dead buttons;**
   the dean is read-only on structure. (`ModulesManagement.tsx:167`,
   `StudentRecordsPage.tsx:52-58, 155`)
9. **Dean powers are silently faculty-scoped.** If you head no faculty, the exam queue is
   empty and approvals are refused, with no on-screen hint that scope, not "no data", is the
   cause. (`DeanController.php:160-172`)
10. **E-Learning has no test mocks:** its pages need the live back-end; an empty tab may mean
    the service is down, not a bug. (no `/elearning/*` entries in `mocks/handlers.ts`)
11. **E-Learning rough UX:** Course Analytics and Report Center require typing raw numeric
    IDs (no dropdowns).
12. **Staging has no payment rail**, so marks, selection, and exemption data are empty by
    data state, not by bug.

---

## 14. Sign-off

- [ ] All the normal (happy-path) checks in §3-§9 pass, ignoring the known issues in §13.
- [ ] All the "must be blocked" checks in §11 are confirmed blocked.
- [ ] You understand and have verified the permission-timing behaviour in §12.
- [ ] The Exam Marks Approval queue (§5) loads and filters, and you have confirmed the
      approval-action 404 (issue #1) rather than a new failure.
- [ ] With seeded data in a faculty you head, School exemption approval (§7) works end to
      end.
- [ ] No *new* (undescribed) failures found: or each new one logged separately.

Tester: __________   Date: __________   Build/commit: __________
