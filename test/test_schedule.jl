
using Dates, FinMarkets
d1 = Date(2012,1,3)
d2 = Date(2012,12,3)
sds = SwapDateSchedule(d1, d2, Month(3))
