# Admin Portal Test Guide: Plain Language

This is the same test plan as `ADMIN_WALKTHROUGH.md`, rewritten so anyone can follow it
without knowing the codebase. Section numbers match the original, so you can jump between
the two.

**Who you test as:** the account `admin@hit.ac.zw`. It holds three roles at once:
super_admin, registry_admin, and admissions_officer. Together these give it very wide
access.

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

Staging has **no payment system connected**. Because almost the entire student lifecycle
is gated on payment, a lot of downstream data simply does not exist yet:

- No exam results, no marks, no graduates.
- So these pages **will look empty**: Results Publication, Results Decision Entry, Results
  Embossment, Supplementary Exams, Graduation List, and any report built from marks.

**Empty here means "no data", not "broken".** For those pages, only test the *mechanics*:
do the filters work, does validation fire, does the empty-state message show, are you
blocked where you should be. Do not expect a full mark-to-graduation flow to work unless
you manually load exam data first.

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
  This account can open **Admin** and **E-Learning** only. It **cannot** open the
  Academic, HR, or Student portals, even though it is powerful.
- **The back-end lock is by permission.** It decides what the server will actually let you
  do once a request reaches it. This account has almost every permission: manage students,
  academics, marks, results decisions, HR, payroll, notifications, and user accounts.

**Why this matters:** the account can *do* things on the back-end (like HR reads) that it
can never *reach* through the front-end. That is by design here, but worth confirming.

> **Judgement call, not a bug:** this registry account also holds top-level academic
> powers (publish marks, approve board marks, ratify result decisions) because of its
> super_admin role. Ask whether a registry admin *should* have those. If the answer is no,
> that is a role-design decision to escalate, not a code defect.

---

## 3. Login and session

- [ ] **Log in** as `admin@hit.ac.zw`. You should land on the Admin area.
- [ ] The menu shows **Admin** and **E-Learning** only. No Academic, HR, or Student.
- [ ] **Refresh the page** mid-session. You stay logged in and stay in Admin (the app
      re-checks your roles with the server on load).
- [ ] **Idle test:** the login token lasts 15 minutes. Leave a tab untouched for over 15
      minutes, then click something. It should refresh quietly and keep working (revisit
      this in §12).
- [ ] **Log out**, then try to open an admin page directly by URL. You should be bounced to
      the login page.

---

## 4. Admissions (the applicant-to-student journey)

An application moves through stages: draft → submitted → under review → recommended →
accepted → enrolled (or rejected). **Payment is the gate:** until an application is marked
paid, it is invisible to the selection and decision steps.

### 4.1 Capture a walk-in applicant
**What it is:** a form to enter an applicant who applies in person.
**How to test:**
1. Open Application Capture.
2. Fill in the personal and contact details, pick at least one programme choice, and add
   at least one complete past qualification (institution + qualification + a year between
   1950 and 2030).
3. Notice the **Submit button stays disabled** until one qualification is complete.
4. Submit.
**Pass looks like:** a new application is created with an application number, at status
"submitted".
**Things to probe:**
- The form asks for ~15 extra fields (title, marital status, passport, place of birth,
  home phone, entry type, provinces, choice order, previous-institution years) that are
  **not actually saved**. Enter values, then check the applicant's record later and confirm
  which fields survived.
- **After a successful submit the form does not clear.** If you click Submit again you may
  create a **duplicate application**. Try it and see.
- **Validation:** enter a bad email, a gender other than male/female/other, or a year
  outside 1950-2030. Each should show an error message **next to the field** (not a popup).
  The message text comes from the server's response, read out by a helper called
  `extractApiError`. (See the fuller explanation at the end of this section.)

### 4.2 Applications list
**What it is:** a table of every application, including drafts.
**How to test:** apply each filter (status, programme type, step 1-7, nationality,
special needs) and the search box. **Search runs when you press Enter.**
**Pass looks like:** rows filter correctly. Draft rows show "Step X/7"; finished ones show
"Complete". An empty result shows "No applications match these filters." 20 rows per page.

