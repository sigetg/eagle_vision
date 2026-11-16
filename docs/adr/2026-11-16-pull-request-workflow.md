# Work ships as small public pull requests, each with a teaching review page

`main` holds the April 2024 app, tagged `v2024`. Every change is a branch and a pull request into `main` on the public `sigetg/eagle_vision` repo, sized to one change a user (or developer) can see, aimed at under about 400 changed lines. Claude writes the code; George reads the review page published for each PR (a file-by-file walkthrough, the Ruby and Rails concepts behind the change with examples, how to check it, and two or three questions), answers the questions, and merges. Each feature starts as a spec in `docs/specs/`.

Tests come first (RSpec, FactoryBot and WebMock, run by GitHub Actions on every PR), then an upgrade from Rails 7.0 and Ruby 3.2 to current Rails 8 and Ruby 3.4, before any new feature, so that the tests prove the upgrade and every later PR teaches current Rails.
