# frozen_string_literal: true

class DemosParameter < Rparam::Parameter

  def index
    param :from_date, type: Date, save: { relative_by: Time.zone.today }
    param :to_date, type: Date, save: { relative_by: Time.zone.today }
  end

end
