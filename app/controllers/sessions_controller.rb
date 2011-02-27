class SessionsController < Devise::SessionsController
  skip_authorization_check
  layout "dashboard"
end