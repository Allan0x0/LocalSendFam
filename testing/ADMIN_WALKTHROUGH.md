# Admin Portal Walkthrough — `admin@hit.ac.zw` (super_admin + registry_admin + admissions_officer)

Manual UI test script for the top-privilege registry/admin account, run against the
**live staging** deploy (disposable data). Goal: absolute confidence that every part of
the product this account can reach works, fails safely where it should, and that the
known gaps are known (not mistaken for regressions).

- **User under test:** `admin@hit.ac.zw`. "Same kind" = any account holding the same
  three seeded roles (`super_admin`, `registry_admin`, `admissions_officer`). This is a
  DB fact (`services/auth/database/seeders/UserSeeder.php:18`), not a hardcoded flag — to
  test another account of the same kind, confirm its roles in User Management first.
- **How to use:** work top to bottom. Tick `[ ]`→`[x]` on pass. If a step is in the
  **Known-issues register** (§13), a failure there is *expected* — verify it matches the
  described behavior and move on; only a *different* failure is a new bug.
- **Legend:** ✅ expected pass · ⚠️ edge/outlier to probe · 🔒 negative (must be blocked)
  · 🐛 known issue (see §13) · 🔗 cross-service/async.

---

## 1. Preflight & environment

- [ ] Frontend reachable (`:5177` behind the gateway), gateway up (`:8000`).
- [ ] Services up: auth `:8001`, student `:8002`, academic `:8003`, hr `:8004`, notify `:8005`.
- [ ] Confirm this is **staging**, not production, before creating/deleting anything.
- [ ] Reset path known: re-run seeders (`RoleSeeder`, `PermissionSeeder`, `UserSeeder`,
      academic/student demo seeders) to restore a clean baseline if data gets tangled.
- [ ] Browser devtools open on the **Network** and **Console** tabs for the whole run —
      most silent failures here are a 4xx/5xx with no UI toast (several pages swallow
      errors to `console.error`).

### ⚠️ Data-state caveat — read before testing results/graduation

The downstream lifecycle is **inert on staging**: no payment rail is wired
(`bank_payments = 0`), so `exam_results`, `module_marks`, and `graduands` are empty.
Consequence: **Results Publication, Results Decision Entry, Results Embossment,
Supplementary Exams, Graduation List, and any marks-derived report will render empty —
that is the data state, not a bug.** Only test their *mechanics* (filters, validation,
empty states, permission gates), not end-to-end mark flow, unless you first seed exam
results manually. Flag empty-vs-broken accordingly.

---

## 2. The account's real access map (what "can reach" means)

Two independent gates decide what this account can do. They do **not** always agree —
that disagreement is the single most important thing this script verifies.

- **Frontend gate = role** (`ProtectedRoute` / `portalRoles`). Routes this account into
  `/admin` and `/elearning` only. `/academic`, `/hr`, `/student` are **not reachable**.
- **Backend gate = permission** (JWT `permissions` claim, union of the three roles).
  Nearly omnipotent: it can read/write students & academics, manage academic structure &
  sessions, **publish marks, approve board marks, propose & ratify result decisions**,
  read/write HR & payroll, manage notifications, and administer auth (users/roles).

**Effective permission union** (from `PermissionSeeder.php`):

| Source role | Grants |
|---|---|
| `registry_admin` | `students.read/write/manage`, `academics.read/write/manage`, `academic-sessions.manage`, `modules.assessments.manage` |
| `super_admin` | `marks.publish`, `marks.approve.coursework/exam/board`, `marks.verify`(no), `results.decisions.propose/ratify`, `modules.assign`, `programmes.approve`, `auth.admin`, `hr.read/write`, `payroll.read/write`, `notifications.manage`, `elearning.manage`, plus students/academics read+write |
| `admissions_officer` | `students.read/write` |

> ⚠️ **QA judgement call, not a bug:** `super_admin` gives this registry account
> Academic-Board / VC-level powers (`marks.publish`, `marks.approve.board`,
> `results.decisions.ratify`) and exposes them **through the admin portal** (Results
> pages). Decide whether a registry admin *should* hold these. If not, it's a
> role-design finding, not a code defect.

---

## 3. Login & session

