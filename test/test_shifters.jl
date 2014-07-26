# Test day shifters
sdt = shift(Date(2012, 2, 29), Day(1), Unadjusted(), NoFCalendar(), false)
@test sdt == Date(2013, 3, 1)
sdt = shift(Date(2012, 2, 29), Day(3), Unadjusted(), NoFCalendar(), false)
@test sdt == Date(2013, 3, 3)
sdt = shift(Date(2012, 2, 29), Day(3), Following(), AUSYFCalendar(), false)
@test sdt == Date(2013, 3, 5)
sdt = shift(Date(2012, 2, 29), Day(3), Following(), AUSYFCalendar(), true)
@test sdt == Date(2013, 3, 5)

# Test week shifters
sdt = shift(Date(2012, 12, 18), Week(1), Unadjusted(), NoFCalendar(), false)
@test sdt == Date(2012, 12, 25)
sdt = shift(Date(2012, 12, 18), Week(1), Following(), AUSYFCalendar(), false)
@test sdt == Date(2012, 12, 29)
sdt = shift(Date(2012, 12, 18), Week(1), Following(), AUSYFCalendar(), true)
@test sdt == Date(2012, 12, 29)

# Test month shifters
