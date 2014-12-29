Interest rates
===============================================================================

Introduction
-------------------------------------------------------------------------------

The value dynamics of almost all financial derivatives depends on interest rates and their corollary, discount factors. They signify the utility of consuming one unit of currency today over consuming one unit currency at some future time. The higher the interest rate, the lower the discount factor and the greater (in absolute terms) the present value applied to that future unit of currency.

``FinancialMarkets.jl`` makes it easy to work with interest rates::

    using Dates, FinancialMarkets
    r = InterestRate(0.04, Simply, A365())
    df = DiscountFactor(0.95, Date(2014, 1, 1), Date(2015, 1, 1))

Types
-------------------------------------------------------------------------------

Interest rates and discount factors are represented by the two mutable composite types, ``InterestRate`` and ``DiscountFactor``.

The ``InterestRate`` type consists of three fields (``rate``, ``compounding`` and ``daycount``) and an inner constructor that simply enforces the validity of the compounding field.

The ``DiscountFactor`` type consists of three fields (``discountfactor``, ``startdate`` and ``enddate``) and an inner constructor that simply enforces that that the ``startdate`` occur on or before the ``endddate``.


Conversions
-------------------------------------------------------------------------------

Converting between ``InterestRate`` and ``DiscountFactor`` is one of the most commonly performed operations in financial mathermatics. For example, the price a bank-bill style deposit is the discounted value of the notional at the market rate::

    # Bill rate 5%, notional $1, price ...
    DiscountFactor(r, today(), today() + Month(3))

Alternatively, you may wish to imply the market rate from a bank-bill style deposit::

    # Price $0.90, notional $1, market rate ...
    df = DiscountFactor(0.995, today(), today() + Month(3))
    InterestRate(df, Simply, A365())

You can also convert an interest rate from one compounding or day count basis to another::

    # From A/365 to 30/360
    InterestRate(r, Thirty360())
    # From Simply to Continuously compounded
    InterestRate(r, Continuously)
    # From Simply, A/365 to Continously, 30/360
    InterestRate(r, Continuously, Thirty360())


Arithmetic
-------------------------------------------------------------------------------

You can perform basic (and intuitive) arithmetic on interest rate types::

    # Arithmetic with InterestRate/Reals
    r - 0.01
    0.01 + r
    2r
    r / 2
    # Auto conversion of second rate to the first's compounding & day count
    r + InterestRate(0.01, SemiAnnually, A360())

However, the scope of discount factor arithmetic, while no less intuitive, is necessarily more limited (e.g. does it make sense to add two discount factors?)::

    # Discount factors must span continguous time periods for multiplication
    # to be valid:
    df * DiscountFactor(0.99, today() + Month(3), today() + Month(6))
    # Error:
    df * DiscountFactor(0.99, today() + Month(2), today() + Month(5))
    # Conversely, discount factors must start at the same time instant for
    # division to be valid:
    df / DiscountFactor(0.997, today(), today() + Month(1))


Comparison
-------------------------------------------------------------------------------

The basic comparison (``==``, ``!=``, ``<``, ``<=``, ``>``, ``>=``) operations are available for interest rates and discount factors. Interest rates are converted to have the same compounding and day basis conventions before the comparison is performed, while the comparsion of discount factor occurs on their values only::

    r == r
    r > InterestRate(0.03, Continuously, Thirty360())
    df <= DiscountFactor(0.90, today(), today() + Year(10))


Interface
-------------------------------------------------------------------------------

.. function:: InterestRate(r::Real, cmp::Compounding, dc::DayCountFraction) -> InterestRate

    The inner constructor for the ``InterestRate`` type. See the description above.

.. function:: DiscountFactor(df::DiscountFactor, dt1::TimeType, dt2::TimeType) -> DiscountFactor

    The inner constructor for the ``DiscountFactor`` type. See the description above.

.. function:: DiscountFactor(r::InterestRate, dt1::TimeType, dt2::TimeType) -> DiscountFactor

    Convert an interest rate ``r`` to a ``DiscountFactor`` type spanning the time period starting at ``dt1`` and ending at ``dt2``.

.. function:: InterestRate(df::DiscountFactor, cmp::Compounding, dc::DayCountFraction) -> InterestRate

    Convert a discount factor ``df`` to an ``InterestRate`` with compounding frequency ``cmp`` and day count convention ``dc``.

.. function:: InterestRate(r::InterestRate, cmp::Compounding) -> InterestRate

    Convert an interest rate with one compounding frequency ``r.compounding`` to another compounding frequency ``cmp``.

.. function:: InterestRate(r::InterestRate, dc::DayCountFraction) -> InterestRate

    Convert an interest rate with one day count convention ``r.daycount`` to another day count convention ``dc``.

.. function:: InterestRate(r::InterestRate, cmp::Compounding, dc::DayCountFraction) -> InterestRate

    Convert an interest rate with one compounding frequency ``r.compounding`` and day count convention ``r.daycount`` to another compounding frequency ``cmp`` and day count convention ``dc``.

.. function:: +(x::InterestRate, y::Real) -> InterestRate
              *(x::InterestRate, y::Real) -> InterestRate
              -(x::InterestRate, y::Real) -> InterestRate
              /(x::InterestRate, y::Real) -> InterestRate
              +(x::InterestRate, y::InterestRate) -> InterestRate
              *(x::InterestRate, y::InterestRate) -> InterestRate
              -(x::InterestRate, y::InterestRate) -> InterestRate
              /(x::InterestRate, y::InterestRate) -> InterestRate
              +(x::Real, y::InterestRate) -> InterestRate
              -(x::Real, y::InterestRate) -> InterestRate
              *(x::Real, y::InterestRate) -> InterestRate
              /(x::Real, y::InterestRate) -> InterestRate

    ``InterestRate`` arithmetic. Conversion is performed to ensure ``x`` and ``y`` are on the same basis before arithmetic is performed.

.. function:: *(x::DiscountFactor, y::DiscountFactor) -> DiscountFactor
              /(x::DiscountFactor, y::DiscountFactor) -> DiscountFactor

    ``DiscountFactor`` arithmetic. Multiplied discount factors must span continguous regions while divided discount factors must start at the same time instant.

.. function:: ==(x::InterestRate, y::InterestRate) -> Boolean
              !=(x::InterestRate, y::InterestRate) -> Boolean
              <(x::InterestRate, y::InterestRate) -> Boolean
              <=(x::InterestRate, y::InterestRate) -> Boolean
              >(x::InterestRate, y::InterestRate) -> Boolean
              >=(x::InterestRate, y::InterestRate) -> Boolean

    Comparison of two ``InterestRate`` objects. Conversion is performed to ensure ``x`` and ``y`` are on the same basis before they are compared on the ``rate`` fields.

.. function:: ==(x::DiscountFactor, y::DiscountFactor) -> Boolean
              !=(x::DiscountFactor, y::DiscountFactor) -> Boolean
              <(x::DiscountFactor, y::DiscountFactor) -> Boolean
              <=(x::DiscountFactor, y::DiscountFactor) -> Boolean
              >(x::DiscountFactor, y::DiscountFactor) -> Boolean
              >=(x::DiscountFactor, y::DiscountFactor) -> Boolean

    Comparison of two ``DiscountFactor`` objects by comparing the ``discountfactor`` fields.
