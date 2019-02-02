# Test GBP calendars
# Source:
# http://www.timeanddate.com/calendar/?year=2012&country=9
# http://www.timeanddate.com/calendar/?year=2013&country=9
gbholidays = [Date(2012, 1, 1), Date(2012, 1, 2), Date(2012, 4, 6),
  Date(2012, 4, 9), Date(2012, 5, 7), Date(2012, 6, 4), Date(2012, 6, 5),
  Date(2012, 8, 27), Date(2012, 12, 25), Date(2012, 12, 26),
  Date(2013, 1, 1), Date(2013, 3, 29), Date(2013, 4, 1),
  Date(2013, 5, 6), Date(2013, 5, 27), Date(2013, 8, 26),
  Date(2013, 12, 25), Date(2013, 12, 26)]

for dt in Date(2012,1,1):Dates.Day(1):Date(2013,12,31)
    @test !((dt in gbholidays || isweekend(dt)) ⊻ !isgood(dt, GBLOFCalendar()))
end