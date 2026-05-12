# Tutor Search on Rating Page

## Problem

The "意向导师" page (`tutors.jsp`) lists all tutors in a flat table. With 100+ tutors, students must scroll through everything to find tutors they want to rate.

## Solution

Add a real-time client-side search box above the tutor table. JavaScript filters and reorders table rows without page reload.

## Design

### Search box
- Positioned above the table, inside the form
- Placeholder: "搜索导师（姓名/院校/院系/研究方向）"
- Input event triggers `filterTutors()` immediately

### Filter logic (JavaScript)
- For each table row, check if any cell text (name, university, department, research_fields) contains the keyword (case-insensitive)
- Matching rows: keep visible, move to top of `<tbody>`
- Non-matching rows: keep visible, stay below matching rows
- Empty keyword: restore original order
- Optional: highlight matched text (bold or background color)

### Files changed
- `tutors.jsp` — add search input + JavaScript filter function (all client-side, ~30 lines)

### Not in scope
- Server-side search endpoint
- Pagination
- Fuzzy/semantic search
