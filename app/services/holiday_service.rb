class HolidayService
  def show_holidays(num)
    result = get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")
    result[0...num]
  end

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end