Day count conventions
===============================================================================

Introduction
-------------------------------------------------------------------------------

The calculation of lengths of times between financial events is one of the most basic elements of financial mathematics. For example, the interest earned on money lent will depend on the length of time over which it has been lent out. A number of different day count conventions have been developed and documented (e.g. ISDA 2006 definitions). Generally speaking each convention consists of two components: first, a rule that defines how days are counted (hence **day count** convention); and second, a rule that defines the number of days in a year. For example, 30/360 day count conventions (yes, there are a few different types) count each month to consist of 30 days and each year to consist of 360 days.

Each of the day count conventions that are supported by FinMarkets.jl are documented extensively in the `OpenGamma Interest Rate Instruments and Market Conventions Guide (Edition 2.0)`_.

Supported conventions
-------------------------------------------------------------------------------

FinMarkets supports six of the main day count conventions: Actual/365 Fixed, Actual/360, Actual/Actual (ISDA), 30/360, 30E/360 and 30E+/360. These are defined as immutable subtypes of the abstract ``DayCountFraction`` type.

================  ============
Type name         OG section
================  ============
``A365``           3.8
``A360``           3.7
``ActActISDA``     3.12
``Thirty360``      3.3
``ThirtyE360``     3.4
``ThirtyEP360``    3.6
================  ============


Time calculations
-------------------------------------------------------------------------------

The ``years`` method will let you calculate the times (in years) between two dates according to the day count convention you specify. For example::

    d1 = Date(2014, 1, 1)
    d2 = Date(2015, 1, 1)
    years(d1, d2, A365()) # 1.0
    years(d1, d2, A360()) # 365/360

Interface documentation
-------------------------------------------------------------------------------

.. function:: ThirtyEP360() -> ThirtyEP360

   Construct a ``ThirtyEP360`` type.

.. function:: A365() -> A365

   Construct an ``A365`` type.

.. function:: A360() -> A360

   Construct an ``A360`` type.

.. function:: ActActISDA() -> ActActISDA

   Construct an ``ActActISDA`` type.

.. function:: Thirty360() -> Thirty360

   Construct a ``Thirty360`` type.

.. function:: ThirtyE360() -> ThirtyE360

   Construct a ``ThirtyE360`` type.

.. function:: ThirtyEP360() -> ThirtyEP360

   Construct a ``ThirtyEP360`` type.

.. function:: years(date1::TimeType, date2::TimeType, dc::A365) -> Real
              years(date1::TimeType, date2::TimeType, dc::A360) -> Real
              years(date1::TimeType, date2::TimeType, dc::ActActISDA) -> Real
              years(date1::TimeType, date2::TimeType, dc::Thirty360) -> Real
              years(date1::TimeType, date2::TimeType, dc::ThirtyE360) -> Real
              years(date1::TimeType, date2::TimeType, dc::ThirtyEP360) -> Real

   Calculate the time in years between ``date1`` and ``date2`` using the ``dc`` day count convention.

.. _OpenGamma Interest Rate Instruments and Market Conventions Guide (Edition 2.0): http://developers.opengamma.com/quantitative-research/Interest-Rate-Instruments-and-Market-Conventions.pdf
