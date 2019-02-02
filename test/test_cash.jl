audcash = Cash(AUD(), 0.04, Date(2014, 9, 26), 1e6)
cfs = CashFlow(audcash)

@test FinancialMarkets.currency(audcash) == AUD()
@test isa(FinancialMarkets.rate(audcash), InterestRate)
@test price(audcash) == 1e6
@test cfs.currency == [AUD(), AUD()]
@test cfs.date == [Date(2014, 9, 26), Date(2014, 9, 29)]
@test cfs.amount ≈ 1e6 * [-1.0, 1.0 + 0.04 * 3.0 / 365.0]
