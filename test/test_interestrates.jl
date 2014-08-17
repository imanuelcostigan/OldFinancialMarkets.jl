a365 = A365()
thirty360 = Thirty360()
d1 = Date(2013, 1, 1)
d2 = Date(2014, 6, 30)
r = InterestRate(0.04, Simply, a365)
df = DiscountFactor(1 / (1 + 0.04 * years(d1, d2, a365)), d1, d2)

# Test conversion between DF & IR & vice-versa
@test_approx_eq convert(DiscountFactor, r, d1, d2).discountfactor df.discountfactor
@test_approx_eq convert(InterestRate, df, Simply, a365).rate r.rate
r.compounding = Quarterly
df.discountfactor = (1 + 0.04 / 4) ^ (-4 * years(d1, d2, a365))
@test_approx_eq convert(DiscountFactor, r, d1, d2).discountfactor df.discountfactor
@test_approx_eq convert(InterestRate, df, Quarterly, a365).rate r.rate
r.compounding = Continuously
df.discountfactor = exp(-0.04years(d1, d2, a365))
@test_approx_eq convert(DiscountFactor, r, d1, d2).discountfactor df.discountfactor
@test_approx_eq convert(InterestRate, df, Continuously, a365).rate r.rate

# Test conversion between rates
d1 = Date(2013,1,1)
d2 = Date(2014,1,1)
r1 = convert(InterestRate, convert(DiscountFactor, r, d1, d2), r.compounding,
    thirty360)
r2 = convert(InterestRate, convert(DiscountFactor, r, d1, d2), SemiAnnually,
    r.daycount)
r3 = convert(InterestRate, convert(DiscountFactor, r, d1, d2), SemiAnnually,
    thirty360)
@test_approx_eq convert(InterestRate, r, thirty360).rate r1.rate
@test_approx_eq convert(InterestRate, r, SemiAnnually).rate r2.rate
@test_approx_eq convert(InterestRate, r, SemiAnnually, thirty360).rate r3.rate
