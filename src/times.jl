#####
# Type declarations
#####

abstract DayCountFraction

# Sources:
# 1. ISDA 2006 definitions
# 2. Opengamma: Interest rate instruments and market conventions guide

immutable A365 <: DayCountFraction end
immutable A360 <: DayCountFraction end
immutable ActActISDA <: DayCountFraction end
immutable Thirty360 <: DayCountFraction end
immutable ThirtyE360 <: DayCountFraction end
immutable ThirtyEP360 <: DayCountFraction end

####
# Day count basis methods
####

Base.string(dc::DayCountFraction) = string(typeof(dc))
Base.show(io::IO, dc::DayCountFraction) = print(io, string(dc))

function years(date1::Date, date2::Date, dc::A365)
    date1 == date2 && return 0.
    (date2 - date1).value / 365.
end

function years(date1::Date, date2::Date, dc::A360)
    date1 == date2 && return 0.
    (date2 - date1).value / 360.
end

function years(date1::Date, date2::Date, dc::ActActISDA)
    date1 == date2 && return 0.
    y1, y2 = (year(date1), year(date2))
    diy1, diy2 = (daysinyear(year(date1)), daysinyear(year(date2)))
    bony1 = Date(y1 + 1, 1, 1)
    boy2 = Date(y2, 1, 1)
    (bony1 - date1).value / diy1 + y2 - y1 - 1 + (date2 - boy2).value / diy2
end

function years(date1::Date, date2::Date, dc::Thirty360)
    date1 == date2 && return 0.
    y1, m1, d1 = yearmonthday(date1)
    y2, m2, d2 = yearmonthday(date2)
    d1 == 31 && (d1 = 30.)
    d2 == 31 && d1 > 29 && (d2 = 30.)
    (360.(y2 - y1) + 30.(m2 - m1) + (d2 - d1)) / 360.
end

function years(date1::Date, date2::Date, dc::ThirtyE360)
    date1 == date2 && return 0.
    y1, m1, d1 = yearmonthday(date1)
    y2, m2, d2 = yearmonthday(date2)
    d1 == 31 && (d1 = 30.)
    d2 == 31 && (d2 = 30.)
    (360.(y2 - y1) + 30.(m2 - m1) + (d2 - d1)) / 360.
end

function years(date1::Date, date2::Date, dc::ThirtyEP360)
    date1 == date2 && return 0.
    y1, m1, d1 = yearmonthday(date1)
    y2, m2, d2 = yearmonthday(date2)
    d1 == 31 && (d1 = 30.)
    d2 == 31 && (m2 += 1.)
    d2 == 31 && (d2 = 1.)
    (360.(y2 - y1) + 30.(m2 - m1) + (d2 - d1)) / 360.
end

function years(d1::DateTime, d2::DateTime, dc::DayCountFraction)
    years(Date(d1), Date(d2), dc)
end

