Indices
===============================================================================

Introduction
-------------------------------------------------------------------------------

Many financial derivatives' cash flows are referenced or fixed to well-defined, and occasionally infamous indices. For example, the London Inter-Bank Offer Rate (`LIBOR`_) and the WM/Reuters spot FX rates are used to determine (a.k.a. fix) cash flows on **trillions** of dollars worth of notional derivative exposures.

FinMarkets.jl represents indices as a set of conventions which define how they are to be used. The abstract supertype ``Index`` is extended according to the type of index.

Interest rate indices
-------------------------------------------------------------------------------

The abstract ``InterestRateIndex`` type extends ``Index`` and is the superset of all interest rate related indices. Two immutable types of interest rate indices are currently implemented: the ``ONIA`` and the ``IBOR`` indices.

The ``ONIA`` type represents overnight interest rate indices such as the Fed Fund or EONIA (European OverNight Index Average). These are typically used to fix cash flows on overnight indexed swaps. The ``ONIA`` type is parameterised by ``Currency`` as each currency has its own canonical overnight rate fix. The following overnight indices are currently supported.

=========  ========  =====================  ===============  ===========
Currency   Index     Calendar               Day Convention   Day Count
=========  ========  =====================  ===============  ===========
AUD        AONIA     Sydney & Melbourne     Following        A365
EUR        EONIA     TARGET                 Following        A360
GBP        SONIA     London                 Following        A365
JPY        TONAR     Tokyo                  Following        A365
NZD        NZIONA    Auckland, Wellington   Following        A365
USD        FedFund   New York               Following        A360
=========  ========  =====================  ===============  ===========

NB: the names in the Index column are also aliases to ``ONIA`` types parameterised by the corresponding currency (e.g. ``AONIA`` is the type alias of ``ONIA{AUD}``).

The ``IBOR`` type represents interbank offer rates on deposits (or bank bills). Some of these are based on hypothetical transactions (e.g. LIBOR), whereas some are based on transactions occuring over a certain short time window every business day (e.g. AUD BBSW). The ``IBOR`` type is parameterised by ``Currency`` as each currency has one canonical index. However, some currencies have more than one commonly used IBOR-like index (e.g. EUR LIBOR / EURIBOR & JPY LIBOR / TIBOR). In these cases, special constructors are provided (and are detailed below). The following IBOR indices are currently supported:

=========  ============
Currency   Index
=========  ============
AUD        AUDBBSW
EUR        EURIBOR
EUR        EURLIBOR
GBP        JPYLIBOR
JPY        JPYTIBOR
NZD        NZDBKBM
USD        USDLIBOR
=========  ============

The conventions associated with these IBOR indices is detailed in their convenience constructors as the conventions are functions of a number of things.

NB: the names in the Index column are also aliases to ``IBOR`` types parameterised by the corresponding currency (e.g. ``AUDBBSW`` is the type alias of ``IBOR{AUD}``).

You can find more infomation on the conventions associated with any of these indices in [ogconventions]_.

Interface
-------------------------------------------------------------------------------

.. function:: ONIA{CCY<:Currency}(currency::CCY, calendar::JointFCalendar, bdc::BusinessDayConvention, daycount::DayCountFraction) -> ONIA
              ONIA(::AUD) -> ONIA{AUD} (AONIA)
              ONIA(::EUR) -> ONIA{EUR} (EONIA)
              ONIA(::GBP) -> ONIA{GBP} (SONIA)
              ONIA(::JPY) -> ONIA{JPY} (TONAR)
              ONIA(::NZD) -> ONIA{NZD} (NZIONA)
              ONIA(::USD) -> ONIA{USD} (FedFund)
              AONIA() -> AONIA
              EONIA() -> EONIA
              SONIA() -> SONIA
              TONAR() -> TONAR
              NZIONA() -> NZIONA
              FedFund() -> FedFund

    Various ONIA type construction methods. The key conventions used for specific constructors are outlined above.

.. function:: IBOR{CCY<:Currency}(currency::CCY, spotlag::Period, tenor::Period, calendar::JointFCalendar, bdc::BusinessDayConvention, eom::Bool, daycount::DayCountFraction) -> IBOR

    The default parameterised constructor of ``IBOR`` types.

