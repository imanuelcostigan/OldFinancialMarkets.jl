####
# Types
####

type InterestRate
    rate::Real
    compounding::Int
    daycount::DayCountFraction
    function InterestRate(rate, compounding, daycount)
        haskey(COMPOUNDINGS, compounding) || error("Invalid compounding.")
        new(rate, compounding, daycount)
    end
end


type DiscountFactor
    discountfactor::Real
    startdate::TimeType
    enddate::TimeType
    function DiscountFactor(discountfactor, startdate, enddate)
        startdate <= enddate || error("Start occurs after the end date.")
        new(discountfactor, startdate, enddate)
    end
end


####
# Methods
####

# conversions
function Base.convert(DiscountFactor, x::InterestRate, startdate::TimeType,
    enddate::TimeType)
    t = years(startdate, enddate, x.daycount)
    if x.compounding == Continuously
        df = exp(-x.rate * t)
    elseif x.compounding == Simply
        df = 1 / (1 + t * x.rate)
    else
        df = 1 / ((1 + x.rate / x.compounding) ^ (x.compounding * t))
    end
    return DiscountFactor(df, startdate, enddate)
end

function Base.convert(InterestRate, x::DiscountFactor, compounding::Int,
    daycount::DayCountFraction)
    t = years(x.startdate, x.enddate, daycount)
    if compounding == Continuously
        rate = -log(x.discountfactor) / t
    elseif compounding == Simply
        rate = (1 / x.discountfactor - 1) / t
    else
        rate = (compounding *
            ((1 / x.discountfactor) ^ (1 / (compounding * t)) - 1))
    end
    return InterestRate(rate, compounding, daycount)
end

function Base.convert(InterestRate, x::InterestRate, compounding::Int)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, compounding, x.daycount)
end

function Base.convert(InterestRate, x::InterestRate, daycount::DayCountFraction)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, x.compounding, daycount)
end

function Base.convert(InterestRate, x::InterestRate, compounding::Int,
    daycount::DayCountFraction)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, compounding, daycount)
end

# operations

(+)(x::InterestRate, y::Real) = InterestRate(x.rate + y, x.compounding, x.daycount)
(*)(x::InterestRate, y::Real) = InterestRate(x.rate * y, x.compounding, x.daycount)
(-)(x::InterestRate, y::Real) = InterestRate(x.rate - y, x.compounding, x.daycount)
(/)(x::InterestRate, y::Real) = InterestRate(x.rate / y, x.compounding, x.daycount)
(+)(x::Real, y::InterestRate) = y + x
(*)(x::Real, y::InterestRate) = y * x
(-)(x::Real, y::InterestRate) = -1(y - x)
(/)(x::Real, y::InterestRate) = InterestRate(x / y.rate, y.compounding, y.daycount)
function (+)(x::InterestRate, y::InterestRate)
    yx = convert(InterestRate, y, x.compounding, x.daycount)
    InterestRate(x.rate + yx.rate, x.compounding, x.daycount)
end
function (*)(x::InterestRate, y::InterestRate)
    yx = convert(InterestRate, y, x.compounding, x.daycount)
    InterestRate(x.rate * yx.rate, x.compounding, x.daycount)
end
function (-)(x::InterestRate, y::InterestRate)
    yx = convert(InterestRate, y, x.compounding, x.daycount)
    InterestRate(x.rate - yx.rate, x.compounding, x.daycount)
end
function (/)(x::InterestRate, y::InterestRate)
    yx = convert(InterestRate, y, x.compounding, x.daycount)
    InterestRate(x.rate / yx.rate, x.compounding, x.daycount)
end
