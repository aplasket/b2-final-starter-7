require "httparty"
require "json"
require "./app/services/holiday_service"
require "./app/poros/holiday"

class HolidaySearch
  def new_holiday(num)
    service.show_holidays(num).map do |holiday_data|
      Holiday.new(holiday_data)
    end
  end

  def service
    HolidayService.new
  end
end