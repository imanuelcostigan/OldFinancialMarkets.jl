d1 = Date(2014, 1, 1)
d2 = Date(2015, 1, 1)
d3 = Date(2014, 2, 1)
d4 = Date(2012, 12, 1)
d5 = Date(2014, 1, 31)
d6 = Date(2014, 3, 31)

# A/365
a365 = A365()
@test years(d1, d2, a365) ≈ 1.0
@test years(d2, d1, a365) ≈  -1.0
@test years(d1, d3, a365) ≈  31 / 365

# A/360
a360 = A360()
@test years(d1, d2, a360) ≈  365 / 360
@test years(d2, d1, a360) ≈  -365 / 360
@test years(d1, d3, a360) ≈  31 / 360

# Act/Act
actact = ActActISDA()
@test years(d1, d2, actact) ≈  1.0
@test years(d2, d1, actact) ≈  -1.0
@test years(d4, d1, actact) ≈  31 / 366 + 1

# Thirty360
thirty360 = Thirty360()
@test years(d1, d2, thirty360) ≈ 1.0
@test years(d2, d1, thirty360) ≈ -1.0
@test years(d1, d3, thirty360) ≈ 1 / 12
@test years(d4, d1, thirty360) ≈ (2 * 360 - 11 * 30)  / 360
@test years(d1, d5, thirty360) ≈ 1 / 12
@test years(d5, d6, thirty360) ≈ 1 / 6
@test years(d1, d6, thirty360) ≈ (2 * 30 + 30) / 360

# ThirtyE360
thirtyE360 = ThirtyE360()
@test years(d1, d2, thirtyE360) ≈ years(d1, d2, thirty360)
@test years(d2, d1, thirtyE360) ≈ years(d2, d1, thirty360)
@test years(d1, d3, thirtyE360) ≈ years(d1, d3, thirty360)
@test years(d4, d1, thirtyE360) ≈ years(d4, d1, thirty360)
@test years(d1, d5, thirtyE360) ≈ 29 / 360
@test years(d5, d6, thirtyE360) ≈ years(d5, d6, thirty360)
@test years(d1, d6, thirtyE360) ≈ (2 * 30 + 29) / 360

# ThirtyEP360
thirtyEP360 = ThirtyEP360()
@test years(d1, d2, thirtyEP360) ≈ years(d1, d2, thirty360)
@test years(d2, d1, thirtyEP360) ≈ years(d2, d1, thirty360)
@test years(d1, d3, thirtyEP360) ≈ years(d1, d3, thirty360)
@test years(d1, d5, thirtyEP360) ≈ 1 / 12
@test years(d5, d6, thirtyEP360) ≈ (-29 + 3 * 30) / 360
@test years(d1, d6, thirtyEP360) ≈ 3 * 30 / 360
