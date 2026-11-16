# Eagle Vision

Eagle Vision lets Boston College students ask to be let into full course sections, and lets department staff decide on those asks. It is a Rails front end over BC's waitlist API, which owns every course, section and request.

## Language

### People

#### Student
A person whose BC affiliation is Student; they find courses and send waitlist requests.
Where it lives: `users.role` (`student`), decided from the API's person affiliations at sign-in.
_Avoid_: user (too broad), applicant

#### Staff
A department administrator who decides on waitlist requests for courses in their authorized departments.
Where it lives: `users.role` (`staff`, unshipped until the roles PR; today the rolify role `admin`).
_Avoid_: admin (the code's current word, being replaced), faculty

#### Authorized department
A department whose requests a staff member may see and decide on. The API lists them per person; one staff member can have many.
Where it lives: `authorizedDepartments` in the API's `GET /waitlistpersons/:id` response, read in `app/services/api_service.rb`.
_Avoid_: org, unit

### Courses

#### Term
One semester, such as Fall 2023. The API decides which terms are active from the current date.
Where it lives: `activeTerms` in the person response; the chosen one in `session[:term]`.
_Avoid_: semester (fine in speech, but the API and code say term), ATP

#### Course
One course in one term, such as CSCI1101 Computer Science I in Fall 2023.
Where it lives: `app/models/course_offering.rb`, filled from `GET /waitlistcourseofferings`.
_Avoid_: class (ambiguous with a Ruby class), course offering (the API's name; fine in code)

#### Section
One meeting pattern of a course, such as CSCI1101 03, a lecture on Tuesdays and Thursdays at 9:00.
Where it lives: `app/models/activity_offering.rb`, filled from `GET /waitlistactivityofferings`.
_Avoid_: activity offering (the API's name; fine in code), class

#### Sign-up option
A combination of sections a student registers for together, such as lecture 03 plus discussion 07.
Where it lives: `app/models/registration_group.rb`, filled from `GET /waitlistregistrationgroups`.
_Avoid_: registration group (the API's name; fine in code), bundle

#### Seat count
How many seats a section has in total, how many are taken, and how many are open.
Where it lives: `activitySeatCount` (total, used, available) on each section in the API's registration group response; not read by the app yet.
_Avoid_: capacity, enrollment

### Requests

#### Waitlist request
A student's ask to join one or more sections of a course, with their class year, major and reason.
Where it lives: the API's `/waitlistrequests`; mapped in `app/models/registration_request.rb` and `app/models/registration_request_item.rb`. Never stored in our database.
_Avoid_: registration request (the API's name; fine in code), application, ask

#### Request status
Where a waitlist request stands: Waiting, Accepted or Declined. Each maps to one Kuali state key in the API.
Where it lives: `stateKey` on the request; the plain words come from one helper (unshipped). Mapping in `docs/adr/2026-11-16-three-request-statuses.md`.
_Avoid_: submitted, rejected, processed (Kuali and legacy words), state (in UI copy)

#### Decision
A staff member accepting or declining a waitlist request, with an optional message (required when declining).
Where it lives: `RegistrationRequestsController#update` today; a dedicated action after the staff request page PR.
_Avoid_: response (today's field label), approval

#### Withdraw
A student taking back a waiting request; it deletes the request from the API.
Where it lives: `RegistrationRequestsController#destroy`, calling `DELETE /waitlistrequests/:id`.
_Avoid_: cancel, delete (in UI copy)

#### Course watch (unshipped: later phase)
A student's ask to be emailed when a section's open seats reach a threshold.
Where it lives: not built in Rails; the Django app's `CourseListings.Watch` model is the reference.
_Avoid_: alert, subscription

## Relationships

- A **Student** sends many **Waitlist requests**; each one is for one **Course** and names one or more **Sections**
- A **Waitlist request** belongs to the **Authorized department** of its **Course**
- A **Staff** member decides on **Waitlist requests** only within their **Authorized departments**
- A **Sign-up option** groups one or more **Sections** of one **Course**; each **Section** has one **Seat count**

## Example dialogue

> **Dev:** "When a **Student** sends a **Waitlist request** for a **Section** with open seats, do we stop them?"
> **Staff:** "No. Warn them the **Seat count** says seats are open and point them to EagleApps, but let them send it; the count can be a day stale."
> **Dev:** "And once I **Decline** it, can they edit it?"
> **Staff:** "No. Only a Waiting request can be edited or withdrawn. If I made a mistake I reopen it."

## Flagged ambiguities

- The code says **admin** for what the product calls **Staff**. Resolved: Staff in all UI copy and new code; the rolify `admin` role is replaced by `users.role = staff` in the roles PR.
- The API's **Rejected** state (`kuali.courseregistration.request.state.discarded`) is shown as **Declined**. Resolved in `docs/adr/2026-11-16-three-request-statuses.md`.
- The README says data comes from "the EagleApps API"; the code calls BC's separate Spring waitlist service at `/waitlist`. Resolved: this document and the ADRs say **waitlist API**.
