####
# Constants
####

const COMPOUNDERS = [0 => "simply", 1 => "annually", 2 => "semi-annually",
    3 => "tri-annually", 4 => "quarterly", 6 => "bi-monthly", 12 => "monthly",
    24 => "fornightly", 52 => "weekly", 365 => "daily", 1000 => "continuously"]

####
# Types
####

type InterestRate
    rate::Real
    compounding::Int
    daycount::DayCountFraction
    function InterestRate(rate, compounding, daycount)
        haskey(COMPOUNDERS, compounding) || error("Invalid compounding.")
        new(rate, compounding, daycount)
    end
end


type DiscountFactor
    df::Real
    startdate::TimeType
    enddate::TimeType
    function DiscountFactor(df, startdate, enddate)
        startdate <= enddate || error("Start occurs after the end date.")
        new(df, startdate, enddate)
    end
end


####
# Methods
####

