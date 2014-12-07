###############################################################################
# Types
###############################################################################

type YieldCurve <: PricingStructure
    currency::Currency
    referencedate::TimeType
    instruments::Vector{Instrument}
end

type ZeroCurve <: PricingStructure
    currency::Currency
    referencedate::TimeType
    interpolator::Interpolators
    zerorates::Vector{InterestRate}
end


###############################################################################
# Methods
###############################################################################