- [ ] ✅ Log in as `admin@hit.ac.zw`. Lands on `/admin` (LANDING_PREFERENCES sends
      `registry_admin` → `/admin`).
- [ ] ✅ Sidebar/portal tiles show **Admin** and **E-Learning** only (not Academic/HR/Student).
- [ ] ⚠️ Refresh the page mid-session — session rehydrates and roles are re-pulled from
      the server on boot (`App.tsx:151`); you stay on `/admin`.
- [ ] ⚠️ Token TTL is **15 min** access / 14 day refresh. Leave a tab idle >15 min, then
      act — the client should refresh transparently. Note this for §12.
- [ ] 🔒 Log out; confirm protected routes bounce to `/auth/login`.

---

## 4. Admissions lifecycle  🔗 (student service :8002)

Canonical status flow: `draft → submitted → under_review → hod_recommended → accepted →
enrolled` (+ `rejected`). **Payment is the gate** — an application is invisible to the
selection/decision flow until `payment_status = 'paid'`.

### 4.1 Application Capture (`/admin/admissions/capture`)
- [ ] ✅ Create a walk-in applicant. Requires: application period, full personal/contact
      block, ≥1 study choice, and **≥1 complete qualification** (institution + qualification
      + year 1950–2030) — Submit is disabled until a qualification is complete.
- [ ] ✅ New application is created at status `submitted` with an application number.
- [ ] ⚠️ **Field drop:** the form collects ~15 fields (title, marital status, passport,
      place of birth, home phone, entry type/mode, provinces, study-choice order, previous
      institution years) that are **not sent** to the backend. Confirm what actually
      persists vs. what you typed (check StudentDetails / register later).
- [ ] ⚠️ **No reset on success:** after a successful submit the form keeps its values.
      Click Submit again → risk of a **duplicate application**. Probe this.
- [ ] ⚠️ Invalid email / gender not in `male,female,other` / year outside 1950–2030 →
      inline validation error via `extractApiError`.

### 4.2 Applications list (`/admin/admissions/applications`)
- [ ] ✅ Table lists every application incl. drafts; server-side filters: status,
      programme_type, step 1–7, nationality, search, special_needs. Search fires on **Enter**.
- [ ] ✅ Draft rows show `Step X/7`; others show "Complete".
- [ ] ⚠️ Empty filter combo → "No applications match these filters." Paginates at 20.

### 4.3 Applicant Search (`/admin/admissions/search`)
- [ ] ✅ Multi-criteria search returns matching applications (drafts excluded).
- [ ] 🐛 **View / Print buttons are dead stubs** (no handler). **Programme filter does
      nothing.** `programme_choice_1` renders blank. (§13)

### 4.4 Admissions Queue (`/admin/admissions`)
- [ ] ✅ Stats cards + queue table + details dialog render.
- [ ] 🐛 **Approve/Reject from this queue is misaligned with the backend transition
      table.** Approve sends `status=accepted`, but `accepted` is only reachable from
      `offered`; Reject only works from `under_review`. So a `submitted`/`under_review`
      application **cannot be approved here — expect a 422** ("Cannot transition…"), and
      the dialog **swallows the error to console** (no toast). This is a known conflict,
      not your mistake. (§13) The *real* accept path is Selection → Clearance (below).

### 4.5 Admission Dashboard (`/admin/admissions/dashboard`)
- [ ] ✅ UG/PG/all tabs; 8 stat cards + payment-methods breakdown + avg payment.
- [ ] ⚠️ Empty payments → "No payments yet." Stats derive from status GROUP BY; revenue
      only counts `paid` payments (expect $0 on staging).

### 4.6 Admission Register (`/admin/admissions/registers`)
- [ ] ✅ Accepted / Enrolled / Rejected tabs, grouped by programme, drill into a programme
      to list applicants.
- [ ] ⚠️ Programme with no applicants → "No {outcome} students yet." Unknown programme id
      falls back to `Programme {id}`.

### 4.7 Admission Payments (`/admin/admissions/payments`)
- [ ] ✅ Summary tiles + filterable transactions table (search on Enter; status/channel/date).
- [ ] ⚠️ Expect **empty on staging** (no payment rail). Applicant column shows email, not name.

