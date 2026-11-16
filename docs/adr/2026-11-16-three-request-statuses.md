# Requests show three statuses, mapped onto three Kuali state keys

The API stores a request's status as one of seven Kuali state keys. The app uses three, shown everywhere as plain words through one helper:

| Shown as | Kuali state key |
|---|---|
| Waiting | `kuali.courseregistration.request.state.submitted` |
| Accepted | `kuali.courseregistration.request.state.processed.success` |
| Declined | `kuali.courseregistration.request.state.discarded` |

Staff may move Waiting to Accepted or Declined, and Reopen a decided request back to Waiting; no other moves are allowed, and one small state-rules object enforces that. A student **withdraws** a waiting request by deleting it (`DELETE /waitlistrequests/:id`) rather than borrowing a Kuali state for "withdrawn by student", which the API has no clear key for. The Django app's five local states (submitted, hold, waitlist, approved, withdrawn) were never sent to BC and are not carried over.
