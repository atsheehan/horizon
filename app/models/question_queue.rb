class QuestionQueue < ActiveRecord::Base
  belongs_to :user

  after_create :set_sort_order

  scope :for_team,
    ->(team) { where(team: team).where.not(status: 'done').sort_by { |qq| qq.sort_order } }

  def set_sort_order
    value = QuestionQueue.maximum(:sort_order) + 1
    self.sort_order = value
    self.save!
  end

  def update_in_queue(update_status, user)
    update_attributes(user: user)
    if update_status == 'no-show' && no_show_counter == 2
      update_attributes(status: 'done')
    elsif update_status == 'no-show' && no_show_counter < 2
      update_attributes(no_show_counter: no_show_counter + 1)
      set_sort_order
    else
      update_attributes(status: update_status)
    end
  end

  def status_text
    if status == 'open'
      "Queued"
    elsif status == 'in-progress'
      "Assigned to #{user.name}"
    elsif status == 'done'
      "Done"
    end
  end
end
