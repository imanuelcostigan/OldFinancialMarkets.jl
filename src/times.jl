#####
# Type declarations
#####

abstract DayCountFraction
immutable A365 <: DayCountFraction
    name::String
end
immutable A360 <: DayCountFraction
    name::String
end
immutable ActActISDA <: DayCountFraction
    name::String
end
immutable Thirty360 <: DayCountFraction
    name::String
end
immutable ThirtyE360 <: DayCountFraction
    name::String
end
immutable ThirtyEP360 <: DayCountFraction
    name::String
end

####
# Constructors
####

A365() = A365("Actual/365 (Fixed)")
A360() = A360("Actual/360")
ActActISDA() = ActActISDA("Actual/Actual (ISDA)")
Thirty360() = Thirty360("30/360")
ThirtyE360() = ThirtyE360("30E/360 (ISDA)")
ThirtyEP360() = ThirtyEP360("30E+/360 (ISDA)")

####
# Helper methods
####

daysinyear(year::Int) = isleap(year) ? Day(366) : Day(365)

####
# Day count basis methods
####

years(date1::Date, date2::Date, dc::A365) = (date2 - date1).value / 365

years(date1::Date, date2::Date, dc::A360) = (date2 - date1).value / 360

function years(date1::Date, date2::Date, dc::ActActISDA)
    date1 == date2 && return 0
    y1 = year(date1); y2 = year(date2)
    diy1 = daysinyear(year(date1)); diy2 = daysinyear(year(date2))
    bony1 = Date(y1 + 1, 1, 1)
    boy2 = Date(y2, 1, 1)
    return ((bony1 - date1).value / diy1.value + y2 - y1 - 1 +
        (date2 - boy2).value / diy2.value)
end

function years(date1::Date, date2::Date, dc::Thirty360)
    date1 == date2 && return 0
    d1 = day(date1); d2 = day(date2)
    m1 = month(date1); m2 = month(date2)
    y1 = year(date1); y2 = year(date2)
    d1 == 31 && (d1 = 30)
    d2 == 31 && d1 > 29 && (d2 = 30)
    (360 * (y2 - y1) + 30 * (m2 - m1) + (d2 - d1)) / 360
end

function years(date1::Date, date2::Date, dc::ThirtyE360)
    date1 == date2 && return 0
    d1 = day(date1); d2 = day(date2)
    m1 = month(date1); m2 = month(date2)
    y1 = year(date1); y2 = year(date2)
    d1 == 31 && (d1 = 30)
    d2 == 31 && (d2 = 30)
    (360 * (y2 - y1) + 30 * (m2 - m1) + (d2 - d1)) / 360
end

function years(date1::Date, date2::Date, dc::ThirtyEP360)
    date1 == date2 && return 0
    d1 = day(date1); d2 = day(date2)
    m1 = month(date1); m2 = month(date2)
    y1 = year(date1); y2 = year(date2)
    d1 == 31 && (d1 = 30)
    d2 == 31 && (m2 += 1)
    d2 == 31 && (d2 = 1)
    (360 * (y2 - y1) + 30 * (m2 - m1) + (d2 - d1)) / 360
end

