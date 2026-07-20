# Student Portal Test Guide: Plain Language

This is a hand-testing plan for the **student** account, written so anyone can follow it
without knowing the code. It matches the style of `ADMIN_WALKTHROUGH_PLAIN.md`.

**Who you test as:** the account `student@hit.ac.zw`, password `password`. The seed names
this person "Tendai Moyo". It holds one role: **student**. That role is read-only
everywhere: a student can look at their records but cannot change registry data.

**Where you test:** the live **staging** site (throwaway data). Never production.

**How to read each item:**
- **What it is**: plain description of the feature.
- **How to test**: numbered steps to do by hand.
- **Pass looks like**: what you should see if it works.
- **Known issue**: a bug we already know about. If you hit exactly this, it is *not* a
  new bug. Anything different *is* a new bug worth reporting.

**One thing to keep open the whole time:** your browser's developer tools, on the
**Network** and **Console** tabs. Several student pages fail silently: the request errors
(a red 4xx/5xx row in Network) but the page just shows a generic "Failed to load" or an
empty state. The real reason only shows in Network or Console.

---

## The big caveat before you start (read this)

Two separate things make most of the student portal look empty. Both are data-state facts,
not (by themselves) bugs. But one of them hides a real bug, described below.

**1. This student is not actually enrolled.** The account `student@hit.ac.zw` is created
only in the login (auth) service (`services/auth/database/seeders/UserSeeder.php:52`). The
student service has **no seeder at all** for student records
(`services/student/database/seeders/DatabaseSeeder.php` does nothing). So on a fresh
staging seed there is **no Student record** whose email is `student@hit.ac.zw`. The only
way one appears is if someone runs the admissions-to-enrolment flow (admin side) and
enrols an applicant who happens to share that email.

Because the student portal resolves "me" by matching your login email against a Student
record, with no such record you will see:
- Dashboard: "Failed to load student profile."
- Fees: "Failed to load fees."
- Registration: "Registration is not currently available." (or similar).
- Graduation: "You are not yet a graduation candidate," no ceremony.

**Empty or "Failed to load" here means "this account has no student record yet", not
"the button is broken".** To test the portal with real data, ask a developer to create a
Student row with `email = student@hit.ac.zw` (and, for marks/fees, the downstream data).

**2. Staging has no payment rail connected.** Almost the whole student lifecycle is gated
on payment. With no payments:
- No fees are posted, no invoices, no cleared balance.
- Results are withheld from students until fees are cleared, so **My Marks, Transcript,
  and GPA stay locked or empty** even if a student record exists.
- No graduation fee can be paid, so the graduation RSVP stays locked.

So for most pages, only test the *mechanics*: does the page load, does the empty state or
lock message show, does a filter work. Do not expect a full modules-to-graduation flow
unless a developer seeds the data by hand.

> **The bug hiding under the emptiness (see §13 issue 1):** even after a student record
> exists, several pages ask the server for the **wrong person**. They send your *login*
> id where the server expects your *student-record* id. Those two numbers come from
> different services and rarely match, so those pages will show "Failed to load" or, worse,
> another student's data. This is a real defect, not the empty-data state. Watch for it.

---

## 1. Before you begin (environment check)

- [ ] The website loads.
- [ ] Log in works (you reach a page, not an error).
- [ ] You know how to reset the data if it gets messy: re-run the database seeders. Note
      that re-seeding will **not** give this student any records (see the caveat above);
      ask a developer to seed an enrolled student if you need data.
- [ ] Dev tools open on Network + Console (see the intro).

---

## 2. What this account can and cannot reach (the key idea)

There are **two separate locks** in the system, and they can disagree. Spotting where they
disagree is the most valuable thing this test finds.

- **The front-end lock is by role.** It decides which sections of the site you can open.
  This account holds only the `student` role, so it can open the **Student** portal and the
  **E-Learning** area (student view). It **cannot** open Admin, Academic, or HR. Trying to
  reach those by URL bounces you to the dashboard.
