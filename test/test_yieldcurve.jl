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
rx = -log(.997) / t1 + (-log(0.9965) / t2 + log(.997) / t1) / (t2 - t1) * (tx - t1)
dfx = DiscountFactor(exp(-rx * tx), dt0, dtx)

# Test constructors

# Test linear interpolation
zcli = ZeroCurve(dt0, dfs, LinearRateCurveInterpolator(), Continuously, A365())
@test isa(interpolate(dt0 + Month(1), zcli), DiscountFactor)
@test interpolate(dt0, zcli) == DiscountFactor(1.0, dt0, dt0)
@test interpolate(dt0 + Month(1), zcli) == DiscountFactor(0.997, dt0, dt0 + Month(1))
@test interpolate(dt0 + Month(2), zcli) == DiscountFactor(0.9965, dt0, dt0 + Month(2))
@test interpolate(dt0 + Month(3), zcli) == DiscountFactor(0.996, dt0, dt0 + Month(3))
@test interpolate(dtx, zcli) == dfx

# Test log-linear interpolation
zclli = ZeroCurve(dt0, dfs, LinearLogDFCurveInterpolator(), Continuously, A365())
interpolate(dt0 + Month(1), zclli)

# Test cubic spline interpolation
zccsi = ZeroCurve(dt0, dfs, CubicRateCurveInterpolator(), Continuously, A365())
interpolate(dt0 + Month(1), zccsi)

