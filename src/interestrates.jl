using Printf

####
# Types
####

struct InterestRate
    rate::Real
    compounding::Int
    daycount::DayCountFraction
    function InterestRate(r, cmp, dc)
        msg = "Invalid compounding."
        haskey(COMPOUNDINGS, cmp) || throw(ArgumentError(msg))
        new(r, cmp, dc)
    end
end


struct DiscountFactor
    discountfactor::Real
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
    s = @sprintf "%05f" 100 * value(r) 
    "$(s)%, $(uppercase(COMPOUNDINGS[r.compounding])), $(uppercase(string(r.daycount))))"
end
Base.show(io::IO, r::InterestRate) = print(io, string(r))

function Base.string(df::DiscountFactor)
   "DF: $(@sprintf("%06f", value(df))), $(df.startdate)--$(string(df.enddate))"
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
        df = 1 / ((1 + value(x) / x.compounding) ^ (x.compounding * t))
    end
    return DiscountFactor(df, startdate, enddate)
end

function DiscountFactor(r::InterestRate, dt1::TimeType, dt2::TimeType)
    convert(DiscountFactor, r, dt1, dt2)
end

function Base.convert(::Type{InterestRate}, x::DiscountFactor, compounding::Int,
    daycount::DayCountFraction)
    t = years(x.startdate, x.enddate, daycount)
    if compounding == Continuously
        rate = -log(value(x)) / t
    elseif compounding == Simply
        rate = (1 / value(x) - 1) / t
    else
        rate = (compounding *
            ((1 / value(x)) ^ (1 / (compounding * t)) - 1))
    end
    return InterestRate(rate, compounding, daycount)
end

InterestRate(df::DiscountFactor, cmp::Int, dc::DayCountFraction) =  convert(
    InterestRate, df, cmp, dc)

function Base.convert(::Type{InterestRate}, x::InterestRate, compounding::Int)
    startdate, enddate = Date(2013, 1, 1), Date(2014, 1, 1)
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, compounding, x.daycount)
end

InterestRate(r::InterestRate, cmp::Int) = convert(InterestRate, r, cmp)

function Base.convert(::Type{InterestRate}, x::InterestRate, daycount::DayCountFraction)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, x.compounding, daycount)
end

InterestRate(r::InterestRate, dc::DayCountFraction) = convert(InterestRate, r, dc)

function Base.convert(::Type{InterestRate}, x::InterestRate, compounding::Int,
    daycount::DayCountFraction)
    startdate, enddate = (Date(2013, 1, 1), Date(2014, 1, 1))
    df = convert(DiscountFactor, x, startdate, enddate)
    convert(InterestRate, df, compounding, daycount)
end

InterestRate(r::InterestRate, cmp::Int, dc::DayCountFraction) = convert(
    InterestRate, r, cmp, dc)

function equivalent(to::InterestRate, x::InterestRate)
    flag = !(x.compounding == to.compounding && x.daycount == to.daycount)
    flag ? convert(InterestRate, x, to.compounding, to.daycount) : x
end

# arithmetic operations
for op in (:+, :*, :-, :/)
    @eval begin
        function Base.$op(x::InterestRate, y::Real)
            InterestRate(Base.$op(value(x), y), x.compounding, x.daycount)
        end
    end
    @eval begin
        function Base.$op(x::InterestRate, y::InterestRate)
            InterestRate(Base.$op(value(x), value(equivalent(x, y))), x.compounding, x.daycount)
        end
    end
end

Base.:+(x::Real, y::InterestRate) = y + x
Base.:*(x::Real, y::InterestRate) = y * x
Base.:-(x::Real, y::InterestRate) = -1(y - x)
Base.:/(x::Real, y::InterestRate) = InterestRate(x / value(y), y.compounding,
    y.daycount)

function Base.:*(x::DiscountFactor, y::DiscountFactor)
    msg = "The discount factors must represent two cotinguous spans of time."
    (x.enddate == y.enddate || y.startdate == x.enddate) || throw(
        ArgumentError(msg))
    DiscountFactor(value(x) * value(y), min(x.startdate, y.startdate),
        max(x.enddate, y.enddate))
end
function Base.:/(x::DiscountFactor, y::DiscountFactor)
    msg = "The discount factors must start at the same instant."
    (x.startdate == y.startdate) || throw(ArgumentError(msg))
    DiscountFactor(value(x) / value(y), min(x.enddate, y.enddate),
        max(x.enddate, y.enddate))
end

# comparison operations
for op in (:(==), :!=, :<, :<=, :>, :>=)
    @eval begin
        function Base.$op(x::InterestRate, y::InterestRate)
            return Base.$op(value(x), value(equivalent(x, y)))
        end
        Base.$op(x::DiscountFactor, y::DiscountFactor) = Base.$op(value(x), value(y))
    end
end