- **The back-end lock is by permission.** It decides what the server will actually do once
  a request arrives. This account's permissions are read-only: `students.read`,
  `academics.read`, and `elearning.view.student`. It cannot write registry data anywhere.

**Why this matters:** the student portal is designed as a viewer. There is no screen here
that changes another person's record. The few actions a student *can* take (register for
modules, pay a fee, RSVP to a ceremony, apply for an exemption) act only on their own
record and are gated server-side.

**Landing after login:** you should arrive at `/student`.

---

## 3. Login and session

- [ ] **Log in** as `student@hit.ac.zw` (password `password`). You should land on the
      Student dashboard at `/student`.
- [ ] The menu shows **Student** navigation and an **E-Learning** link only. No Admin,
      Academic, or HR anywhere.
- [ ] **Refresh the page** mid-session. You stay logged in and stay in the Student portal
      (the app re-checks your roles with the server on load).
- [ ] **Idle test:** the login token lasts 15 minutes. Leave a tab untouched for over 15
      minutes, then click something. It should refresh quietly and keep working (see §12).
- [ ] **Log out**, then try to open `/student` directly by URL. You should be bounced to
      the login page.

---

## 4. Dashboard

**What it is:** a welcome banner (name, registration number, programme, level), two summary
cards (Current GPA and Clearance Status), an optional Graduation card, and three shortcut
tiles (My Modules, My Marks, My Registration).
**How to test:** open `/student`.
**Pass looks like (with data):** your name and reg number show; GPA and clearance render;
the three tiles link onward.
**Pass looks like (no data, the staging default):** the banner shows your login name but
reg/programme/level all show "—", and a red box says **"Failed to load student profile."**
That is the no-student-record state from the big caveat, not a broken page.
**Known issue:** the dashboard reads the profile from `/students/me` (matched by email), so
it fails cleanly when no student record exists. This is the honest failure; contrast it
with the pages in §5 that fail for the *wrong reason* (see §13 issue 1).

---

## 5. My academic records (the read-only pages)

These pages all show your own records. **Important:** most of them are affected by the same
underlying bug (§13 issue 1): they send the server your **login id** instead of your
**student-record id**. On staging the numbers differ, so expect "Failed to load" or an
empty table even when a matching student record exists. The pages that resolve you by
*email* instead (Fees, Registration, Graduation) do not have this bug; they only fail
because there is no student record yet.

### 5.1 My Modules
**What it is:** a table of your registered modules (code, name, credits, semester, session)
with a session filter.
**How to test:** open **My Modules**. Try the "Filter by session" dropdown.
**Pass looks like:** modules list; the filter narrows them; empty shows "No modules found."
**Known issue:** the page requests `/students/{your-login-id}/modules`. The server looks up
a student by that id and returns 404 when none matches, so you see "Failed to load
modules." even though the mechanism, not your action, is at fault (§13 issue 1).

### 5.2 My Marks
**What it is:** your marks per module (coursework, exam, final, grade, decision), an
academic-standing badge, and a carry-forward panel.
**How to test:** open **My Marks**.
**Pass looks like (gated, the normal case):** if results are published but fees are not
cleared, the whole page is replaced by an amber **"Results locked"** card with a link to
Fees. If results simply are not published yet, you see a clock icon and "Your results have
not been published yet." Both are correct behaviour, not bugs.
**Pass looks like (empty):** "No marks found."
**Known issue:** same wrong-id problem as My Modules (§13 issue 1). The fees/publish gate
only works correctly when the server can find *you*; with the id mismatch it may not.

### 5.3 Attendance
**What it is:** attendance percentage per module and whether it clears the exam-eligibility
bar (HIT §3.6.11). A banner states the threshold from the active regulation.
**How to test:** open **Attendance**.
**Pass looks like:** the threshold banner shows a percentage (or says it could not resolve
one from a regulation). Each module row shows a percentage and an eligibility badge, or "—"
when there is no attendance record.
**Known issue:** it reuses the same modules call with your login id (§13 issue 1), so the
whole table is empty ("You have no registered modules") when the id does not match.

