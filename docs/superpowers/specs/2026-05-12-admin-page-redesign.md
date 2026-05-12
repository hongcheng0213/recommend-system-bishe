# Admin Page Redesign: Full Tutor CRUD + Field Alignment

## Problem

The admin page (`admin.jsp`) only manages the `tutor_ext` table (title, research_achievement, student_quota, hot_score). The `tutors` table (name, gender, university, department, research_fields, quota, photo, homepage_url) has no UI management. Admins must manually INSERT tutor records via SQL.

Additionally, `hot_score` was removed from the recommendation algorithm (commit ca3a9af) but remains in the admin page, model, and DAO — dead code.

## Solution

Rewrite the admin page as a **left-right two-column layout**:

- **Left column (tutors table)**: Select existing tutor to edit OR click "+ Add" to create new. Fields: name, gender, university, department, research_fields, quota, photo URL (with preview), homepage URL.
- **Right column (tutor_ext table)**: Select tutor, edit title, research_achievement, student_quota. Hot_score removed.

Photo and homepage remain URL-based (no file upload). Photo input has a preview area.

## Changes

### 1. admin.jsp — Rewrite
- Two-column layout (Bootstrap `col-md-6` + `col-md-6`)
- Left: "Basic Info" panel — select dropdown + "Add New" button, form fields for all tutors columns, photo preview `<img>`
- Right: "Extended Info" panel — select dropdown, form for title/research_achievement/student_quota
- Remove hot_score field
- Each column has its own form, submits to different actions via `AdminServlet`

### 2. AdminServlet.java — Add tutor CRUD
- `doPost` checks `action` parameter:
  - `saveBasic` — INSERT or UPDATE `tutors` row
  - `saveExt` — INSERT ON DUPLICATE KEY UPDATE `tutor_ext` row (existing logic)
- `saveBasic` logic: if tutorId > 0, UPDATE; else INSERT new tutor
- Remove hotScore parameter handling

### 3. TutorDAO.java — Add insert/update methods
- `insert(Tutor t)` — INSERT INTO tutors
- `update(Tutor t)` — UPDATE tutors SET ... WHERE id = ?

### 4. TutorExt.java — Remove hotScore
- Delete `hotScore` field, getter, setter

### 5. TutorExtDAO.java — Remove hot_score from SQL
- `saveOrUpdate`: remove hot_score from INSERT/UPDATE columns
- `findByTutorId`: remove hot_score from SELECT (or keep in SELECT for backward compatibility, model just won't map it)

### 6. Tutor.java — Remove hotScore
- Delete `hotScore` field, getter, setter

### 7. TutorDAO.java — Remove hot_score from mapRow
- Remove `t.setHotScore(rs.getInt("hot_score"))` from mapRow, and hot_score from SELECT columns

## Photo & Homepage URL

- `photo` field: URL input with a "Preview" button that sets an `<img>` src. On load, existing photo URL shows preview.
- `homepage_url` field: URL input. When viewing, renders as clickable link that opens in new tab.
- No file upload — for a graduation project, linking to university profile photos is sufficient.

## Edge Cases

- **New tutor with blank optional fields**: gender, photo, homepage_url, quota can be null. Form leaves them empty, DAO inserts NULL.
- **Tutor deleted from DB but ext row remains**: LEFT JOIN in findAll handles this. Admin sees the tutor in the basic info panel (since it queries tutors directly), ext panel may have orphan rows — acceptable for now.
- **Duplicate tutor name**: No constraint enforced. Acceptable for graduation project scope.

## Not In Scope

- File upload for photos
- Tutor deletion
- Bulk import
- Validation beyond required fields
