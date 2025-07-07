class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

before_action :set_devise_redirect

# Fix nicer CanCan exceptions
rescue_from CanCan::AccessDenied do |exception|
  flash[:alert] = "Access denied!"
  redirect_to root_url
end

# Change layout for devise views
#layout Proc.new { |controller| controller.devise_controller? ? 'devise' : 'application' }

def set_devise_redirect
  if controller_path == "devise/registrations"
    session["user_return_to"] = "/users/edit"
  elsif controller_path != "users/omniauth_callbacks"
    session["user_return_to"] = "/dashboard"
  end
end
end
