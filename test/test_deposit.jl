depo = Deposit(USD(), Month(3), 0.04, Date(2014, 9, 26), 1e6)
cfs = CashFlow(depo)

@test FinancialMarkets.currency(depo) == USD()
@test isa(FinancialMarkets.rate(depo), InterestRate)
tau = years(depo.startdate, depo.enddate, depo.index.daycount)
@test price(depo) == 1e6 / (1 + 0.04 * tau)
@test cfs.currency == [USD(), USD()]
@test cfs.date == [Date(2014, 9, 30), Date(2014, 12, 31)]
@test_approx_eq cfs.amount [-price(depo), 1]