### 4.8 Application Clearance → **the real enrol path** (`/admin/admissions/clearance`)  🔗
- [ ] ✅ Left list = applications with status `accepted`/`enrolled`. Pick one.
- [ ] ✅ 3-item checklist (documents, eligibility, fee): Clear/Reject/Reset each, with notes.
- [ ] ✅ "Enrol Applicant" is **disabled until all 3 items are `cleared`**; backend
      re-checks (422 if not).
- [ ] 🔗 On enrol: creates a `Student` (`status=active`), sets programme start date, flips
      application to `enrolled`, and **publishes `student.student_enrolled` on the Redis
      bus** → consumed by academic :8003. Verify the student then appears in Student List
      (§5.2) — this is the key cross-service handoff.
- [ ] ⚠️ Try to open clearance on a `submitted` application (not accepted) → 422 "Only
      accepted applications can be cleared."
- [ ] ⚠️ To *get* an application to `accepted` you need the Selection path
      (HOD `recommend` → Admissions `finalize`), which itself requires
      `payment_status=paid` **and** selection open (§4.10). On staging with no payments,
      you may have to seed an `accepted` application directly to exercise enrol.

### 4.9 Fee Structure (`/admin/admissions/fees`)
- [ ] ✅ Add fee (type application/tuition/registration/graduation, study_level, amount,
      currency). Add disabled if amount is falsy.
- [ ] ✅ Delete a fee. Tolerances panel: `results_fees_tolerance`, `clearance_tolerance`
      (≥0). `0` = "must be fully cleared" (explained inline).
- [ ] 🐛 **No edit** — a fee can only be deleted and re-added (backend PUT exists but is
      unwired). (§13)
- [ ] ⚠️ No fees defined → application fee falls back to system default (stated in empty state).

### 4.10 Admission Settings (`/admin/admissions/settings`)
- [ ] ✅ Toggle UG/PG application windows, global selection open/close, per-programme
      selection overrides.
- [ ] ⚠️ **Dependency:** per-programme toggles are **disabled when global
      `selection_open` is false** (amber note). Selection being closed also makes HOD
      `recommend` return 422 — this gates the whole decision pipeline.

### 4.11 Admissions landing (`/admin/admissions` legacy `Admissions.tsx`)
- [ ] 🐛 If reachable, this is **fully hardcoded mock data** (fake counts 127/45/68/52,
      fake applicants). No API calls. Treat as dead/placeholder. (§13)

---

## 5. Enrollment & student records  🔗 (academic :8003 + student :8002)

Lifecycle dependency: accepted applicant → **enrol** → Student (academic) → registration
(fee-gated) → module marks → GPA → clearance → graduation-fee → **confer**.

### 5.1 Enrol Student (`/admin/enrollment`)
- [ ] ✅ Look up an **accepted** applicant by acceptance code; details show; Enrol creates
      the Student + reg number `HIT-{prog}-{year}-{0000}`, flips applicant to `enrolled`.
- [ ] ⚠️ **Server keys on `applicant_id`, not the acceptance code** (`EnrolStudentRequest`
      validates only `applicant_id`). The code you type is not re-verified on enrol.
- [ ] ⚠️ Look up a non-accepted applicant → amber warning, no enrol button. Invalid code →
      "Invalid acceptance code."
- [ ] 🐛 Enrol failure shows a **generic "Enrollment failed"** — it does **not** surface
      the backend 422 reason (unlike Graduation). (§13)
- [ ] ⚠️ 🔗 **Reg-number generation is race-prone** (count+1 `like`, no unique guard). If
      you can, enrol two applicants for the same programme near-simultaneously (two tabs)
      and check for a duplicate/collided reg number.
- [ ] ⚠️ Double-enrol the same applicant → "already enrolled".

### 5.2 Student List (`/admin/students`)
- [ ] ✅ Paginated/searchable list (search ≥3 chars) filtered by programme + level.
      **Reads the academic service** (`/academic/students`), the authoritative enrolled store.
- [ ] 🐛 **`clearance_status` column always shows "—"** — that data lives in the student
      service and isn't on the academic list resource. (§13)
