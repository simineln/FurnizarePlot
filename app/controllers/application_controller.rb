class ApplicationController < ActionController::Base
  before_action :nav, :meter_init

  def nav
    @ids = []
    @operators_nav = Operator.all
    meters_id = Meter.distinct.pluck(:company_id)
    @companies_nav = Company.where(id: meters_id)
  end


  def meter_init
    lib_directory = 'lib/2020/'

    readings = Reading.all
    processed_dates = []
    readings.each do |readings|
      year = readings.date.year.to_s
      month = readings.date.month.to_s
      day = readings.date.day.to_s
      processed_dates.append("#{day}/#{month}/2020")
    end

    months = Dir.glob("#{lib_directory}*/").sort
    months.each do |month|
      days = Dir.glob("#{month}*/").sort
      days.each do |day|
        current_date = "#{day.split('/')[-1].to_i}/#{month.split('/')[-1].to_i}/2020"

        next if processed_dates.include? current_date

        profiles = Dir.glob("#{day}*.xls")
        profiles.each do |profile|
          xls = Roo::Spreadsheet.open(profile)

          date = xls.sheet('Report').row(6)[2]
          meter_num = xls.sheet('Report').row(9)[2].to_i
          @meter = Meter.where(number: meter_num)[0]

          # Storing hourly consumption
          # Extracting columns with data
          date_col = xls.sheet('Report').column(2)
          aec_p_col = xls.sheet('Report').column(7)
          aec_m_col = xls.sheet('Report').column(8)
          rec_p_col = xls.sheet('Report').column(9)
          rec_m_col = xls.sheet('Report').column(10)

          rows = ([13] + (16..108).step(4).to_a).each_cons(2).to_a # row numbers 13..16..108 splitting by pairs

          rows.each do |row|
            date = date_col[row[1] - 1]
            aec_p = ((aec_p_col[row[1] - 1] - aec_p_col[row[0] - 1]) * @meter.kt).round(4)
            aec_m = ((aec_m_col[row[1] - 1] - aec_m_col[row[0] - 1]) * @meter.kt).round(4)
            rec_p = ((rec_p_col[row[1] - 1] - rec_p_col[row[0] - 1]) * @meter.kt).round(4)
            rec_m = ((rec_m_col[row[1] - 1] - rec_m_col[row[0] - 1]) * @meter.kt).round(4)

            readings = Reading.new(meter_id: @meter.id, date: date, aec_p: aec_p, aec_m: aec_m, rec_p: rec_p, rec_m: rec_m)
            readings.save
          end
        end
      end
    end
  end
end
