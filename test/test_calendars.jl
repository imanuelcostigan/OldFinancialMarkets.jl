# Days in leap years
@test daysinyear(2012) == Day(366)
@test daysinyear(2013) == Day(365)

# Weekend tester
@test !isweekend(Date(2014, 7, 11))
@test isweekend(Date(2014, 7, 12))
@test isweekend(Date(2014, 7, 13))
@test !isweekend(Date(2014, 7, 14))

# NewYears tester
@test isnewyears(Date(2014, 1, 1))
subs = [Saturday, Sunday]
@test !isnewyears(Date(2014, 1, 2), subs)
@test isnewyears(Date(2012, 1, 2), subs)