- [ ] ⚠️ 🔗 **Cross-service id spaces:** rows carry academic-service ids, but StudentDetails
      / Clearance / Transcript read the **student service** by id. Click into a student and
      confirm the details page loads the *right* person (id-mismatch is a latent risk).

### 5.3 Student Details (`/admin/students/:id`)
- [ ] ✅ Read-only profile: info, academic card, documents (with download), modules,
      resolved regulation badge.
- [ ] ⚠️ Student with no modules → no progression fetch, no regulation badge (expected).
- [ ] ⚠️ Bad/missing id → "Student not found"; load failure → "Failed to load".
- [ ] ⚠️ Document download goes through the authed client as a blob — confirm the file
      actually downloads (not an inline 401).

### 5.4 Clearance Management (`/admin/clearance`)  🔗 (student :8002 — **finance clearance**, distinct from §4.8)
- [ ] ✅ Queue of students; open one → clearance items across all departments; toggle each
      cleared/pending with notes.
- [ ] ⚠️ **`finance` item is auto-driven from the Ndarama ledger** on single-student reads
      (`syncFinanceFromLedger`) — manual finance sign-off is overridden. Toggle finance,
      re-open the student, confirm it reverts to the ledger-derived value.
- [ ] ⚠️ **Empty-ledger trap:** if the ledger shows `paid<=0 && balance<=0` finance stays
      under manual control (empty ≠ owes nothing). On staging (no payments) this is the
      normal state.
- [ ] ⚠️ **Queue lag:** the queue reads the persisted rollup (no per-row ledger call), so a
      finance change can lag there until that student is fetched individually.
- [ ] ✅ Rollup status: `not_started` → `pending` → `cleared` (all items cleared).

### 5.5 Transcript Management (`/admin/transcripts`)
- [ ] ✅ Pick a student → official transcript renders; modules grouped by session; GPA shown.
- [ ] 🐛 **"Download PDF" is just `window.print()`** — no server-side PDF. (§13)
- [ ] ⚠️ **No clearance/fee gate** on issuing a transcript — anyone selectable can be
      transcribed. Decide whether that's acceptable policy.
- [ ] ⚠️ Student with no marks → "—" per cell / "No academic records available yet".