.. function:: IBOR(::AUD, tenor::Period) -> IBOR{AUD}

    A convenient constructor of AUD BBSW. The spot lag is assumed to be 1 good day (GD) in ``AUSYFCalendar`` and is adjusted according to the ``Succeeding`` convention while the end-of-month convention is not observed. The ``A365`` day count convention holds.

.. function:: IBOR(::EUR, tenor::Period, libor = false) -> IBOR{EUR}

    A convenient constructor of EURIBOR (``libor = false``) and EUR LIBOR (``libor = true``).

    EURIBOR has a spot lag of 2 GDs in ``EUTAFCalendar`` and is adjusted according to the ``ModifiedFollowing`` convention. EUR LIBOR has a spot lag of 2 GDs in ``GBLOFCalendar`` (or 0 GDs when the ``tenor`` is less than one month) and is adjusted using the ``ModifiedFollowing`` convention (or ``Following`` when the ``tenor`` is less than one month). The end-of-month convention is observed and the ``A360`` day count convention holds.

    Ideally EURIBOR and EUR LIBOR would be different types. One way to effect this is to parameterise ``IBOR`` by something like ``Agent`` where ``Agent`` is a type representing the calculation agent / fixing panel. However, this would add extra complexity at this point. Perhaps something to come back to later on.

.. function:: IBOR(::GBP, tenor::Period) -> IBOR{GBP}

    A convenient constructor of GBP LIBOR.

    The spot lag is 2 GDs in ``GBLOFCalendar`` and is adjusted using the ``ModifiedFollowing`` convention when the ``tenor`` is no less than one month. Conversely, the spot lag is 0 GDs and is adjusted using the ``Following`` convention when the ``tenor is less than one month. The end-of-month convention is observed and the ``A365`` day count convention applies.

.. function:: IBOR(::JPY, tenor::Period, libor = true) -> IBOR{JPY}

    A convenient constructor of JPY LIBOR (``libor = true``) and TIBOR (``libor = false``).

    In either case, if the ``tenor`` is less than one month, the spot lag is 0 GDs and subject to adjustment using the ``Following`` convention, otherwise, the spot lag is 2 GDs and subject to the ``ModifiedFollowing`` convention. Both assume an ``A360`` day count convention. However, JPY LIBOR is fixed on ``GBLOFCalendar`` good days and the end-of-month convention holds, while TIBOR is fixed on ``JPTOFCalendar`` good days and the end-of-month convention does not hold.

    Ideally JPY LIBOR and TIBOR would be different types. See the EURIBOR/EUR LIBOR discussion above.

.. function:: IBOR(::NZD, tenor::Period) -> IBOR{NZD}

    A convenient constructor of NZD BKBM. The ``tenor`` must be no less than one month.

    The spot lag is 0 GDs in ``NZAUFCalendar`` & ``NZWEFCalendar`` and is adjusted according to the ``ModifiedFollowing`` convention while the end-of-month convention does not apply. The ``A365`` day convention holds.

.. function:: IBOR(::USD, tenor::Period) -> IBOR{USD}

    A convenient constructor of USD LIBOR.

    The spot lag is 2 GDs in ``GBLOFCalendar`` and is adjusted using the ``ModifiedFollowing`` convention when the ``tenor`` is no less than one month. Conversely, the spot lag is 0 GDs and is adjusted using the ``Following`` convention when the ``tenor`` is less than one month. When the ``tenor`` is one day, good days are those in ``GBLOFCalendar`` and ``USNYFCalendar``. The end-of-month convention is observed and the ``A360`` day count convention applies.

.. function:: AUDBBSW(tenor) -> AUDBBSW (IBOR{AUD})
              EURIBOR(tenor) -> EURIBOR (IBOR{EUR})
              EURLIBOR(tenor) -> EURIBOR (IBOR{EUR})
              GBPLIBOR(tenor) -> GBPLIBOR (IBOR{GBP})
              JPYLIBOR(tenor) -> JPYLIBOR (IBOR{JPY})
              JPYTIBOR(tenor) -> JPYTIBOR (IBOR{JPY})
              NZDBKBM(tenor) -> NZDBKBM (IBOR{NZD})
              USDLIBOR(tenor) -> USDLIBOR (IBOR{USD})

    A set of very convenient IBOR constructors. Note ``AUDBBSW`` is a type alias for ``IBOR{AUD}`` etc.

.. _LIBOR: https://www.theice.com/iba/libor

