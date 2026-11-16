# Decisions

Every decision taken on the rebuild decision pages, with George's mark. The pages are the full record of the reasoning; this file keeps the outcome in the repo. Lasting technical decisions also have an ADR in `docs/adr/`.

## Round 1 (2026-11-16)

All 31 items were marked Looks right.


### How we work

| ID | Decision | Choice |
|---|---|---|
| W1 | Work happens in pull requests on the public eagle_vision repo; main keeps the 2024 version, tagged v2024 | Public PRs on eagle_vision (recommended) |
| W2 | Every PR gets a review page that teaches the change | Review page plus PR description (recommended) |
| W3 | Claude writes the code; George reviews, answers the questions and merges | Claude writes, George reviews and merges (recommended) |
| W4 | One slice a user can see per PR, small enough to review in one sitting |  |
| W5 | Each feature starts as a short spec in docs/specs/; decisions go on decision pages | Specs in the repo (recommended) |
| W6 | Tests come first: RSpec with stubbed API calls, run on every PR | RSpec + WebMock (recommended) |
| W7 | Upgrade to current Rails and Ruby once tests exist, before new features | Upgrade second (recommended) |
| W8 | BC's API runs locally in Docker, and its data never enters the repo |  |

### Who uses the app

| ID | Decision | Choice |
|---|---|---|
| R1 | There are two roles, student and staff, and the waitlist API decides which, re-checked at every sign-in |  |
| R2 | The role is a single enum column on users, replacing rolify | Enum column (recommended) |
| R3 | Staff don't submit requests; they get their own app | Separate staff app (recommended) |
| R4 | Staff see only requests for courses in their authorized departments, everywhere |  |
| R5 | Every action checks who you are and whether the record is yours | Pundit policies (recommended) |

### What a student does

| ID | Decision | Choice |
|---|---|---|
| S1 | Search courses with filters, including "has open seats" | Django's full set (adds professor and time of day) |
| S2 | A course page lists its sections with times, rooms, instructors and seats |  |
| S3 | Requesting a section that still has seats warns, but doesn't stop you | Warn, still allow (recommended) |
| S4 | The request form asks for class year (dropdown), major, sections and reason | Year, major, sections, reason (recommended) |
| S5 | "My requests" shows status, the staff message, and what you can still do; decided requests are read-only |  |
| S6 | Withdrawing deletes the request from the API | Withdraw deletes it (recommended) |
| S7 | Course watches with seat-alert emails come in a later phase | Later phase (recommended) |

### What staff do

| ID | Decision | Choice |
|---|---|---|
| A1 | Staff land on a request queue for their departments |  |
| A2 | Staff decide on a request page: Accept or Decline, with a message to the student (required to decline) |  |
| A3 | A decided request can be reopened | Allow Reopen (recommended) |
| A4 | Staff can see requests by course |  |
| A5 | Students get an email when staff decide | Phase 1 (recommended) |
| A6 | Bulk decisions, by-student view, reports and an open/closed switch wait for later |  |

### How it looks

| ID | Decision | Choice |
|---|---|---|
| U1 | Each role gets its own navigation and home page |  |
| U2 | A clean restyle in BC maroon and gold | Plain CSS with tokens (recommended) |
| U3 | Status is always a coloured badge with a plain word, never a Kuali key |  |
| U4 | The app stays server-rendered, with Turbo and no React | ERB, Turbo and Stimulus (recommended) |

### Order of work

| ID | Decision | Choice |
|---|---|---|
| O1 | Phase 1 runs foundation, roles, staff side, then student side (see ROADMAP.md) | Staff side before student side (recommended) |
