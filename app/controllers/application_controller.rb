class ApplicationController < ActionController::Base
  before_action :require_token

  def generate_token
    SecureRandom.uuid
  end

  protected

    def require_token
      unless session[:session_token].present?
        session[:session_token] = generate_token
      end
    end
end
