# Eagle Vision

Eagle Vision lets Boston College students ask to be let into full course sections, and lets department staff accept or decline those asks.

It is a Rails front end over BC's **waitlist API**, a separate Spring service that owns every course, section and waitlist request. Eagle Vision's own database holds only user accounts. See [`CONTEXT.md`](CONTEXT.md) for the product's vocabulary and [`docs/adr/`](docs/adr/) for the decisions behind it.

This app was built in 2023 to 2024 and is being rebuilt in public, one pull request at a time. The 2024 version is tagged [`v2024`](https://github.com/sigetg/eagle_vision/tree/v2024), and the plan is in [`docs/ROADMAP.md`](docs/ROADMAP.md).

## Stack

- Rails 7.0 on Ruby 3.2 (the upgrade to Rails 8 and Ruby 3.4 is the next PR)
- Postgres for user accounts
- Devise for sign-in, with optional Google sign-in
- HTTParty for calls to the waitlist API, all in `app/services/api_service.rb`
- Server-rendered ERB views with Turbo and Stimulus
- RSpec, FactoryBot and WebMock for tests

## Running it locally

You need three things running: Postgres, BC's waitlist API, and the Rails app.

### 1. Ruby and Postgres

Install Ruby 3.2.2 (the repo's `.ruby-version`; [mise](https://mise.jdx.dev) or rbenv will pick it up) and Postgres. The app connects to Postgres as your local user. To use something else, set `DATABASE_URL`, for example `DATABASE_URL=postgres://me:secret@localhost:5432`.

```sh
bundle install
bin/rails db:prepare
```

### 2. BC's waitlist API

The API is a Java service distributed as a jar with recorded Fall 2023 data. It isn't in this repo, because the data describes real (masked) people; you need access to BC's private copy. Build it into a Docker image called `waitlistapp` as its own README describes.

The API decides which terms are "active" from today's date, and its data only covers Fall 2023. Run it with its clock set to 16 October 2023, using this Dockerfile:

```dockerfile
FROM waitlistapp
RUN apk --no-cache add libfaketime
ENV LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1 \
    FAKETIME="@2023-10-16 09:00:00" \
    FAKETIME_DONT_FAKE_MONOTONIC=1
```

```sh
docker build -f Dockerfile.oct2023 -t waitlistapp-oct2023 .
docker run --rm -d --name waitlistapp -p 8080:8080 waitlistapp-oct2023
```

The app expects the API at `http://127.0.0.1:8080/waitlist`. Set `WAITLIST_API_URL` to point it somewhere else.

### 3. The app

```sh
bin/rails server
```

Open http://localhost:3000 and create an account. The part of your email before the `@` must be a person id the API knows:

| Role | Email | Notes |
|---|---|---|
| Student | `90000001@bc.edu` | Any id from 90000001 to 90000104 is a student |
| Staff | `90000000@bc.edu` | Staff for 50 departments |

Choose any password; accounts live only in your local database.

If the API isn't running, pages say "The course system isn't responding" instead of crashing.

## Tests and checks

```sh
bin/rspec       # the test suite; never calls the real API
bin/rubocop     # code style (Rails' omakase rules)
bin/brakeman    # security scan
```

Tests stub the waitlist API with WebMock, using made-up responses in `spec/fixtures/waitlist_api/`. The helpers live in `spec/support/waitlist_api.rb`. GitHub Actions runs all three checks on every pull request.

## How work happens

Every change is a pull request into `main`. Each starts as a spec in [`docs/specs/`](docs/specs/), and each code PR has a review page that walks through the change. See [`docs/adr/2026-11-16-pull-request-workflow.md`](docs/adr/2026-11-16-pull-request-workflow.md).
