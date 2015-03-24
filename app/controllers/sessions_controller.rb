class SessionsController < ApplicationController
  def new
  end

  def create
    user = find_or_build_user

    if user.persisted? && user.authorized_member?(auth_hash)
      if user.require_launch_pass?(auth_hash)
        flash[:alert] = "Please sign in with Launch Pass"
        redirect_to new_session_path
        return
      else
        session[:user_id] = user.id
        flash[:success] ||= "Successfully signed in as #{user.username}."
        redirect_to_back_or_root
      end
    else
      error_message = nil
      if user.email.nil?
        # This is a common issue with GitHub OAuth so include a custom message
        # if a user cannot sign up because their e-mail is missing.
        error_message = "No public e-mail associated with GitHub account."
      end

      if error_message.nil?
        failure
      else
        flash[:alert] = error_message
        redirect_to_back_or_root
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "Signed out successfully."
    redirect_to root_path
  end

  def failure
    flash[:alert] = "Unable to sign in."
    redirect_to_back_or_root
  end

  private
  def find_or_build_user
    if current_user.guest?
      identity = Identity.find_or_create_from_omniauth(auth_hash)
      identity.user
    else
      current_user.identities.find_or_create_by!(
        provider: auth_hash['provider'],
        uid: auth_hash['uid']
      )
      flash[:success] = "Thanks! " +
        "Please sign in with Launch Pass moving forward!"

      current_user
    end
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  def omniauth_token
    auth_hash["credentials"]["token"]
  end
end
