Financial calendars
===============================================================================

Introduction
-------------------------------------------------------------------------------

In an earlier section, I explained why calculating the length of time between financial events was important to financial mathematics. In this section, I will describe how the dates of those financial events are a function of time periods interacting with financial calendars.

Motivation
-------------------------------------------------------------------------------

Most financial market contracts have a termination date at which all obligations amongst the financially interested parties are extinguished. These termination dates are typically defined as occuring a certain time period after the effective date of the contract.

For example, a deposit's termination date may occur three months after the deposit's effective date. At the deposit's effective date, the capital amount is transferred between the counterparties and at the termination date the capital amount is returned with interest. If the 3 month (3m) deposit's effective date were the 25th of September, then it's termination date would be the 25th of December. However, notice that the 25th of December is Christmas Day. Banks are typically closed for business in most financial centres on Christmas Day and as a consequence the termination date must be adjusted.

In general, financial events must occur on *good days* as defined by the applicable *financial calendar*. If the calculated date of a financial event is not a good day in the applicable financial centre, then it must be *adjusted* by a *business day convention*.


Financial calendars
-------------------------------------------------------------------------------

*Good days* are those for which banks are open and able to settle transactions in a given financial centre. Generally speaking, all days are good excepting weekends, generally observed public holidays (e.g. Christmas day) or those applying specifically to banks (e.g. a bank holiday). As a consequence, good days are tied to a financial centre's location (New York, London, Sydney etc) which defines a *financial calendar*.

FinancialMarkets.jl implements financial calendars as subtypes of the abstract ``SingleFCalendar`` abstract type which is itself a subtype of the abstract ``FinCalendar`` type.

Additionally, the concrete ``JointFCalendar`` subtype of ``FinCalendar`` represents a vector of ``SingleFCalendar`` instances (the ``calendars`` field) and flags whether the calendars are joined by on the intersection of good or bad days (the ``onbad`` boolean typed field).

A number of commonly used locale-specific ``SingleFCalendar`` subtypes are defined by FinancialMarkets.jl.

=====================   =====================  ==========  ======================
Name                    Locale                 Concrete    Supertype
=====================   =====================  ==========  ======================
``AUFCalendar``         Australia              ``false``   ``SingleFCalendar``
``AUSYFCalendar``       Sydney/Australia       ``true``    ``AUFCalendar``
``AUMEFCalendar``       Melbourne/Australia    ``true``    ``AUFCalendar``
``EUFCalendar``         Europe                 ``false``   ``SingleFCalendar``
``EUTAFCalendar``       TARGET                 ``true``    ``EUFCalendar``
``EULIBORFCalendar``    EUR LIBOR              ``true``    ``EUFCalendar``
``GBFCalendar``         Great Britain          ``false``   ``SingleFCalendar``
``GBLOFCalendar``       London/GB              ``true``    ``GBFCalendar``
``JPFCalendar``         Japan                  ``false``   ``SingleFCalendar``
``JPTOFCalendar``       Tokyo/Japan            ``true``    ``JPFCalendar``
``NZFCalendar``         New Zealand            ``false``   ``SingleFCalendar``
``NZAUFCalendar``       Auckland/NZ            ``true``    ``NZFCalendar``
``NZWEFCalendar``       Wellington/NZ          ``true``    ``NZFCalendar``
``USFCalendar``         United States          ``false``   ``SingleFCalendar``
``USNYFCalendar``       New York/US            ``true``    ``USFCalendar``
``USLIBORFCalendar``    US LIBOR               ``true``    ``USFCalendar``
=====================   =====================  ==========  ======================

Good day methods have been implemented for these financial calendar types and for joint calendars::

    using Dates, FinancialMarkets
    # NSW Labour Day
    d1 = Date(2014,10,6)
    # No calendars => all weekdays are good; weekends bad
    isgood(d1)
    # Sydney calendar
    isgood(d1, AUSYFCalendar())
    # Sydney, Melbourne calendar joined on bad days
    isgood(d1, +(AUSYFCalendar(), AUMEFCalendar()))
    # Sydney, Melbourne calendar joined on good days
    isgood(d1, *(AUSYFCalendar(), AUMEFCalendar()))


Business day conventions
-------------------------------------------------------------------------------

Where a date falls on a bad day (i.e. one that is not a good day), it is adjusted to a good day using a business day convention. These are defined in glorious legalise in the 2006 ISDA definitions and interpreted well into plain English elswhere [ogconventions]_ and won't be detailed again here.

FinancialMarkets.jl implements these business day conventions as immutable subtypes of the abstract ``BusinessDayConvention`` type. These conventions include: ``Unadjusted``, ``Preceding``, ``ModifiedPreceding``, ``Following``, ``ModifiedFollowing`` and ``Succeeding``.

