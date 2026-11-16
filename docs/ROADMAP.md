# Roadmap

Phase 1 makes Eagle Vision a working two-sided app: students find courses and send waitlist requests, staff decide on them, and students hear back. Each PR below gets a spec in `docs/specs/` and a review page before it merges. Order and scope come from round 1 of the rebuild decisions (see `docs/DECISIONS.md`).

## Phase 1

| PR | What it does |
|---|---|
| 1 | Tag `v2024`; rewrite the README and local setup; replace the dead 2023 tests with RSpec, FactoryBot and WebMock; test today's behaviour; GitHub Actions CI |
| 2 | Upgrade Rails 7.0 to 8.x and Ruby 3.2 to 3.4, one Rails minor version per commit |
| 3 | Role enum replacing rolify, re-checked at every sign-in; Pundit policies on every action (closes the "any student can open any request" hole) |
| 4 | New layout, design tokens and per-role navigation; each role lands on its own home page |
| 5 | Staff request queue: counts, filters (status, department, course), sorting |
| 6 | Staff request page: Accept, Decline with message, Reopen; the state rules |
| 7 | Decision emails to students (Action Mailer; `letter_opener` in development) |
| 8 | Course search filters (department, level, days, time of day, professor, open seats) and seat counts on sections |
| 9 | The new request form (class year, major, sections, reason), answers stored as JSON |
| 10 | My requests: grouped by status, edit and withdraw while waiting |

## Later

Ranked once phase 1 ships.

- Course watches with seat-alert emails (background job with Solid Queue, Action Mailer)
- Bulk accept and decline for staff
- A by-student view for staff
- Reports for staff
- An open/closed switch for the request period
- Use the API's `currentDate` setting instead of a faked container clock
