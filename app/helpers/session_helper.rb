module SessionHelper
  def user_signed_in?
    !current_user.guest?
  end

  def current_user
    @current_user ||= User.build_for_views(session[:user_id])
  end

  def set_current_user(user)
    @current_user = user
  end
end
