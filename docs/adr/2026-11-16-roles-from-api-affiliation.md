# Roles come from the API's affiliations and are stored as one enum column

A user is **staff** if the waitlist API lists a Staff affiliation for them, otherwise **student**. The role is re-checked at every sign-in, not only at sign-up, so a change at BC reaches the app on the next sign-in. It is stored as `users.role`, a Rails enum (`student: 0, staff: 1`), replacing the rolify gem and its two tables, which were built for many roles per user and were assigning each role twice.

Staff get a separate app (a request queue, not a student's search-and-request flow) and never submit requests. Staff see and decide only on requests for courses in their authorized departments, everywhere in the app.

## Considered Options

- Keep rolify and fix the duplicate: less change, but a two-table design for a single value.
- A deployment-wide admin flag, as the Django app used (`ADMIN_USER`): it made everyone an admin on a staff deployment and ignored departments.
