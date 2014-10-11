cf1 = CashFlow([AUD(), AUD()], [Date(2014, 1,1), Date(2014,2,1)], [100, 100])
cf2 = CashFlow([AUD(), USD()], [Date(2014, 1,1), Date(2014,2,1)], [100, 100])
@test isa(cf1, CashFlow)
@test isa(cf2, CashFlow)
