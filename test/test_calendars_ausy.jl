# Test Sydney calendars
# http://www.industrialrelations.nsw.gov.au/oirwww/NSW_public_holidays/NSW_Public_Holidays_2013-2015.page

ausyholidays = [Date(2014, 1, 1), Date(2014, 1, 27), Date(2014, 4, 18),
Date(2014, 4, 19), Date(2014, 4, 20), Date(2014, 4, 21), Date(2014, 4, 25),
Date(2014, 6, 9), Date(2014, 8, 4), Date(2014, 10, 6), Date(2014, 12, 25),
Date(2014, 12, 26), Date(2016, 1, 1), Date(2016, 1, 26), Date(2016, 3, 25),
Date(2016, 3, 26), Date(2016, 3, 27), Date(2016, 3, 28), Date(2016, 4, 25),
Date(2016, 6, 13), Date(2016, 8, 1), Date(2016, 10, 3), Date(2016, 12, 25),
Date(2016, 12, 27), Date(2016, 12, 26)]

for day in 0:364
    dt = Date(2014,1,1) + Dates.Day(day)
    @test !((dt in ausyholidays || isweekend(dt)) $
        !isgood(dt, AUSYFCalendar()))
    dt += Day(1)
end

for day in 0:364
    dt = Date(2016,1,1) + day
    @test !((dt in ausyholidays || isweekend(dt)) $
        !isgood(dt, AUSYFCalendar()))
    dt += Day(1)
end

