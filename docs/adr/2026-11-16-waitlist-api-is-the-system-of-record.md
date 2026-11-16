# BC's waitlist API is the system of record; our database holds only accounts

Courses, sections, seat counts and waitlist requests live in BC's waitlist API (a Spring service at `/waitlist`). Eagle Vision reads and writes them over HTTP through `ApiService` and keeps only user accounts in Postgres. The Django version copied courses and requests into its own database and never sent requests to BC, so staff decisions there never reached the registrar's data; we keep the API as the single source of truth instead.

For local development the API runs as a Docker container built from the jar in BC's private `normanjwright/eaglevision` repo, with its clock set to 16 October 2023 so its recorded Fall 2023 data is "current". The jar and its JSON data are never copied into this repo, because the data describes real (masked) people. Tests stub the API with WebMock using hand-written, made-up responses.