### 5.4 My Registration
**What it is:** a 3-step self-service module registration (confirm details, select modules,
review and submit), fee-gated. Also shows your existing registration if you already have
one.
**How to test:** open **Registration**. If a session is open and you have a student record,
walk the steps. Try selecting a credit load below the minimum or above the maximum.
**Pass looks like:** step 2 blocks you with "Credit load must be between {min} and {max}"
when out of band, and the Review button is disabled until you pick at least one valid
module. If the registration fee is unpaid, step 2 is replaced by a **"Registration fee
required"** block with a link to Fees.
**Pass looks like (no data, staging default):** the page shows a single friendly line like
"Registration is not currently available." This covers both no-open-session (409) and
no-student-record (404).
**Note:** this page resolves you by email (`/students/me/registration/...`), so it does
**not** have the wrong-id bug; it is only empty because of the missing record or closed
session.

### 5.5 My GPA
**What it is:** cumulative GPA, classification, credits passed, an SGPA trend chart, a
per-semester breakdown, a progression outcome, and a HIT grade-scale reference.
**How to test:** open **My GPA**.
**Pass looks like:** the cards and chart render from real GPA data; a "Governed by
{regulation}" badge shows when a progression result is available.
**Known issue:** it fetches GPA with your login id (`/gpa/student/{login-id}/cumulative`,
§13 issue 1), so on staging it shows "Failed to load GPA data."

### 5.6 Transcript
**What it is:** an official-looking transcript (identity block, marks grouped by session,
progression decisions, award summary) with Print and Download PDF buttons.
**How to test:** open **Transcript**. Click Print, then Download PDF.
**Pass looks like:** the transcript renders (or shows the amber "Transcript locked" card if
fees are not cleared, which is correct). Print opens the browser print dialog.
**Known issue:** **"Download PDF" is not a real PDF.** It calls the same browser print
dialog as the Print button (`TranscriptView.tsx:55` and `:105`). There is no
server-generated document. This mirrors the admin transcript.
**Note:** the identity block and GPA come from `/students/me` (by email), but the marks
come from the login-id marks call, so the two halves can disagree under the wrong-id bug.

### 5.7 Clearance
**What it is:** your clearance status overall and per department (finance, library, etc.).
**How to test:** open **Clearance**.
**Pass looks like:** an overall badge plus one row per department with a status.
**Pass looks like (no record):** "No clearance record found."
**Known issue:** it requests `/students/{login-id}/clearance` (§13 issue 1), so on staging
it shows "Failed to load clearance status." rather than real data.

