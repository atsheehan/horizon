module DashboardHelper
  def assignment_state(assignment, user)
    if assignment.submitted?(user)
      "submitted-assignment"
    elsif assignment.late?
      "late-assignment"
    else
      "todo-assignment"
    end
  end
end
