module ApplicationHelper
  def current_authentications
    if current_user
      authentications ||= current_user.authentications
    else
      nil
    end
  end
end