### 5.8 Course Exemptions
**What it is:** a list of your named-course exemption applications with an "Apply for
Exemption" dialog.
**How to test:** open **Exemptions**. Open the Apply dialog.
**Pass looks like:** a table of your past applications (empty state: "You have not applied
for any course exemptions yet."). The Apply button is disabled until your account id is
known.
**Known issue:** the list is filtered by `student_id = your login id` (§13 issue 1), so it
lists the wrong person's exemptions or none. Applying would also attach to the login id,
not your student record.

---

## 6. Fees

**What it is:** your account balance (from the accounting ledger, Ndarama), a list of
invoices with a "Pay" action (EcoCash or Visa via Paynow), and a list of posted bank
payments.
**How to test:** open **Fees**.
**Pass looks like (no record, staging default):** "Failed to load fees." because there is
no student record for this email.
**Pass looks like (record but no payments):** the balance card renders; Invoices shows "No
invoices yet." and Posted Bank Payments shows "No bank payments posted yet."
**Known issue: payment cannot complete on staging:** the Pay panel starts a real Paynow
transaction. With **no payment rail wired on staging**, "Start payment" will error ("Could
not start payment") or never confirm. That is the missing rail, not a page bug. Do not
expect to actually settle a balance here.
**Note:** Fees resolves you by email (`/students/me/fees`), so it does **not** have the
wrong-id bug. The balance shown is the authoritative ledger balance, not local invoice math.

---

## 7. Documents

**What it is:** a document library with upload, search, category and status filters, tabs
(All / Pending / Approved), and per-document View / Download / Delete.
**How to test:** open **Documents**. Try the search box, the filters, and the buttons.
**Known issue: this whole page is a mock:** the documents are **hard-coded in the page**
(`MyDocuments.tsx:28`), not loaded from any server. The three sample files are even labelled
"Tendai Moyo". Specifically:
- **Upload** does nothing real: it logs to the console and pops an alert "N file(s)
  uploaded successfully!" (`MyDocuments.tsx:94`). No file is sent anywhere.
- **Download** just opens a fake local path in a new tab (`MyDocuments.tsx:105`); there is
  no real file behind it.
- **Delete** only removes the row from the on-screen list; refresh and it returns.
- Search and the filters *do* work, but only over the three fake rows.

Treat this page as a non-functional placeholder. Everything on it is cosmetic.

---

## 8. Graduation

**What it is:** your graduation award status, the graduation fee, and the ceremony with an
RSVP.
**How to test:** open **Graduation**.
**Pass looks like (no record / not a candidate, staging default):** "You are not yet a
graduation candidate." and "No graduation ceremony is currently scheduled."
**Pass looks like (candidate):** an award card, a graduation-fee card, and a ceremony card.
The RSVP buttons are **locked until the graduation fee is paid** ("Pay the graduation fee to
RSVP"), which on staging never happens because there is no payment rail. That lock is
correct behaviour.
**Note:** Graduation resolves you by email (`/students/me/graduation` and
`/me/graduation/ceremony`), so no wrong-id bug; it is empty because there is no record and
no payment.

---

## 9. Notifications

**What it is:** a notification bell in the top bar and a notifications centre (plus a
settings page) shared across all portals.
**How to test:** click the bell; open Notifications; open notification settings.
**Pass looks like:** the pages load. With no events generated for this account, expect the
list to be empty. (These are shared pages, reachable by any logged-in user.)

---

## 10. E-Learning (student view)

**What it is:** the student side of the e-learning module. Two entry points:
- **My Learning** (`/elearning/learn`): a grid of courses you can open in an immersive
  player.
- The e-learning student dashboard (`/elearning/student`): tabs for My Courses, My Grades,
  My Attendance, and Progress, driven by your e-learning enrolments.
**How to test:** click **E-Learning** in the student menu.
**Pass looks like (no data, staging default):** "No courses to learn yet" on My Learning,
and "No enrolments found." on the dashboard tabs. E-learning enrolments are synced from the
ERP; with no enrolled/synced student, there is nothing to show.
**Access note (good news):** unlike the admin side, the student role maps cleanly. The
shell routes the `student` role straight to the student view
(`ElearningShell.tsx:29,57`), so there is **no slug-mismatch bug** for students (the admin
`superadmin` mismatch documented in the admin guide does not affect you).
**How to probe with data:** if a developer syncs an e-learning enrolment for this student,
confirm My Courses lists it, the progress bars fill, and the immersive player opens from a
course card.

---

## 11. Things that must be blocked (negative tests)

The front-end blocks by role, and the student role reaches only Student and E-Learning:

- [ ] Type `/admin` (and sub-pages like `/admin/students`) into the URL → you should be
      redirected to `/dashboard`.
- [ ] Type `/academic` (and sub-pages) → redirected to `/dashboard`.
- [ ] Type `/hr` → redirected to `/dashboard`.
- [ ] Confirm **no Admin, Academic, or HR links appear** anywhere in the student menu.
- [ ] **Back-end boundary (optional, design note):** even if a student somehow reached an
      admin page, the server would refuse writes because the account has read-only
      permissions only. The account can *read* students/academics on the back-end (it holds
      `students.read`, `academics.read`), but the front-end never gives it a screen to do so.

---

## 12. The permission-timing trap (subtle but important)

Your roles and permissions are **stamped into your login token when you log in.** Services
trust that token and do not re-check on every request. So:

- [ ] If an admin grants this account a new role, logging in **immediately** still shows the
      **old** access. This is correct behaviour, not a bug.
- [ ] Log out and back in (or wait past the 15-minute token life) for the new access to take
      effect. **Always re-issue the token before checking a permission change**: testing
      too quickly shows stale access and looks like a bug.
- [ ] There is **no instant force-revoke** when a role changes. A still-valid token keeps
      working until it expires.
- [ ] Note for security review: revocation is **fail-open**: if the cache (Redis) is down,
      revoked tokens are still accepted.

---

## 13. Known issues at a glance (do NOT report these as new bugs)

If you hit exactly one of these, it is expected. A *different* failure is a new bug.

**Real defects:**
1. **Wrong-id data reads.** My Modules, My Marks, Attendance, My GPA, Clearance, and Course
   Exemptions send your **login (auth) id** where the server expects your **student-record
   id**. These come from different services and rarely match, so these pages show "Failed to
   load" or empty, or (if an id collides) another student's data. Front-end:
   `MyModules.tsx:22`, `MyMarks.tsx:66`, `AttendanceStatus.tsx:66`, `GpaDashboard.tsx:59`,
   `ClearanceStatus.tsx:29`, `CourseExemptions.tsx:19`. Back-end resolves the id with
   `findOrFail` (`services/student/app/Repositories/StudentRepository.php:30`), giving a 404
   on a miss. Pages that resolve by *email* instead (Dashboard, Fees, Registration,
   Graduation, and the profile half of Transcript, via `StudentController::me()` at
   `StudentController.php:122`) do not have this bug.
2. **Documents page is entirely fake.** Hard-coded sample files; upload logs + alerts and
   sends nothing; download opens a fake path; delete is local-only. `MyDocuments.tsx:28`,
   `:94`, `:105`.
3. **Transcript "Download PDF" is just the browser print dialog**, not a server PDF.
   `TranscriptView.tsx:55`, `:105`. (Same as the admin transcript.)

**Empty by data state (not bugs on their own):**
4. **This account has no seeded student record.** Auth creates the login only
   (`UserSeeder.php:52`); the student service seeds nothing
   (`student/database/seeders/DatabaseSeeder.php`). So `/students/me`-style pages return 404
   and read as "Failed to load" until a developer creates a Student row for
   `student@hit.ac.zw`.
5. **No payment rail on staging.** Fees cannot be paid, so results/transcript/GPA stay
   locked or empty and the graduation RSVP stays locked. The lock messages are correct
   behaviour.

**Dev-only note (does not affect staging):**
6. In local dev, the fake API layer (MSW) only mocks some student endpoints (`/students/me`,
   `/students/:id/modules|marks|clearance|documents`, and cumulative GPA). It does **not**
   mock Fees, the new self-service Registration endpoints, Graduation, Attendance,
   Exemptions, or E-Learning (`frontend/src/mocks/handlers.ts`). Those requests fall through
   to the real network in dev. On staging everything is the real back-end, so this only
   matters if you test locally.

---

## 14. Sign-off

- [ ] All the happy-path checks in §3-§10 either pass or fail only for a reason listed in
      §13 (no student record / no payment rail / the wrong-id defect).
- [ ] All the "must be blocked" checks in §11 are confirmed blocked.
- [ ] You understand and have verified the permission-timing behaviour in §12.
- [ ] No *new* (undescribed) failures found: or each new one logged separately.
- [ ] The wrong-id defect (§13 issue 1) has been raised for a fix, since it breaks most of
      the read-only pages even after a student is enrolled.

Tester: __________   Date: __________   Build/commit: __________
