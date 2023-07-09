# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def after_update_path_for(_resource)
    sign_in_after_change_password? ? user_path(current_user.id) : new_session_path(resource_name)
  end
end
