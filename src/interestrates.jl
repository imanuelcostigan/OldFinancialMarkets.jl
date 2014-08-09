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

