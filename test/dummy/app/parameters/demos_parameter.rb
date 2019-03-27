# frozen_string_literal: true

class DemosParameter < Rparam::Parameter

  def show
    param :date, type: Date, save: :relative_date, default: 1.days.ago
    param :month, save: :relative_month, default: Time.zone.today
    param :integer, type: Integer, save: true, min: 1, max: 10
    param :checkbox, type: Array, save: true, exclusion: '', default: %w(value1)
  end

end
