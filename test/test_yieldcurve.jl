using Dates, FinancialMarkets
dt0 = Date(2015, 3, 27)
dfs = [DiscountFactor(0.9999999, dt0, dt0 + Day(1)),
        DiscountFactor(0.997, dt0, dt0 + Month(1)),
        DiscountFactor(0.9965, dt0, dt0 + Month(2)),
        DiscountFactor(0.996, dt0, dt0 + Month(3))]

zc = FinancialMarkets.ZeroCurve(dt0, dfs,
    FinancialMarkets.LinearRateCurveInterpolator(), Continuously, A365())
interpolate(dt0 + Month(1), zc)
zc = FinancialMarkets.ZeroCurve(dt0, dfs,
    FinancialMarkets.LinearLogDFCurveInterpolator(), Continuously, A365())
interpolate(dt0 + Month(1), zc)
zc = FinancialMarkets.ZeroCurve(dt0, dfs,
    FinancialMarkets.CubicRateCurveInterpolator(), Continuously, A365())
interpolate(dt0 + Month(1), zc)

