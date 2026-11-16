# PR 1: Foundation

## Problem

The app has no working tests: all 49 are 2023 scaffolds for tables that no longer exist. It has no CI. Its README doesn't say how to run it. `config/database.yml` holds a personal username and password. When BC's waitlist API is down, every page shows a Rails error. Nothing later in the roadmap is safe to change until tests describe how the app behaves today.

## Who it's for

Developers: George, and anyone who clones the repo.

## Scenarios

| # | Situation | Expected result |
|---|---|---|
| 1 | Run `bin/rspec` on a fresh clone, with no API container running | Every spec passes. No spec makes a real HTTP call (WebMock blocks them) |
| 2 | `ApiService` fetches a person by id | It sends `GET /waitlist/waitlistpersons/:id` and returns a `Person` plus the active `Term` list mapped from the response |
| 3 | `ApiService` fetches a person who doesn't exist | It raises `ApiService::NotFound` |
| 4 | Any `ApiService` call when the API refuses the connection or takes over 5 seconds | It raises `ApiService::Unavailable` |
| 5 | Each of the other 12 `ApiService` calls | It sends the right method, path and parameters, and maps the response into the right model objects |
| 6 | A student signs up with `90000001@bc.edu` | The user is saved with `person_id` 90000001 and the `user` role |
| 7 | A staff member signs up with `90000000@bc.edu` | The user is saved with the `admin` role |
| 8 | A signed-in student opens `/` or searches for `CSCI` | The page lists the courses from the stubbed API for the session's term |
| 9 | A student submits a waitlist request | `ApiService` makes three calls in order (create, update with the answers, change state to submitted), and the student lands on the request list |
| 10 | Staff open the request list | It shows requests from each authorized department |
| 11 | Staff accept a request with a message | The request is updated with the message, and its state changes to processed.success |
| 12 | A student deletes their own request | `DELETE /waitlistrequests/:id` is sent |
| 13 | A student opens another student's request by URL | **Pending:** should be refused. Today it isn't; PR 3 makes this pass |
| 14 | Staff open a course's requests page (`/course_offering_requests/:id`) | **Pending until George's fix:** the page loads (today it crashes on `@terms`) |
| 15 | Any page loads while the API is down | A "The course system isn't responding" page with status 503 |
| 16 | A request page for an id the API doesn't know | A 404 page |
| 17 | A PR is opened | GitHub Actions runs RSpec, RuboCop and Brakeman, and all three pass |
| 18 | Someone follows the README on a fresh machine with the API container | They reach the app at `localhost:3000` and can sign in with the test logins |

## What changes

- **Removed:** `test/` (Minitest scaffolds).
- **Added:**
  - `spec/` with RSpec, FactoryBot and WebMock
  - `spec/fixtures/waitlist_api/*.json` (made-up values)
  - a `stub_waitlist_api` helper
- **`ApiService`:**
  - a 5-second timeout
  - `Unavailable` and `NotFound` errors in place of `DoesNotExistException`, kept as an alias for code that rescues it
  - `get_waitlist_request` checks the response code
- **`ApplicationController`:** `rescue_from` for both errors, with `errors/unavailable` and `errors/not_found` views.
- **Tooling:**
  - `.github/workflows/ci.yml`
  - `bin/rspec`, `bin/rubocop`, `bin/brakeman`
  - `.rubocop.yml` inheriting `rubocop-rails-omakase`
  - one autocorrect commit of its own
- **`config/database.yml`:** no username or password, so it uses the local user (or `DATABASE_URL`).
- **`Gemfile.lock`:** adds the `x86_64-linux` platform.
- **`README.md`:** rewritten.

## Out of scope

- Fixing the security hole (PR 3); scenario 13 stays pending.
- Any change to what users see, apart from the two error pages.
- Upgrading Rails (PR 2).
- The course-requests crash, which is George's change in this PR (scenario 14). I write the pending spec, and George removes the pending mark and fixes it.
