x = [1, 2, 3, 3.1, 5.1, 6, 7, 8]
y = [1.8, 1.9, 1.7, 1.1, 1.1, 1.7, 1.4, 1.9]
s =  diff(y) ./ diff(x)
lsc = calibrate(x, y, LinearSpline())
true_coefficients = hcat(y[1:(end-1)], s)
@test lsc.x == lsc.x
@test lsc.y == lsc.y
@test_approx_eq lsc.coefficients true_coefficients
