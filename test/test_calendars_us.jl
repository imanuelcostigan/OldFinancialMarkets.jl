# Test USNY calendars
# http://www.cs.ny.gov/attendance_leave/2012_legal_holidays.cfm
# http://www.cs.ny.gov/attendance_leave/2013_legal_holidays.cfm
usholidays = [Date(2012, 1, 1), Date(2012, 1, 2), Date(2012, 1, 16),
    Date(2012, 2, 12), Date(2012, 2, 20), Date(2012, 5, 28), Date(2012, 7, 4),
    Date(2012, 9, 3), Date(2012, 10, 8), Date(2012, 11, 11),
    Date(2012, 11, 12), Date(2012, 11, 22), Date(2012, 12, 25),
    Date(2013, 1, 1), Date(2013, 1, 21), Date(2013, 2, 18),
    Date(2013, 5, 27), Date(2013, 7, 4), Date(2013, 9, 2),
    Date(2013, 10, 14), Date(2013, 11, 11), Date(2013, 11, 28),
    Date(2013, 12, 25)]
dt = Date(2012)
while year(dt) <= 2013
    res = !((dt in usholidays || isweekend(dt)) $
        !isgoodday(dt, USNYFCalendar()))
    !res && println("$dt: $res")
    dt += Day(1)
end
