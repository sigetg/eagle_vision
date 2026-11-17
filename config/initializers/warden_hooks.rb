# Re-check the user's role against the waitlist API every time they sign in,
# so a change at BC (a student who becomes staff, or the reverse) reaches the
# app on their next sign-in, not only at sign-up. If the API is down, the
# user keeps the role they had; the page they land on will say the API is down.
Warden::Manager.after_authentication do |user, _auth, _opts|
  next unless user.respond_to?(:sync_role!)

  begin
    user.sync_role!
  rescue ApiService::Error
    nil
  end
end
