## Data
x = [1, 2, 3, 3.1, 5.1, 6, 7, 8]
y = [1.8, 1.9, 1.7, 1.1, 1.1, 1.7, 1.4, 1.9]
## Results
s =  diff(y) ./ diff(x)

################################################################################
# LINEAR SPLINE
################################################################################

lsc = calibrate(x, y, LinearSpline())
true_coefficients = hcat(y[1:(end-1)], s)
## Test calibration
@test lsc.x == lsc.x
@test lsc.y == lsc.y
@test_approx_eq lsc.coefficients true_coefficients
## Test interpolation
## At a node
@test_approx_eq interpolate(2, lsc) 1.9
## At first / last node
@test_approx_eq interpolate(1, lsc) 1.8
@test_approx_eq interpolate(8, lsc) 1.9
## Before first / after last node
@test_throws ArgumentError interpolate(0, lsc)
@test_throws ArgumentError interpolate(9, lsc)
## Between nodes
y_12 = lsc.coefficients[1, 1] + lsc.coefficients[1, 2] * (1.2 - 1)
@test_approx_eq interpolate(1.2, lsc) y_12
## Test method without calibration
@test_approx_eq interpolate(1.2, x, y, LinearSpline()) y_12

################################################################################
# NAUTRAL CUBIC SPLINE
################################################################################
## Test case drawn from results of R applied to x, y above.
# R 3.1.2
# x = c(1, 2, 3, 3.1, 5.1, 6, 7, 8)
# y = c(1.8, 1.9, 1.7, 1.1, 1.1, 1.7, 1.4, 1.90)
# ncs = splinefun(x, y, method = 'natural')
# paste(ncs(seq(1, 8, .1)), collapse=", ")
ncs = calibrate(x, y, NaturalCubicSpline())
x0 = 1:.1:8
y0 = [1.8, 1.74259024277759, 1.68926592538685, 1.64411248765942, 1.61121536942698, 1.59466001052118, 1.59853185077369, 1.62691633001617, 1.68389888808027, 1.77356496479766, 1.9, 2.06290399368729, 2.24443518653289, 2.42236637937848, 2.57447037306577, 2.67851996843645, 2.71228796633221, 2.65354716759476, 2.48007037306577, 2.16963038358695, 1.7, 1.1, 0.554223603091185, 0.104634143213353, -0.255224511298153, -0.531808492107992, -0.731573930880824, -0.860976959281306, -0.926473708974096, -0.934520311623853, -0.891572898895236, -0.804087602452902, -0.67852055396151, -0.521327885085717, -0.338965727490184, -0.137890212839569, 0.0754425272014696, 0.294576360968279, 0.513055156796195, 0.724422783020558, 0.922223107976712, 1.1, 1.25262287499564, 1.38026333914833, 1.48441854621267, 1.56658564994324, 1.62826180409463, 1.67094416242141, 1.69612987867818, 1.70531610661951, 1.7, 1.68190012821526, 1.65362072322504, 1.61798743263013, 1.57782590403131, 1.53596178502935, 1.49522072322504, 1.45842836621917, 1.42841036161252, 1.40799235700587, 1.4, 1.40653380867554, 1.42679378303249, 1.45925479355069, 1.50239171070998, 1.55467940499022, 1.61459274687123, 1.68060660683288, 1.75119585535499, 1.82483536291742, 1.9]
y1 = Float64[interpolate(xi, ncs) for xi in x0]
@test_approx_eq y1 y0
## Before first / after last node
@test_throws ArgumentError interpolate(0, ncs)
@test_throws ArgumentError interpolate(9, ncs)

################################################################################
# CLAMPED CUBIC SPLINE
################################################################################

# Manually calculated A, b in spreadsheet
ccs = calibrate(x, y, ClampedCubicSpline(5, 2))
A = spdiagm(([1,1,.1,2,.9,1,1], [2,4,2.2,4.2,5.8,3.8,4,2], [1,1,.1,2,.9,1,1]),
    (-1,0,1))
b = [-29.4,-1.8,-34.8,36,4,-5.8,4.8,9]
ccs0 = FinancialMarkets.calibrate_cubic_spline(x, y, A, b)
@test_approx_eq ccs.coefficients ccs0.coefficients

################################################################################
# NOT-A-KNOT CUBIC SPLINE
################################################################################

# Manually calculated A, b in spreadsheet
nakcs = calibrate(x, y, NotAKnotCubicSpline())
A = spdiagm(([zeros(5),-1.0], [1,1,.1,2,.9,1,2], [-1,4,2.2,4.2,5.8,3.8,4,-1],
    [2,1,.1,2,.9,1,1], [-1.0,zeros(5)]), (-2,-1,0,1,2))
b = [0,-1.8,-34.8,36,4,-5.8,4.8,0]
nakcs0 = FinancialMarkets.calibrate_cubic_spline(x, y, A, b)
@test_approx_eq nakcs.coefficients nakcs0.coefficients

################################################################################
# AKIMA SPLINE
################################################################################
aksp = calibrate(x, y, AkimaSpline())
