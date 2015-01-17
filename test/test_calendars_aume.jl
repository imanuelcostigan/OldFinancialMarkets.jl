# Test Melbourne calendars
# http://www.business.vic.gov.au/victorian-public-holidays-and-daylight-saving/victorian-public-holidays

aumeholidays = [Date(2014, 1, 1), Date(2014, 1, 27), Date(2014, 3, 10),
Date(2014, 4, 18), Date(2014, 4, 19), Date(2014, 4, 21), Date(2014, 4, 25),
Date(2014, 6, 9), Date(2014, 11, 4), Date(2014, 12, 25), Date(2014, 12, 26),
Date(2015, 1, 1), Date(2015, 1, 26), Date(2015, 3, 9), Date(2015, 4, 3),
Date(2015, 4, 4), Date(2015, 4, 6), Date(2015, 4, 25), Date(2015, 6, 8),
Date(2015, 11, 3), Date(2015, 12, 25), Date(2015, 12, 26), Date(2015, 12, 28)]
dt = Date(2014)
while year(dt) <= 2015
    @test !((dt in aumeholidays || isweekend(dt)) $
        !isgood(dt, AUMECalendar()))
    dt += Day(1)
end