### 5.6 Graduation List (`/admin/graduation`)  🔗
- [ ] ✅ Lists persisted Awards (candidate/conferred), filter by programme/status.
- [ ] ⚠️ Expect **empty on staging** ("Awards appear once a student completes their
      programme") — no completed GPAs exist.
- [ ] ⚠️ Confer is **gated on `graduation_fee_paid_at`** (stamped by the
      `student.graduation_fee_paid` bus event). Unpaid → **422 surfaced verbatim** — this
      is the fee gate refusing, correct behavior, not a transient error.
- [ ] ✅ Confer button is client-gated on `academics.manage` / `admin` (this account has it).
- [ ] ⚠️ Note: `STUDENT_LIFECYCLE_STATUS.md` says confer is *not* fee-gated — that doc is
      **stale**; the code gates it. Trust the code.

### 5.7 Supplementary Exams (`/admin/supplements`)
- [ ] ✅ Read-only list of students carrying a `Supplementary` decision.
- [ ] ⚠️ Semester filter is a **free-text substring** — must match the stored value
      exactly (fragile). Expect **empty on staging**. No action to schedule a sitting
      (informational only).

---

## 6. Results  🔗 (academic :8003 — endpoints are **unprefixed** `/results/*`)

> ⚠️ Whole cluster is **empty on staging** (no exam results). Test mechanics only.
> Marks governance flow (for context): lecturer → chairperson → dean → exams-verify →
> **academic-board approve** → **registry publish** → student. This account holds
> `marks.publish` + `results.decisions.propose/ratify` via super_admin.

### 6.1 Results Publication (`/admin/results`)
- [ ] ⚠️ Select semester/school/programme/level/format; **no validation, button always
      enabled**, no check that board-approved marks exist.
- [ ] 🐛 **"Download" button is inert** (no handler); success is a fake 8s timer with no
      document. (§13)

### 6.2 Results Decision Entry (`/admin/results/decisions`)
- [ ] ✅ Look up a student by reg number; set per-module decision (Pass/Fail/Supp/Repeat/
      Absent/Deferred/Withheld/Carry).
- [ ] ✅ Two write paths: **Save** (direct) vs **Propose to Board** (gated by
      `results.decisions.propose`, department-scoped). Propose error explicitly warns
      "you may only propose for your own department."
- [ ] 🐛 Under MSW/dev mocks, `/results/decisions/propose` has **no handler → 404**; on the
      live backend it should work. Confirm which environment you're in. (§13)
- [ ] ⚠️ "Student not found" on a bad reg number.

### 6.3 Results Embossment (`/admin/results/embossment`)
- [ ] ✅ Per-programme finalisation; a programme is **"Ready"/embossable only when
      `results_approved == total_students`** and not already complete. "Emboss All Ready"
      appears only if something is ready.
- [ ] ⚠️ Status badges: Embossed / Ready / Partial / Pending. No explicit mutation-error UI.

### 6.4 Academic Board Report (`/admin/board-reports`)
- [ ] ✅ Group (programme/level) or Individual (single reg number) report. **Only
      validation:** Generate disabled when Individual + empty reg number.
- [ ] 🐛 **"Download" button inert** (no handler); returned document not consumed. (§13)

---

## 7. Academic structure  🔗 (academic :8003, gate `can:manage-academic`)

Hierarchy order: **School → Department → Programme → Module**, with Study Levels &
Programme Types as vocabularies. This account has `academics.manage` — all should work.

### 7.1 Schools (`/admin/schools`)
- [ ] ✅ Create / edit / delete a school (+ dean, dept counts).
- [ ] ⚠️ Delete warns it **cascades to departments**. Delete a school with linked records →
      `window.alert` "may still have linked records" (backend refuses).

### 7.2 Departments (`/admin/departments`)
- [ ] ✅ Create/edit/delete; filter by school.
- [ ] ⚠️ With **no schools**, empty state enforces order: "Create a school first."
- [ ] ⚠️ Delete a dept with linked programmes → alert "may still have linked programmes."

### 7.3 Programmes (`/admin/programmes`)
- [ ] ✅ List/filter; **create** via dialog; row → assessments page.
- [ ] 🐛 **Edit is unimplemented** — the edit action only `console.log`s. **Create success
      is a `console.log` stub** — no toast/refetch, so a created programme may not appear
      until you reload. (§13)

### 7.4 Programme Types (`/admin/programme-types`)
- [ ] ✅ Create (code+name required, code lowercased), toggle active, assign allowed Study
      Levels via checkboxes.
- [ ] ⚠️ A type **in use cannot be deleted** (server 422 surfaced). This is the one cluster
      confirmed working end-to-end on staging.

### 7.5 Assessment Types (`/admin/programmes/:id/assessments`)
- [ ] ✅ Per-programme assessment types + weight chart + config panel. Requires a valid
      programme id.
- [ ] ⚠️ Thin page shell — error/empty handling is delegated to child components; watch
      the network tab.

### 7.6 Regulations (`/admin/regulations` + `/:id`)
- [ ] ✅ List/create/clone/activate/withdraw; bind cohort; record consent.
- [ ] ✅ **State machine:** Activate shows only when `status=draft`; Withdraw hidden once
      withdrawn; `readOnly` (params locked, "clone to amend") when withdrawn/superseded.
      Withdraw confirms "cannot be undone."
- [ ] 🐛 ⚠️ **PG/PhD cohort binding is deliberately incomplete** (REGULATION_BINDING_LEVEL_
      FIX_PLAN, proposed, unassigned): one binding per intake year governs UG/PG/PhD alike,
      so a PG student can silently resolve to a UG regulation (wrong pass mark / duration).
      Decision on record: **do not bind 2026-PG until Phase 3.** UG binding will look fine;
      **do not certify PG/PhD binding.** Re-bind cache staleness (up to 1h) was deferred. (§13)

### 7.7 Modules (`/admin/modules`)
- [ ] ✅ Create/edit/delete modules; assign lecturers (names resolved from **HR employees**
      via `/hr/employees`).
- [ ] ⚠️ 🔗 Cross-service: if HR has no employees, the lecturer picker is empty.
- [ ] 🐛 Create success is a `console.log` stub — no user feedback. (§13)

### 7.8 Module Weighting (`/admin/module-weighting`, gate `modules.assessments.manage`)
- [ ] ✅ Cascading programme → module selects; add components; **weights must sum to 100%**
      (live total, red/green, amber "must sum to 100%"). Strongest validation in the app —
      exercise it: add components summing to 99% and 101%, confirm it blocks/ warns.
- [ ] ⚠️ Backend 422s surfaced via first-field error.

### 7.9 Study Levels (`/admin/study-levels`)
- [ ] ✅ Create (code+name, code lowercased) / edit / delete. **A level in use cannot be
      deleted.** Feeds programme types, programmes, fees, regulation binding.

### 7.10 Timetable Manager (`/admin/timetable`)
- [ ] ✅ Create/edit/delete exam timetable entries (module code/name, programme, date, start/
      end time, venue required via HTML5).
- [ ] ⚠️ **No overlap / venue-clash / time-order validation** — set `end_time` before
      `start_time`, or two exams in the same venue at the same time; both are accepted.
      Silent on save failure (no error UI). Probe these.

### 7.11 Attendance Slips Wizard (`/admin/attendance-slips`)
- [ ] ✅ 3-step: programme → modules → generate. Next buttons gate on selection.
- [ ] 🐛 **"Download PDF" is inert** even though the (mock) response returns a
      `document_url`. (§13)
- [ ] ⚠️ Programme with no modules → "No modules found".

---

## 8. RBAC / super_admin surface  🔗 (auth :8001)

### 8.1 User Management (`/admin/users`)
- [ ] ✅ List/search/filter users; create user (name, unique email, password min 8, ≥1
      role, status active/inactive).
- [ ] ✅ Edit user; assign roles via chip toggles (does `PUT /users/{id}` then
      `POST /users/{id}/roles` full-sync).
- [ ] 🐛 **`super_admin`/`admin` are NOT in the assignable role list** — you cannot grant
      the super_admin role through this UI (seed/DB only). Verify the picker's contents. (§13)
- [ ] 🐛 Row "⋯" menu: **"Deactivate" is a no-op** (just closes), **"Manage Roles"
      duplicates Edit**; delete/toggle-status/reset-password/unlock endpoints are unwired. (§13)
- [ ] ⚠️ Status filter offers **"suspended"** — not a valid backend status (enum is
      active|inactive), returns nothing.
- [ ] ⚠️ Create a user with 0 roles → blocked client-side ("At least one role required")
      and server-side (`min:1`).
- [ ] 🔗 Bulk CSV import is always rendered — try a small valid CSV and a malformed one.

### 8.2 Roles & Permissions (`/admin/roles`)  — **super_admin-gated route**
- [ ] ✅ This route is gated to `['admin','super_admin']` — reachable because this account
      has super_admin. Confirm it loads (an account with only registry_admin would be bounced).
- [ ] ✅ Create a **custom** role/permission (slug regex `^[a-z][a-z0-9_.-]*$`, unique).
- [ ] ✅ Assign permissions to a role via checkboxes (`PUT /roles/{id}/permissions`).
- [ ] 🔒 **`is_system` protection:** seeded roles/permissions hide the delete button; try
      to delete one anyway (e.g. via a crafted request) → **422 "System roles/permissions
      cannot be deleted."** System slug is immutable (edit name/desc/permissions only).
- [ ] ⚠️ `window.confirm` before every delete.

### 8.3 Activity Logs (`/admin/activity-logs`)
- [ ] ✅ Audit table with search / action filter / date range / CSV export / detail dialog.
- [ ] 🐛 **Field/meta mismatch:** the table expects `user_name`/`user_email`/`description`
      and `meta.last_page`, but the backend returns raw `AuditLog` models with none of
      those and `meta={page,per_page,total}`. Runtime result: **User/Email/Description
      columns render empty and the pagination control never shows.** CSV export columns
      match the model and **do** work. (§13)
- [ ] ✅ Verify actions you performed above (user_created, roles_assigned, role_created,
      login) actually appear as rows (data is logged even though display columns are thin).

### 8.4 Verify audit coverage 🔗
- [ ] ✅ After §8.1–8.2, export the CSV and confirm your actions were logged
      (`user_created`, `roles_assigned`, `role_created`, `role_permissions_synced`, etc.),
      with old/new value diffs (passwords stripped).

---

## 9. Reports, Settings, Dashboard

### 9.1 Admin Dashboard (`/admin`)
- [ ] ✅ Three stat cards + 30s-refreshing Recent Activity feed.
- [ ] ⚠️ Stats come from the **student** service (`/students/dashboard/stats` +
      applications stats), **not** the auth dashboard endpoints (which exist but are
      orphaned). Empty feed → "No recent activity"; drafts filtered out.

### 9.2 Reports (`/admin/reports`)
- [ ] ✅ Enrollment / Performance / Demographics with year selector + export.
- [ ] ⚠️ Performance/Demographics may be thin/empty — `CURRENT_BLOCKERS.md` flagged the
      student ReportController `performance()`/`demographics()` as incomplete (stale doc,
      re-verify). Expect sparse data on staging.

### 9.3 Settings (`/admin/settings` — `SettingsPage.tsx`)
- [ ] ✅ Tabs: Profile, Security, Preferences, + **System** tab.
- [ ] ✅ System tab shows for this account **because it has `registry_admin`** (the tab is
      gated on `registry_admin`, oddly — a pure admin/super_admin would NOT see it though
      the backend allows them; §13). Edit academic_year / current_semester /
      registration_open / maintenance_mode / system_name / system_email → `PUT
      /auth/system-settings`.
- [ ] ⚠️ Toggle `maintenance_mode` on staging and confirm the intended effect, then toggle back.

### 9.4 Placeholder Settings (`Settings.tsx`, if routed)
- [ ] 🐛 Six cards, **all "Configure" buttons dead** — non-functional placeholder. (§13)

---

## 10. E-Learning admin view  🔗 (`/elearning`)

- [ ] ✅ `/elearning` is reachable — `registry_admin` is in `ELEARNING_ACCESS_ROLES` and is
      mapped to the elearning "admin" view (`App.tsx:165`).
- [ ] ✅ Admin dashboard offers **ERP Sync Status** and **Integrations** (lazy-loaded;
      index redirects to `sync`).
- [ ] 🐛 ⚠️ **Slug mismatch:** `ElearningShell` keys the admin view on `'admin'` /
      `'superadmin'` (no underscore), but the real slug is `super_admin`. This account
      reaches the admin view via the **`registry_admin`→`admin`** mapping; a *pure*
      super_admin (slug `super_admin`) would **not** match `'superadmin'` and would be
      denied. Note which mapping got you in. (§13)

---

## 11. Negative access — must be blocked  🔒

Frontend gates on **role**, and `ProtectedRoute` has no super_admin bypass, so:

- [ ] 🔒 Navigate directly to `/academic` (and `/academic/marks-approval`, `/academic/hod`,
      etc.) → **redirected to `/dashboard`**. This account is not in the `/academic` portal
      roles despite holding academic *permissions* on the backend.
- [ ] 🔒 Navigate to `/hr` → redirected to `/dashboard` (has `hr.read/write` permission but
      no HR portal role).
- [ ] 🔒 Navigate to `/student` → redirected (not a student).
- [ ] 🔒 Confirm no Academic/HR/Student tiles or nav links appear anywhere for this account.
- [ ] ⚠️ **Boundary note (design, not code):** if HR/academic *pages* were ever reached
      (e.g. a mis-gated link), the backend would allow **reads** (has `hr.read`,
      `academics.read`) but block HR *management* (**no `hr.manage`/`payroll.process`** →
      403). Worth a targeted API probe if you want to certify the backend boundary, not
      just the UI.

---

## 12. RBAC token-propagation timing — the silent edge case  🔗

Roles/permissions are **snapshotted into the JWT at issue time**; downstream services read
the claim and do **not** re-check per request.

- [ ] 🔗 Assign a new role to a *test* user, then log in **as that user immediately** in a
      separate browser → they still have the **old** access. Correct behavior.
- [ ] 🔗 Have them `refresh` / re-login (or wait past the **15-min** access-token TTL) →
      new access takes effect. **Always re-issue the token before asserting a permission
      change** — testing immediately shows stale permissions and looks like a bug.
- [ ] ⚠️ There is **no force-revoke on role change** (JTI blacklist only writes on
      logout/refresh). A revoked-but-unexpired token keeps working up to TTL.
- [ ] ⚠️ Revocation is **fail-open**: if Redis is down, blacklist checks return false and
      valid signed tokens are still accepted. Note for a security review.

---

## 13. Known-issues register — expected failures (do NOT file as new bugs)

Anything below is a *pre-existing* gap the maps confirmed in code. A failure that matches
the description is expected; a *different* failure is a new bug.

**Dead / stub UI:**
1. `Admissions.tsx` legacy landing — fully hardcoded mock data, no API. Candidate for removal.
2. Applicant Search — View/Print buttons dead; programme filter no-op; `programme_choice_1` blank.
3. Results Publication — "Download" inert; success is a fake timer.
4. Academic Board Report — "Download" inert.
5. Attendance Slips — "Download PDF" inert (mock returns a `document_url` that's unused).
6. Transcript "Download PDF" = browser `window.print()`, no server PDF.
7. Programme Management — **edit unimplemented** (`console.log`); create success is a `console.log` stub (no refetch/toast).
8. Module Management — create success is a `console.log` stub.
9. Fee Structure — no edit (delete + re-add only).
10. Settings.tsx placeholder — all "Configure" buttons dead.
11. User Management row menu — "Deactivate" no-op; "Manage Roles" duplicates Edit; toggle-status/reset-password/unlock/delete unwired.

**Data/contract mismatches:**
12. Admissions Queue approve/reject conflicts with the backend transition table → 422 for submitted/under_review, error swallowed to console.
13. Activity Logs — table expects `user_name`/`user_email`/`description`/`meta.last_page`; backend returns raw models → empty columns + no pagination (CSV export works).
14. Student List `clearance_status` always "—".
15. Enrol failure shows generic message, not the backend 422 reason.
16. `super_admin`/`admin` not assignable in User Management picker.
17. User Management status filter "suspended" is not a real status.
18. Results Decision Entry "Propose to Board" unmocked in dev/MSW (404); live backend should work.
19. eLearning `ElearningShell` slug mismatch: `'superadmin'`/`'vc'` vs seeded `super_admin`/`vc_office`.
20. AdminRoleGuard defaults exclude `admin`/`super_admin` — a *pure* super_admin gets "Access Denied" on AdminDashboard/Reports/Settings/SettingsPage (this account passes via `registry_admin`). Protection is inconsistent: UserManagement/RoleManagement/ActivityLogs aren't wrapped in the guard at all.
21. SettingsPage System tab gated on `registry_admin` only, not admin/super_admin.

**Deliberately incomplete (by decision):**
22. PG/PhD regulation cohort binding — one binding per intake year governs all levels; PG can resolve to UG rules. "Do not bind 2026-PG until Phase 3." UG binding OK; do not certify PG/PhD. Re-bind cache staleness (≤1h) deferred.
23. Whole downstream lifecycle inert on staging (no payment rail) → results/graduation/supplementary/payments empty by data state.
24. `ResultsService::publishResults` is a documented no-op (two "publish" concepts, one dead).

**Doc drift (trust the code):**
25. `STUDENT_LIFECYCLE_STATUS.md` says confer isn't fee-gated — it now is.
26. `PROCESS_FLOWS.md` / `MARKS_WORKFLOW.md` describe `/registrations` + `/marks` REST shapes that differ from the live `enrollment/*`, `results/*`, `clearance-*` endpoints — narrative, not current API.
27. `SYSTEM_ADMIN_CREDENTIALS.md` references a `system_admin` slug that isn't seeded; all seeded test accounts use password `password`.
28. `CURRENT_BLOCKERS.md` dated May 28 — largely stale.

---

## 14. Sign-off

- [ ] All §3–§10 happy paths pass (excluding §13 known issues).
- [ ] All §11 negative-access checks confirmed blocked.
- [ ] §12 token-propagation behavior understood and verified.
- [ ] No **new** (undescribed) failures found — or all logged separately.
- [ ] Role-design question in §2 (board-level powers on a registry account) escalated for a decision.

Tester: __________  Date: __________  Build/commit: __________
