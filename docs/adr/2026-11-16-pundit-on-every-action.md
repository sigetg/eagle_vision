# Every controller action is authorized by a Pundit policy

Each resource gets a Pundit policy, and every controller action calls `authorize`; a spec fails if a new action skips it. A student may view, edit and withdraw only their own waitlist requests; staff may view and decide only within their authorized departments. This closes a hole in the 2024 code, where `show`, `edit`, `update` and `destroy` loaded any request id without checking who asked. Checks scattered through controllers were rejected because they are easy to forget on the next action.