### 4.3 Applicant search
**What it is:** search applications by several criteria at once (drafts are excluded).
**Known issues:** the **View and Print buttons do nothing**, the **programme filter does
nothing**, and the first programme-choice column shows blank. Expect all three.

### 4.4 Admissions queue
**What it is:** a queue with stats, a table, and a details popup for approving/rejecting.
**Known issue (important):** the Approve/Reject buttons here **do not match the server's
rules**. Approve tries to jump an application straight to "accepted", but the server only
allows "accepted" from an "offered" state; Reject only works from "under review". So for a
normal submitted application, **Approve will fail with a 422 error, and the popup hides
that error** (it only shows in the Console). This is a known mismatch, not your mistake.
The real way to accept and enrol someone is the Selection → Clearance path below.

### 4.5 Admission dashboard
**What it is:** tabs for undergraduate/postgraduate/all, with stat cards and a
payment-methods breakdown.
**Pass looks like:** cards render. With no payments on staging, revenue shows $0 and you
see "No payments yet." That is expected.

### 4.6 Admission register
**What it is:** Accepted / Enrolled / Rejected tabs, grouped by programme; click a
programme to see its applicants.
**Pass looks like:** groups render; a programme with nobody shows "No {outcome} students
yet."

### 4.7 Admission payments
**What it is:** payment summary tiles plus a filterable transactions table (search on
Enter).
**Pass looks like:** **empty on staging** (no payments). The applicant column shows an
email, not a name.

### 4.8 Application clearance: the real way to enrol someone
**What it is:** the working path that turns an accepted applicant into an enrolled student.
**How to test:**
1. Open Application Clearance. The left list shows applications that are "accepted" or
   "enrolled". Pick one.
2. Work through the 3-item checklist (documents, eligibility, fee): mark each Cleared (or
   Reject/Reset), adding notes.
3. The **"Enrol Applicant" button stays disabled until all 3 items are cleared.** The
   server also re-checks, so it refuses (422) if you somehow bypass this.
4. Enrol.
**Pass looks like:** a new student record is created (status active), a start date is set,
the application flips to "enrolled", and an event is broadcast to the academic service.
**Then confirm:** the new student appears in the Student List (§5.2). This is the key
handoff between two services.
**Note:** to *get* an application to "accepted" needs the selection path (HOD recommends →
admissions finalises), which itself needs payment = paid and selection open (§4.10). On
staging with no payments, you may need a developer to seed an accepted application so you
can test enrolment at all.

### 4.9 Fee structure
**What it is:** define fees (application, tuition, registration, graduation) per study
level and currency, plus clearance tolerances.
**How to test:** add a fee (the Add button is disabled if the amount is empty), then delete
one. Set the tolerance values (0 or more; 0 means "must be fully cleared").
**Known issue:** there is **no edit**: you can only delete and re-add a fee.

### 4.10 Admission settings
**What it is:** switches for the undergraduate/postgraduate application windows, a global
selection open/close, and per-programme selection overrides.
**Key dependency to test:** the per-programme switches are **disabled while the global
selection switch is off**. Also, when selection is closed, the HOD "recommend" step fails
(422). This one switch gates the whole decision pipeline.

### 4.11 Old admissions landing page
**Known issue:** if you can reach the legacy `Admissions.tsx` page, it shows **fake
hard-coded numbers** (127/45/68/52) and makes no real requests. Treat it as dead.

> **The validation line explained (from §4.1):** "Invalid email / gender not in
> male,female,other / year outside 1950-2030 → inline validation error via
> extractApiError" means: if the email is malformed, the gender is not one of the three
> allowed values, or the year is outside 1950-2030, the request is rejected and an error
> message appears next to the offending field. The message text is pulled from the server's
> response by a helper called `extractApiError`, rather than being hard-coded in the page.

---

## 5. Enrolled students and their records

The chain here: accepted applicant → enrol → student record → registration (needs fees) →
marks → GPA → clearance → graduation fee → conferral.

