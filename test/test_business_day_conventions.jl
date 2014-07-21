# Test adjustment of dates by business day conventions

@test adjust(Date(2011, 8, 18), Unadjusted()) == Date(2011, 8, 18)
@test adjust(Date(2011, 9, 18), Following()) == Date(2011, 9, 19)
@test adjust(Date(2011, 9, 18), Preceding()) == Date(2011, 9, 16)
@test adjust(Date(2011, 7, 30), ModifiedFollowing()) == Date(2011, 7, 29)
@test adjust(Date(2014, 6, 1), ModifiedPreceding()) == Date(2014, 6, 2)
@test adjust(Date(2012, 1, 15), Succeeding()) == Date(2012, 1, 13)
