# Start test
d1 = Date(2012,1,3)
d2 = Date(2012,12,3)
sds = SwapDateSchedule(d1, d2, Month(3), AUSYFCalendar(), ModifiedFollowing(),
    ShortFrontStub(), false)
@test (sds.dates == [Date(2012,1,3), Date(2012,3,5), Date(2012,6,4),
    Date(2012,9,3), Date(2012,12,3)])

# Change effective date
d1 = Date(2012,1,16)
sds = SwapDateSchedule(d1, d2, Month(3), AUSYFCalendar(), ModifiedFollowing(),
    ShortFrontStub(), false)
@test (sds.dates == [Date(2012,1,16), Date(2012,3,5), Date(2012,6,4),
    Date(2012,9,3), Date(2012,12,3)])

# Change direction
sds = SwapDateSchedule(d1, d2, Month(3), AUSYFCalendar(), ModifiedFollowing(),
    ShortBackStub(), false)
@test (sds.dates == [Date(2012,1,16), Date(2012,4,16), Date(2012,7,16),
    Date(2012,10,16), Date(2012,12,3)])

# Change effective date
d1 = Date(2011,11,30)
sds = SwapDateSchedule(d1, d2, Month(3), AUSYFCalendar(), ModifiedFollowing(),
    ShortBackStub(), false)
@test (sds.dates == [Date(2011,11,30), Date(2012,2,29), Date(2012,5,30),
    Date(2012,8,30), Date(2012,11,30), Date(2012,12,3)])

# Change day conventiom
sds = SwapDateSchedule(d1, d2, Month(3), AUSYFCalendar(), Unadjusted(),
    ShortBackStub(), false)
@test (sds.dates == [Date(2011,11,30), Date(2012,2,29), Date(2012,5,30),
    Date(2012,8,30), Date(2012,11,30), Date(2012,12,3)])

# Change EOM rule
sds = SwapDateSchedule(d1, d2, Month(3), AUSYFCalendar(), Unadjusted(),
    ShortBackStub(), true)
@test (sds.dates == [Date(2011,11,30), Date(2012,2,29), Date(2012,5,31),
    Date(2012,8,31), Date(2012,11,30), Date(2012,12,3)])

# Change termination date
d2 = Date(2012,12,30)
sds = SwapDateSchedule(d1, d2, Month(3), AUSYFCalendar(), Unadjusted(),
    ShortBackStub(), true)
@test (sds.dates == [Date(2011,11,30), Date(2012,2,29), Date(2012,5,31),
    Date(2012,8,31), Date(2012,11,30), Date(2012,12,30)])
