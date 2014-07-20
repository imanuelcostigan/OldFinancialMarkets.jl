# Weekend tester
@test !isweekend(Date(2014, 7, 11))
@test isweekend(Date(2014, 7, 12))
@test isweekend(Date(2014, 7, 13))
@test !isweekend(Date(2014, 7, 14))

# NewYears tester
@test isnewyearsday(Date(2014, 1, 1))
