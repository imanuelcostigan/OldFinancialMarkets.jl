@test FinMarkets.settlement(1, 3, Wed, Day(0), Date(2014, 9, 7)) == Date(2014, 9, 17)
@test FinMarkets.settlement(1, 3, Wed, Day(0), Date(2014, 9, 27)) == Date(2014, 12, 17)
@test FinMarkets.settlement(2, 3, Wed, Day(0), Date(2014, 9, 27)) == Date(2015, 3, 18)
@test FinMarkets.settlement(1, 2, Fri, Day(0), Date(2014, 9, 27)) == Date(2014, 12, 12)
@test FinMarkets.settlement(1, 1, Wed, Day(8), Date(2014, 9, 27)) == Date(2014, 12, 10)

stir = STIRFuture(EUR(), 1, 96, Date(2014, 9, 26), 1)
cfs = CashFlow(stir)

@test FinMarkets.currency(stir) == EUR()
@test isa(FinMarkets.rate(stir), InterestRate)
tau = years(stir.underlying.startdate, stir.underlying.enddate,
    stir.underlying.index.daycount)
@test price(stir) == 1e6 / (1 + 0.04 * tau)
@test cfs.currency == [EUR(), EUR()]
@test cfs.date == [Date(2014, 12, 17), Date(2015, 3, 17)]
@test_approx_eq cfs.amount 1 * [-price(stir), 1e6]
