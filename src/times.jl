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
# Day count basis methods
####

function years(date1::TimeType, date2::TimeType, dc::A365)
    date1 == date2 && return 0
    (Date(date2) - Date(date1)).value / 365
end

function years(date1::TimeType, date2::TimeType, dc::A360)
    date1 == date2 && return 0
    (Date(date2) - Date(date1)).value / 360
end

function years(date1::TimeType, date2::TimeType, dc::ActActISDA)
    date1 == date2 && return 0
    y1 = year(date1); y2 = year(date2)
    diy1 = daysinyear(year(date1)); diy2 = daysinyear(year(date2))
    bony1 = Date(y1 + 1, 1, 1)
    boy2 = Date(y2, 1, 1)
    return ((bony1 - Date(date1)).value / diy1 + y2 - y1 - 1 +
        (Date(date2) - boy2).value / diy2)
end

function years(date1::TimeType, date2::TimeType, dc::Thirty360)
    date1 == date2 && return 0
    y1, m1, d1 = yearmonthday(date1)
    y2, m2, d2 = yearmonthday(date2)
    d1 == 31 && (d1 = 30)
    d2 == 31 && d1 > 29 && (d2 = 30)
    (360 * (y2 - y1) + 30 * (m2 - m1) + (d2 - d1)) / 360
end

function years(date1::TimeType, date2::TimeType, dc::ThirtyE360)
    date1 == date2 && return 0
    y1, m1, d1 = yearmonthday(date1)
    y2, m2, d2 = yearmonthday(date2)
    d1 == 31 && (d1 = 30)
    d2 == 31 && (d2 = 30)
    (360 * (y2 - y1) + 30 * (m2 - m1) + (d2 - d1)) / 360
end

function years(date1::TimeType, date2::TimeType, dc::ThirtyEP360)
    date1 == date2 && return 0
    y1, m1, d1 = yearmonthday(date1)
    y2, m2, d2 = yearmonthday(date2)
    d1 == 31 && (d1 = 30)
    d2 == 31 && (m2 += 1)
    d2 == 31 && (d2 = 1)
    (360 * (y2 - y1) + 30 * (m2 - m1) + (d2 - d1)) / 360
end

