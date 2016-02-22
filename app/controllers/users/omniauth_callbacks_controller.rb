class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    if user_signed_in?
      flash[:info] = "Your account has successfully been connected with your Google account."
      current_user.add_provider(request.env['omniauth.auth'])
      current_user.save!
      redirect_to edit_user_registration_path
    elsif @user = User.from_omniauth(request.env['omniauth.auth'])
      flash[:notice] = I18n.t :'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:warning] = "User not found, please register."
      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_path
    end
  end
end
