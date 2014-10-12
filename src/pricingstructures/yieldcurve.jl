###############################################################################
# Types
###############################################################################

type YieldCurve <: PricingStructure
    currency::Currency
    referencedate::TimeType
    interpolation::InterpolationScheme
    extrapolation::ExtrapolationScheme
    instruments::Vector{Instrument}
end

type ZeroCurve <: PricingStructure
    currency::Currency
    referencedate::TimeType
    interpolation::InterpolationScheme
    extrapolation::ExtrapolationScheme
    zerorates::Vector{InterestRate}
end


###############################################################################
# Methods
###############################################################################