Bad day can be adjusted using ``adjust`` methods using these business day conventions::

    # Christmas Day
    d2 = Date(2014,12,25)
    adjust(d2, Unadjusted(), AUSYFCalendar())
    adjust(d2, Following(), AUSYFCalendar())

Interface
-------------------------------------------------------------------------------

.. function:: NoFCalendar() -> NoFCalendar

    Constructs a ``NoFCalendar`` type, a sub-type of ``SingleFCalendar``.

.. function:: AUMEFCalendar() -> AUMEFCalendar

    Constructs a ``AUMEFCalendar`` type, a sub-type of ``AUFCalendar``.

.. function:: AUSYFCalendar() -> AUSYFCalendar

    Constructs a ``AUSYFCalendar`` type, a sub-type of ``AUFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: AUSYFCalendar() -> AUSYFCalendar

    Constructs a ``AUSYFCalendar`` type, a sub-type of ``AUFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: EUTAFCalendar() -> EUTAFCalendar

    Constructs a ``EUTAFCalendar`` type, a sub-type of ``EUFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: EULIBORFCalendar() -> EULIBORFCalendar

    Constructs a ``EULIBORFCalendar`` type, a sub-type of ``EUFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: GBLOFCalendar() -> GBLOFCalendar

    Constructs a ``GBLOFCalendar`` type, a sub-type of ``GBFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: JPTOFCalendar() -> JPFCalendar

    Constructs a ``JPTOFCalendar`` type, a sub-type of ``JPFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: NZAUFCalendar() -> NZAUFCalendar

    Constructs a ``NZAUFCalendar`` type, a sub-type of ``NZFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: NZWEFCalendar() -> NZWEFCalendar

    Constructs a ``NZWEFCalendar`` type, a sub-type of ``NZFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: USNYFCalendar() -> USNYFCalendar

    Constructs a ``USNYFCalendar`` type, a sub-type of ``USFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: USLIBORFCalendar() -> USLIBORFCalendar

    Constructs a ``USLIBORFCalendar`` type, a sub-type of ``USFCalendar`` which is a subtype of ``SingleFCalendar``.

.. function:: JointFCalendar(calendars::Vector{SingleFCalendar}, onbad::Bool) -> JointFCalendar

    Construct a ``JointFCalendar`` type. If ``onbad`` is ``true`` then the joint calendar's bad days are the union of the bad days of its constituent calendars. Otherwise, a calendar's bad days are the intersection of the bad days of its constituent calendars. ``JointFCalendar`` is a subtype of ``FCalendar``

.. function:: +(c1::SingleFCalendar, c2::SingleFCalendar) -> JointFCalendar

    Equivalent to calling ``JointFCalendar([c1, c2], true)``

.. function:: *(c1::SingleFCalendar, c2::SingleFCalendar) -> JointFCalendar

    Equivalent to calling ``JointFCalendar([c1, c2], false)``

.. function:: +(jc::JointFCalendar, c::SingleFCalendar) -> JointFCalendar

    Equivalent to calling ``JointFCalendar([jc.calendars, c],
    jc.onbad)``

.. function:: convert(::Type{JointFCalendar}, c::SingleFCalendar) -> JointFCalendar

    Equivalent to ``JointFCalendar(c)``

.. function:: isweekend(dt::TimeType) -> Boolean

    Returns ``true`` if ``dt`` is on a weekend and vice-versa.

.. function:: isgood(dt::TimeType, c::NoFCalendar = NoFCalendar()) -> Boolean
              isgood(dt::TimeType, c::AUMEFCalendar) -> Boolean
              isgood(dt::TimeType, c::AUSYFCalendar) -> Boolean
              isgood(dt::TimeType, c::EUTAFCalendar) -> Boolean
              isgood(dt::TimeType, c::EULIBORFCalendar) -> Boolean
              isgood(dt::TimeType, c::GBFCalendar) -> Boolean
              isgood(dt::TimeType, c::JPFCalendar) -> Boolean
              isgood(dt::TimeType, c::NZAUFCalendar) -> Boolean
              isgood(dt::TimeType, c::NZWEFCalendar) -> Boolean
              isgood(dt::TimeType, c::USFCalendar) -> Boolean
              isgood(dt::TimeType, c::USLIBORFCalendar) -> Boolean

    Returns ``true`` if ``dt`` is good day in ``c``. This is ``true`` only if ``dt`` does not fall on a weekend (where ``c`` is ``NoFCalendar``) or a weekend or public holiday.

.. function:: isgood(dt::TimeType, c::JointFCalendar) -> Boolean

    Returns ``true`` if ``dt`` is good in ``c`` where ``c.onbad`` determines how to check across each of the calendars in the joint calendar. If ``c.onbad`` is ``true`` then ``dt`` must be good in each of the financial calendars making up ``c`` and vice-versa.