### 5.1 Enrol student (by acceptance code)
**How to test:**
1. Open Enrol Student. Enter an **accepted** applicant's acceptance code.
2. Their details show. Click Enrol.
**Pass looks like:** a student record and a registration number (`HIT-{prog}-{year}-{0000}`)
are created; the applicant flips to "enrolled".
**Things to probe:**
- The server actually keys on the applicant's internal ID, not the code you typed, so the
  code is not re-verified at enrol time.
- A non-accepted applicant shows an amber warning and no Enrol button. A bad code shows
  "Invalid acceptance code."
- **Known issue:** if enrol fails, you get a generic "Enrollment failed" that does **not**
  show the server's actual reason.
- **Race condition to probe:** registration numbers are generated by counting existing ones
  and adding 1, with no uniqueness guard. If you can, enrol two applicants for the same
  programme at nearly the same moment (two tabs) and check for a duplicated number.
- Enrolling the same applicant twice shows "already enrolled."

### 5.2 Student list
**What it is:** a searchable, paginated list (type 3+ characters to search), filtered by
programme and level. It reads the academic service, the authoritative store of enrolled
students.
**Known issue:** the **Clearance Status column always shows "—"** (that data lives in a
different service and isn't included here).
**Things to probe:** rows carry academic-service IDs, but clicking into a student loads the
*student* service by ID. Click in and confirm you get the **right person** (an ID mismatch
between services is a latent risk).

### 5.3 Student details
**What it is:** a read-only profile: personal info, academic card, downloadable documents,
modules, and the resolved regulation badge.
**How to test:** open a student; try a document download; try a bad ID in the URL.
**Pass looks like:** profile loads; documents actually download (not a hidden 401 error); a
bad ID shows "Student not found." A student with no modules shows no regulation badge (that
is expected).

### 5.4 Clearance management (finance clearance)
**What it is:** a queue of students, each with clearance items across departments you can
mark cleared/pending with notes. **This is different from admissions clearance in §4.8.**
**Key behaviours to test:**
- The **finance item is driven automatically from the student's ledger** when you open one
  student. So if you manually toggle finance, then re-open that student, it reverts to the
  ledger value. Confirm this.
- **Empty-ledger trap:** if the ledger shows nothing paid and nothing owed, finance stays
  under manual control (empty is not the same as "owes nothing"). On staging with no
  payments, this is normal.
- **Queue lag:** the queue shows a saved summary, not a live ledger read, so a finance
  change may not appear in the queue until that student is opened individually.
- Overall status moves not-started → pending → cleared (when all items are cleared).

### 5.5 Transcript management
**How to test:** pick a student; the official transcript renders, modules grouped by
session, with a GPA.
**Known issue:** "Download PDF" just triggers the browser's **Print** dialog: there is no
real server-generated PDF.
**Things to probe:** there is **no fee or clearance check** before issuing a transcript : 
anyone selectable can be transcribed. Decide whether that is acceptable policy.

### 5.6 Graduation list
**What it is:** lists awards (candidate/conferred), filterable by programme and status.
**Pass looks like:** **empty on staging** (nobody has completed a programme).
**Key behaviour:** conferring is **gated on the graduation fee being paid**. If unpaid, you
get a 422 error **shown in full on screen**: that is the fee gate correctly refusing, not
a glitch.
**Note:** an old doc (`STUDENT_LIFECYCLE_STATUS.md`) says conferral is *not* fee-gated.
That doc is stale; the code gates it. Trust the code.

### 5.7 Supplementary exams
**What it is:** a read-only list of students carrying a supplementary decision.
**Pass looks like:** **empty on staging.** Note the semester filter is a fragile free-text
match (must match the stored text exactly).

---

## 6. Results (marks and result decisions)

**Whole area is empty on staging** (no exam results exist). Test the mechanics only. For
context, marks flow lecturer → chairperson → dean → exams-verify → academic board approve →
registry publish → student. This account can publish and can propose/ratify decisions.

### 6.1 Results publication
**Test:** select semester/school/programme/level/format.
**Watch for:** there is **no validation**: the button is always enabled and does not check
that approved marks exist.
**Known issue:** the "Download" button does nothing; the success message is a fake 8-second
timer with no real document.

### 6.2 Results decision entry
**Test:** look up a student by registration number, set a per-module decision (Pass, Fail,
Supplementary, Repeat, Absent, Deferred, Withheld, Carry).
**Two save paths:** **Save** writes directly; **Propose to Board** is limited to your own
department and warns you if you try another. A bad reg number shows "Student not found."
**Known issue:** in the mock/dev environment, "Propose to Board" hits a missing endpoint
(404). On the real back-end it should work: confirm which environment you are in.

### 6.3 Results embossment
**Test:** per-programme finalisation. A programme is only "Ready" to emboss when **every
student's results are approved** and it is not already done.
**Pass looks like:** correct status badges (Embossed / Ready / Partial / Pending). There is
no explicit error message if a change fails.

### 6.4 Academic board report
**Test:** choose Group (by programme/level) or Individual (one reg number). The only
validation is that Generate is disabled for Individual with an empty reg number.
**Known issue:** the "Download" button does nothing.

---

## 7. Academic structure (schools down to modules)

The hierarchy is School → Department → Programme → Module. This account can manage all of
it.

### 7.1 Schools
**Test:** create, edit, delete a school. Deleting warns that it cascades to departments;
deleting one with linked records pops an alert and the server refuses.

### 7.2 Departments
**Test:** create/edit/delete; filter by school. With no schools yet, the empty state tells
you to "Create a school first." Deleting a department with linked programmes pops an alert.

### 7.3 Programmes
**Test:** list, filter, and create (via a dialog). A row links to its assessments page.
**Known issues:** **Edit does nothing** (it only logs to the console). **Create "succeeds"
silently**: no confirmation and no refresh, so a newly created programme may not appear
until you reload the page.

### 7.4 Programme types
**Test:** create (code + name; code is lowercased), toggle active, and assign allowed study
levels via checkboxes. A type that is **in use cannot be deleted** (the server refuses with
a clear 422). This is the one area confirmed working end-to-end on staging.

### 7.5 Assessment types
**Test:** per-programme assessment types with a weight chart and config panel. Needs a
valid programme. Error/empty handling is thin here: watch the Network tab.

### 7.6 Regulations
**Test:** list, create, clone, activate, withdraw; bind a cohort; record consent.
**State rules to confirm:** Activate only shows for drafts; Withdraw disappears once
withdrawn; withdrawn/superseded regulations become read-only ("clone to amend"); Withdraw
warns it cannot be undone.
**Known issue: do not certify:** postgraduate/PhD cohort binding is **deliberately
incomplete**. One binding per intake year currently governs all levels, so a postgraduate
student can silently pick up undergraduate rules (wrong pass mark or duration). The
decision on record is: **do not bind 2026 postgraduate until a later phase.** Undergraduate
binding will look fine; do not sign off postgraduate/PhD binding.

### 7.7 Modules
**Test:** create/edit/delete modules; assign lecturers (names come from the HR service). If
HR has no employees, the lecturer picker is empty.
**Known issue:** create "succeeds" silently (only logs to console), no on-screen feedback.

### 7.8 Module weighting
**Test:** pick a programme then a module, add components. **Weights must add up to 100%** : 
a live total turns red/green and warns "must sum to 100%." This is the strongest validation
in the whole app, so exercise it: try totals of 99% and 101% and confirm it blocks or
warns.

### 7.9 Study levels
**Test:** create (code + name; code lowercased), edit, delete. A level **in use cannot be
deleted.** These feed programme types, programmes, fees, and regulation binding.

### 7.10 Timetable manager
**Test:** create/edit/delete exam timetable entries. The venue field is required by the
browser.
**Things to probe:** there is **no overlap or ordering check.** Set an end time before the
start time, or book two exams in the same venue at the same time: both are wrongly
accepted. Saving failures are silent. Probe these.

### 7.11 Attendance slips wizard
**Test:** a 3-step flow (programme → modules → generate); the Next buttons require a
selection. A programme with no modules shows "No modules found."
**Known issue:** "Download PDF" does nothing, even though the mock response includes a
document link.

---

## 8. Users, roles, and audit (super_admin area)

### 8.1 User management
**Test:** list/search/filter users; create a user (name, unique email, password 8+ chars,
at least one role, active/inactive). Edit a user and assign roles via chip toggles. Try a
small valid CSV import and a malformed one.
**Known issues:**
- **super_admin and admin are missing from the assignable-role list**: you cannot grant
  super_admin through this screen (only via the database). Check the picker's contents.
- The row "⋯" menu is mostly dead: **"Deactivate" does nothing**, **"Manage Roles" just
  duplicates Edit**, and delete / toggle-status / reset-password / unlock are not wired up.
- The status filter offers "suspended", which is **not a real status** and returns nothing.
- Creating a user with no roles is blocked both on screen and by the server.

### 8.2 Roles and permissions
**Note:** this page is restricted to admin/super_admin, so it loads for this account. An
account with only registry_admin would be bounced: worth confirming that boundary
separately.
**Test:** create a custom role or permission (slug must match `^[a-z][a-z0-9_.-]*$` and be
unique). Assign permissions to a role via checkboxes.
**Must-be-blocked test:** seeded ("system") roles hide their delete button. Try to delete
one anyway (e.g. via a crafted request): the server must refuse with "System
roles/permissions cannot be deleted." A confirm dialog appears before every delete.

### 8.3 Activity logs
**Test:** an audit table with search, action filter, date range, CSV export, and a detail
popup.
**Known issue:** the table expects fields the back-end does not send, so the **User, Email,
and Description columns render empty and the pagination control never appears.** The **CSV
export, however, works** and has the right columns. Confirm actions you took earlier
(user created, roles assigned, role created, login) actually appear as rows even though the
display columns are thin.

### 8.4 Confirm the audit trail
**Test:** after §8.1-8.2, export the CSV and confirm your actions were logged, with old/new
value diffs (passwords stripped out).

---

## 9. Reports, settings, dashboard

### 9.1 Admin dashboard
**Test:** three stat cards plus a Recent Activity feed that refreshes every 30 seconds. The
stats come from the student service. An empty feed shows "No recent activity"; drafts are
filtered out.

### 9.2 Reports
**Test:** Enrollment / Performance / Demographics, with a year selector and export.
Performance and Demographics may be thin or empty (a known incomplete area on the
back-end). Expect sparse data on staging.

### 9.3 Settings
**Test:** tabs for Profile, Security, Preferences, and a **System** tab. The System tab
shows for this account because it has registry_admin. You can edit academic year, current
semester, registration open, maintenance mode, system name, and system email.
**Try:** toggle maintenance mode on, confirm the effect, then toggle it back.
**Note:** the System tab is oddly gated on registry_admin specifically: a pure
admin/super_admin would not see it even though the back-end would allow them.

### 9.4 Placeholder settings page
**Known issue:** if the old `Settings.tsx` page is reachable, its six "Configure" buttons
are all dead. It is a non-functional placeholder.

---

## 10. E-Learning (admin view)

**Test:** open `/elearning`. This account reaches it because registry_admin is mapped to
the e-learning "admin" view. You should see ERP Sync Status and Integrations.
**Known issue:** there is a slug mismatch: the e-learning shell checks for `'admin'` /
`'superadmin'` (no underscore), but the real role slug is `super_admin`. This account gets
in via the registry_admin → admin mapping. A *pure* super_admin would **not** match and
would be denied. Note which mapping let you in.

---

## 11. Things that must be blocked (negative tests)

The front-end blocks by role, and there is no super_admin override, so:

- [ ] Type `/academic` (and sub-pages) into the URL → you should be redirected to the
      dashboard. This account holds academic *permissions* on the back-end but is not in
      the academic *portal*.
- [ ] Type `/hr` → redirected. (Has HR read/write permission, but no HR portal role.)
- [ ] Type `/student` → redirected.
- [ ] Confirm no Academic/HR/Student menu items appear anywhere.
- [ ] **Optional deeper check (design note):** if an HR or academic *page* were ever
      reached by mistake, the back-end would allow **reads** but block HR *management*
      (403). Worth a direct API probe if you want to certify the back-end boundary, not
      just the menus.

---

## 12. The permission-timing trap (subtle but important)

Your roles and permissions are **stamped into your login token when you log in.** Services
trust that token and do not re-check on every request. So:

- [ ] Give a test user a new role, then log in **as that user immediately** in another
      browser. They will still have the **old** access. This is correct behaviour, not a
      bug.
- [ ] Have them log out and back in (or wait past the 15-minute token life). The new access
      now takes effect. **Always re-issue the token before checking a permission change** : 
      testing too quickly shows stale access and looks like a bug.
- [ ] Note: there is **no instant force-revoke** when a role changes. A still-valid token
      keeps working until it expires.
- [ ] Note for security review: revocation is **fail-open**: if the cache (Redis) is down,
      revoked tokens are still accepted.

---

## 13. Known issues at a glance (do NOT report these as new bugs)

If you hit exactly one of these, it is expected. A *different* failure is a new bug.

**Dead or stub buttons/pages:**
1. Old `Admissions.tsx` landing: fake hard-coded data.
2. Applicant search: View/Print dead, programme filter dead, first choice column blank.
3. Results publication: "Download" dead; success is a fake timer.
4. Academic board report: "Download" dead.
5. Attendance slips: "Download PDF" dead.
6. Transcript "Download PDF" = browser print, no real PDF.
7. Programmes: Edit does nothing; Create succeeds silently (no refresh).
8. Modules: Create succeeds silently.
9. Fee structure: no edit, only delete and re-add.
10. Old `Settings.tsx`: all "Configure" buttons dead.
11. User row menu: Deactivate dead; Manage Roles duplicates Edit; several actions unwired.

**Mismatches between screen and server:**
12. Admissions queue Approve/Reject conflicts with the server's rules → 422, error hidden.
13. Activity logs: User/Email/Description columns empty, no pagination (CSV works).
14. Student list Clearance Status always "—".
15. Enrol failure shows a generic message, not the real reason.
16. super_admin/admin not offered in the user-management role picker.
17. User-management "suspended" status filter is not real.
18. Results "Propose to Board" 404s in dev/mock; should work live.
19. E-learning slug mismatch (`superadmin` vs `super_admin`).
20. A pure super_admin is wrongly denied some admin pages; this account gets in via
    registry_admin. Guard coverage is inconsistent across pages.
21. Settings System tab gated on registry_admin only.

**Deliberately unfinished:**
22. Postgraduate/PhD regulation binding: do not certify (see §7.6).
23. Whole payment-driven lifecycle is inert on staging (empty results/graduation/payments).
24. One of two "publish results" code paths is a documented no-op.

**Stale docs (trust the code):**
25. `STUDENT_LIFECYCLE_STATUS.md` says conferral isn't fee-gated: it now is.
26. `PROCESS_FLOWS.md` / `MARKS_WORKFLOW.md` describe old API shapes.
27. `SYSTEM_ADMIN_CREDENTIALS.md` references a role slug that isn't seeded; test accounts
    use password `password`.
28. `CURRENT_BLOCKERS.md` is largely stale.

---

## 14. Sign-off

- [ ] All the normal (happy-path) checks in §3-§10 pass, ignoring the known issues in §13.
- [ ] All the "must be blocked" checks in §11 are confirmed blocked.
- [ ] You understand and have verified the permission-timing behaviour in §12.
- [ ] No *new* (undescribed) failures found: or each new one logged separately.
- [ ] The role-design question in §2 (board-level powers on a registry account) has been
      escalated for a decision.

Tester: __________   Date: __________   Build/commit: __________
