# http://www.dol.govt.nz/er/holidaysandleave/publicholidays/publicholidaydates/future-dates.asp

nzauholidays = [Date(2014, 1, 1), Date(2014, 1, 2), Date(2014, 1, 27),
    Date(2014, 2, 6), Date(2014, 4, 18), Date(2014, 4, 21), Date(2014, 4, 25),
    Date(2014, 6, 2), Date(2014, 10, 27), Date(2014, 12, 25), Date(2014, 12, 26),
    Date(2015, 1, 1), Date(2015, 1, 2), Date(2015, 1, 26), Date(2015, 2, 6),
    Date(2015, 4, 3), Date(2015, 4, 6), Date(2015, 4, 27), Date(2015, 6, 1),
    Date(2015, 10, 26), Date(2015, 12, 25), Date(2015, 12, 28)]
dt = Date(2014)
while year(dt) <= 2015
    !((dt in nzauholidays || isweekend(dt)) $
        !isgood(dt, NZAUFCalendar()))
    dt += Day(1)
end
