Warden::Manager.after_authentication do |user, auth, opts|
  if user.present? and auth.raw_session[:session_token].present?
    Playing.associate_by_session_token(auth.raw_session[:session_token], user)
  end
end
