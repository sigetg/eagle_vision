# Screens

The target design for every screen in phase 1, from round 2 of the rebuild decisions (items L1 to Q4 and E1 in `docs/DECISIONS.md`). Each feature PR builds its screens to this spec and links back to the item IDs. The mockups on the decision page are the visual reference; this file is the written one.

## Both roles

### Top bar (L1, U1)
- Left: the EagleVision name, then the role's links.
  - Student: **Find courses**, **My requests**.
  - Staff: **Requests** (with a badge counting waiting requests), **Courses**.
- Right: a term picker that switches on change, then the user's name and **Sign out**.
- One term partial and one route replace `terms/_terms_dropdown.html.erb`, `terms/_terms_dropdown_reg_requests.html.erb` and their two routes.
- On a phone the links collapse into a menu button.
- After sign-in, a student lands on Find courses and staff land on Requests.

### Sign-in (L2)
- One centered card: "Sign in with your BC email", email, password, **Sign in**, and a "Create an account" link.
- The form renders once.
- The Google button appears only when `GOOGLE_OAUTH_CLIENT_ID` is set.

### When the API fails (L3)
- If the waitlist API refuses the connection or takes more than 5 seconds, the page says: "The course system isn't responding. Try again in a minute." It has a **Try again** button and returns status 503.
- An unknown request or course returns a 404 page.
- `ApiService` raises `ApiService::Unavailable` and `ApiService::NotFound`, and `ApplicationController` handles them with `rescue_from`.

### Status badges (U3)
- Waiting (amber), Accepted (green), Declined (maroon).
- The words come from one helper.
- Kuali keys are never shown.

## Student

### Find courses (P1, S1)
- **Filters**, in a left column (a Filters button on a phone): department, level (1000 to 4000), days (M Tu W Th F), time of day (before 10, 10 to 12, 12 to 2, 2 to 6, after 6), professor, and **Has open seats**.
- Filters apply on change through a Turbo Frame and live in the URL query string.
- **Results:** a search box by code or title above the results, with a result count. Cards show code and title, credits, a two-line description (HTML stripped), and a seats summary ("Open in 12 of 22" or "Full").
- 20 per page.

### Course page (P2, S2)
- **Header:** code, title, credits, grading options, term, and the description sanitized of BC's inline styles.
- **Table:** one row per section combination, with grading variants merged.
  - Columns: sections (lecture plus discussion or lab), when and where, instructor, and a seats bar per section ("46 / 59").
  - Each row has a Full or Open badge and **Request a spot**. On an open row the button is secondary.
- **Staff view (Q3):** the same page without Request buttons, plus a **Requests** section below. It lists every request for the course, oldest first, with student, sections, status and sent date, and each row links to the request.

### Request form (P3, S3, S4)
- Its own page at `/courses/:course_id/requests/new?group=...`.
- A summary box of the chosen sections with seats.
- If any chosen section has open seats, a green notice: "Seats are open in this section. You can register in EagleApps now. Send a request only if EagleApps won't let you in." The form stays usable.
- Fields:
  - class year (First year, Sophomore, Junior, Senior, Graduate)
  - major
  - grading (only if the course offers more than one option)
  - the section combinations the student would accept (checkboxes, with the chosen one pre-checked)
  - reason (required, at most 1,000 characters, with a live counter)
- On submit, the student lands on My requests with "Request sent".

### My requests (P4, S5, S6)
- Three groups, each with a count: Waiting, Accepted, Declined.
- Each card shows the course, the sections, the sent date and a badge.
- Waiting cards have **Edit** and **Withdraw**. Withdraw asks inline, "Withdraw this request? Staff will no longer see it.", with **Withdraw** and **Keep it**.
- Decided cards show the staff message and no actions.

## Staff

### Request queue (Q1, A1)
- Count tiles for Waiting, Accepted and Declined, which also filter.
- Filter chips for department and course, and a search by student name.
- Table columns: student, course and sections, seats open now, sent, status.
- Oldest first by default, 25 per page.
- Clicking a row opens the request.

### Request page (Q2, A2, A3)
- **Left:** the student's name, class year and major; the wanted sections with live seats; other acceptable combinations; grading; reason; sent date; and a link reading "N other requests for COURSE".
- **Right:** a sticky decision panel with **Accept** and **Decline** and a message box. The message is required to decline and optional to accept.
- After a decision, the panel shows the status, who decided and when, the message, and **Reopen**. It updates in place through a Turbo Frame.

### Courses (Q4)
- Find courses limited to the staff member's authorized departments.
- Each card shows "N waiting".
- An extra filter: **Has waiting requests**.
- Counts are measured in PR 5 and cached for a minute if they're slow.

## Email

### Decision email (E1, A5)
- **Subject:** "Your waitlist request for CSCI1101 was accepted" (or declined, or reopened).
- **Body:** a greeting, the course and sections, the decision, the staff message if any, a **View my requests** button, and a footer naming the department, saying the inbox isn't read.
- Sent with `deliver_later`. In development it opens with `letter_opener`.
