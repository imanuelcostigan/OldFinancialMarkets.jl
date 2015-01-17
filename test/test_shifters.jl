u = Unadjusted()
f = Following()
mf = ModifiedFollowing()
nocal = NoCalendar()
sydcal = AUSYCalendar()

# Test day shifters
sdt = shift(Date(2012, 2, 29), Day(1), u, nocal, false)
@test sdt == Date(2012, 3, 1)
sdt = shift(Date(2012, 2, 29), Day(3), u, nocal, false)
@test sdt == Date(2012, 3, 5)
sdt = shift(Date(2012, 2, 29), Day(3), f, sydcal, false)
@test sdt == Date(2012, 3, 5)
sdt = shift(Date(2012, 2, 29), Day(3), f, sydcal, true)
@test sdt == Date(2012, 3, 5)

# Test week shifters
sdt = shift(Date(2012, 12, 18), Week(1), u, nocal, false)
@test sdt == Date(2012, 12, 25)
sdt = shift(Date(2012, 12, 18), Week(1), f, sydcal, false)
@test sdt == Date(2012, 12, 27)
sdt = shift(Date(2012, 12, 18), Week(1), f, sydcal, true)
@test sdt == Date(2012, 12, 27)

# Test month shifters
sdt = shift(Date(2012, 1, 31), Month(1), u, nocal, false)
@test sdt == Date(2012, 2, 29)
sdt = shift(Date(2012, 2, 29), Month(1), u, nocal, false)
@test sdt == Date(2012, 3, 29)
sdt = shift(Date(2012, 2, 29), Month(1), u, nocal, true)
@test sdt == Date(2012, 3, 30)

# Test year shifters
sdt1 = shift(Date(2012, 2, 29), Month(24), mf, sydcal, true)
sdt2 = shift(Date(2012, 2, 29), Year(2), mf, sydcal, true)
@test sdt1 == sdt2
