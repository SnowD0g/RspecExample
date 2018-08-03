class Task
  attr_reader :size

  def initialize(options = {})
    mark_completion(options[:completed_at]) if options[:completed_at]
    @size = options[:size]
  end

  def mark_completion(date = nil)
    @completed_at = date || Time.current
  end

  def completed?
    @completed_at.present?
  end

  def part_of_velocity?
    return false unless completed?
    @completed_at > Project.velocity_length_in_days.days.ago
  end

  def points_toward_velocity
    part_of_velocity? ? size : 0
  end
end
