using Base.Test, Dates, FinancialMarkets
dt0 = Date(2015, 3, 27)
dfs = [DiscountFactor(0.9999999, dt0, dt0 + Day(1)),
        DiscountFactor(0.997, dt0, dt0 + Month(1)),
        DiscountFactor(0.9965, dt0, dt0 + Month(2)),
        DiscountFactor(0.996, dt0, dt0 + Month(3))]
dtx = dt0 + Month(1) + Day(15)
t1 = years(dt0, dt0 + Month(1), A365())
t2 = years(dt0, dt0 + Month(2), A365())
tx = years(dt0, dtx, A365())

# Test constructors

# Test linear interpolation
zcli = ZeroCurve(dt0, dfs, LinearZeroRateInterpolator(), Continuously, A365())
@test isa(interpolate(dt0 + Month(1), zcli), DiscountFactor)
@test interpolate(dt0, zcli) == DiscountFactor(1.0, dt0, dt0)
@test interpolate(dt0 + Month(1), zcli) == DiscountFactor(0.997, dt0, dt0 + Month(1))
@test interpolate(dt0 + Month(2), zcli) == DiscountFactor(0.9965, dt0, dt0 + Month(2))
@test interpolate(dt0 + Month(3), zcli) == DiscountFactor(0.996, dt0, dt0 + Month(3))
rx = -log(.997) / t1 + (-log(0.9965) / t2 + log(.997) / t1) / (t2 - t1) * (tx - t1)
dfx = DiscountFactor(exp(-rx * tx), dt0, dtx)
@test interpolate(dtx, zcli) == dfx

# Test log-linear interpolation
zclli = ZeroCurve(dt0, dfs, LinearLogDFInterpolator(), Continuously, A365())
@test isa(interpolate(dt0 + Month(1), zclli), DiscountFactor)
@test interpolate(dt0, zclli) == DiscountFactor(1.0, dt0, dt0)
@test interpolate(dt0 + Month(1), zclli) == DiscountFactor(0.997, dt0, dt0 + Month(1))
@test interpolate(dt0 + Month(2), zclli) == DiscountFactor(0.9965, dt0, dt0 + Month(2))
@test interpolate(dt0 + Month(3), zclli) == DiscountFactor(0.996, dt0, dt0 + Month(3))
ldfx = log(.997) + (log(0.9965) - log(.997)) / (t2 - t1) * (tx - t1)
dfx = DiscountFactor(exp(ldfx), dt0, dtx)
@test interpolate(dtx, zclli) == dfx

# Test cubic spline interpolation
zccsi = ZeroCurve(dt0, dfs, CubicZeroRateInterpolator(), Continuously, A365())
@test isa(interpolate(dt0 + Month(1), zccsi), DiscountFactor)
@test interpolate(dt0, zccsi) == DiscountFactor(1.0, dt0, dt0)
@test interpolate(dt0 + Month(1), zccsi) == DiscountFactor(0.997, dt0, dt0 + Month(1))
@test interpolate(dt0 + Month(2), zccsi) == DiscountFactor(0.9965, dt0, dt0 + Month(2))
@test interpolate(dt0 + Month(3), zccsi) == DiscountFactor(0.996, dt0, dt0 + Month(3))
# Haven't tested intermediate point, because mechanism is same as linear and
# cubic spline calibration is already tested.
