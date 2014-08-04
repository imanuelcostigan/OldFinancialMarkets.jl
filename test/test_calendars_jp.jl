# Source:
# http://www.boj.or.jp/en/about/outline/holi.htm/
# Vernal equinox in 2014 is 20 Mar (not 21 Mar per BOJ website). See
# http://en.wikipedia.org/wiki/Equinox (Northward Equinox, March)
jpholidays = [Date(2014, 1, 1), Date(2014, 1, 2), Date(2014, 1, 3),
    Date(2014, 1, 13), Date(2014, 2, 11), Date(2014, 3, 20), Date(2014, 4, 29),
    Date(2014, 5, 3), Date(2014, 5, 4), Date(2014, 5, 5), Date(2014, 5, 6),
    Date(2014, 7, 21), Date(2014, 9, 15), Date(2014, 9, 23),
    Date(2014, 10, 13), Date(2014, 11, 3), Date(2014, 11, 23),
    Date(2014, 11, 24), Date(2014, 12, 23), Date(2014, 12, 31),
    Date(2013, 1, 1), Date(2013, 1, 2), Date(2013, 1, 3),
    Date(2013, 1, 14), Date(2013, 2, 11), Date(2013, 3, 20),
    Date(2013, 4, 29), Date(2013, 5, 3), Date(2013, 5, 4),
    Date(2013, 5, 5), Date(2013, 5, 6), Date(2013, 7, 15),
    Date(2013, 9, 16), Date(2013, 9, 23), Date(2013, 10, 14),
    Date(2013, 11, 3), Date(2013, 11, 4), Date(2013, 11, 23),
    Date(2013, 12, 23), Date(2013, 12, 31)]
dt = Date(2013)
while year(dt) <= 2014
    @test !((dt in jpholidays || isweekend(dt)) $
        !isgoodday(dt, JPTOFCalendar()))
    dt += Day(1)
end
