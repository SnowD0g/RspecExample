class Task < ApplicationRecord
  belongs_to :project

  def mark_completion(date = nil)
    self.completed_at = date || Time.current
  end

  def completed?
    completed_at.present?
  end

  def part_of_velocity?
    return false unless completed?
    recent_completion?
  end

  def points_toward_velocity
    part_of_velocity? ? size : 0
  end

  private
  
  def recent_completion?
    completed_at > Project.velocity_length_in_days.days.ago
  end
end
