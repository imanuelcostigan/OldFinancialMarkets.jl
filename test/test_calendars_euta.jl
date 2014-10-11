# Test GBP calendars
# Source:
# Source:
# https://web.archive.org/web/20130511041319/http://www.bundesbank.de/Redaktion/EN/Downloads/Press/Publications/ecb_holidays_2013.pdf?__blob=publicationFile
targetholidays = [Date(2013, 1, 1), Date(2013, 3, 29), Date(2013, 4, 1),
  Date(2013, 5, 1), Date(2013, 12, 25), Date(2013, 12, 26)]
  dt = Date(2013)
  while year(dt) <= 2013
    @test !((dt in targetholidays || isweekend(dt)) $
        !isgood(dt, EUTAFCalendar()))
    dt += Day(1)
end
