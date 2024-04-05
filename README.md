# EagleVision

A rails app to allow BC students to submit waitlist requests for desired classes

* Collects Boston College course and registration data from the EagleApps API (not included in this repo sadly) and allows users to search through it to find a section to submit a waitlist request for.

* Persists very little data in the database, as all data apart from user data is pulled from and posted to the EagleApps API.

* Uses the ruby gems devise, omniauth (google oauth), httparty, and rolify.

* Built with rails 7.0.7 and ruby 3.2.2
