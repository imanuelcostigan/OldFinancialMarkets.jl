####
# Types
####

immutable Compounding
    frequency::Int  # per annum
end

Simply = Compounding(0)
Annually = Compounding(1)
SemiAnnually = Compounding(2)
TriAnnually = Compounding(3)
Quarterly = Compounding(4)
BiMonthly = Compounding(6)
Monthly = Compounding(12)
Fortnightly = Compounding(24)
Weekly = Compounding(52)
Daily = Compounding(365)
Continuously = Compounding(1000)

type InterestRate
    rate::Float64
    compounding::Compounding
    daycount::DayCountFraction
end


type DiscountFactor
    discountfactor::Float64
    startdate::TimeType
    enddate::TimeType
    function DiscountFactor(df, dt1, dt2)
        msg = "Start occurs after the end date."
        dt1 <= dt2 || throw(ArgumentError(msg))
        new(df, dt1, dt2)
    end
end


####
# Methods
####

# Value extraction
value(r::InterestRate) = r.rate
value(df::DiscountFactor) = df.discountfactor

# IO
function Base.string(r::InterestRate)
    (@sprintf("%05f", 100 * value(r)) * "%," *
        uppercase(COMPOUNDINGS[r.compounding.frequency]) * "," *
        uppercase(string(r.daycount)))
end
Base.show(io::IO, r::InterestRate) = print(io, string(r))

function Base.string(df::DiscountFactor)
   ("DF: " * @sprintf("%06f", value(df)) * ", " * string(df.startdate) *
        "--" * string(df.enddate))
end
Base.show(io::IO, df::DiscountFactor) = print(io, string(df))

# conversions
function Base.convert(::Type{DiscountFactor}, x::InterestRate,
    startdate::TimeType, enddate::TimeType)
    t = years(startdate, enddate, x.daycount)
    if x.compounding == Continuously
        df = exp(-value(x) * t)
    elseif x.compounding == Simply
        df = 1 / (1 + t * value(x))
    else
        freq = x.compounding.frequency
        df = 1 / ((1 + value(x) / freq) ^ (freq * t))
    end
    return DiscountFactor(df, startdate, enddate)
end

function DiscountFactor(r::InterestRate, dt1::TimeType, dt2::TimeType)
    convert(DiscountFactor, r, dt1, dt2)
end

function Base.convert(::Type{InterestRate}, x::DiscountFactor,
    compounding::Compounding, daycount::DayCountFraction)
    t = years(x.startdate, x.enddate, daycount)
    if compounding == Continuously
        rate = -log(value(x)) / t
    elseif compounding == Simply
        rate = (1 / value(x) - 1) / t
    else
        freq = compounding.frequency
        rate = (freq * ((1 / value(x)) ^ (1 / (freq * t)) - 1))
    end
    return InterestRate(rate, compounding, daycount)
end

function InterestRate(df::DiscountFactor, cmp::Compounding,
    dc::DayCountFraction)
    convert(InterestRate, df, cmp, dc)
end

function Base.convert(::Type{InterestRate}, x::InterestRate,
    compounding::Compounding)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, compounding, x.daycount)
end

InterestRate(r::InterestRate, cmp::Compounding) = convert(InterestRate, r, cmp)

function Base.convert(::Type{InterestRate}, x::InterestRate, daycount::DayCountFraction)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, x.compounding, daycount)
end

InterestRate(r::InterestRate, dc::DayCountFraction) = convert(InterestRate, r, dc)

function Base.convert(::Type{InterestRate}, x::InterestRate,
    compounding::Compounding, daycount::DayCountFraction)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, compounding, daycount)
end

function InterestRate(r::InterestRate, cmp::Compounding, dc::DayCountFraction)
    convert(InterestRate, r, cmp, dc)
end

function equivalent(to::InterestRate, x::InterestRate)
    flag = !(x.compounding == to.compounding && x.daycount == to.daycount)
    flag ? convert(InterestRate, x, to.compounding, to.daycount) : x
end

# arithmetic operations
for op in (:+, :*, :-, :/)
    @eval begin
        function ($op)(x::InterestRate, y::Real)
            InterestRate(($op)(value(x), y), x.compounding, x.daycount)
        end
    end
    @eval begin
        function ($op)(x::InterestRate, y::InterestRate)
            InterestRate(($op)(value(x), value(equivalent(x, y))),
                x.compounding, x.daycount)
        end
    end
end
(+)(x::Real, y::InterestRate) = y + x
(*)(x::Real, y::InterestRate) = y * x
(-)(x::Real, y::InterestRate) = -1(y - x)
(/)(x::Real, y::InterestRate) = InterestRate(x / value(y), y.compounding,
    y.daycount)

function (*)(x::DiscountFactor, y::DiscountFactor)
    msg = "The discount factors must represent two cotinguous spans of time."
    (x.enddate == y.enddate || y.startdate == x.enddate) || throw(
        ArgumentError(msg))
    DiscountFactor(value(x) * value(y), min(x.startdate, y.startdate),
        max(x.enddate, y.enddate))
end
function (/)(x::DiscountFactor, y::DiscountFactor)
    msg = "The discount factors must start at the same instant."
    (x.startdate == y.startdate) || throw(ArgumentError(msg))
    DiscountFactor(value(x) / value(y), min(x.enddate, y.enddate),
        max(x.enddate, y.enddate))
end

# comparison operations
for op in (:(==), :!=, :<, :<=, :>, :>=)
    @eval begin
        function ($op)(x::InterestRate, y::InterestRate)
            return ($op)(value(x), value(equivalent(x, y)))
        end
        (($op)(x::DiscountFactor, y::DiscountFactor) =
            ($op)(value(x), value(y)))
    end
end
