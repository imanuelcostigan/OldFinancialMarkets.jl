Instruments
===============================================================================

Introduction
-------------------------------------------------------------------------------

And it is here that we arrive at the core piece of the ``FinMarkets.jl`` puzzle. What are we interested in? We are describing and modelling financial market objects of which financial market instruments play a leading role.

Financial instruments refers to a transaction whose financial instrumentation is set out in a legal document. For example, the financial instrumentation includes effective and termination dates, descriptions of how the payment dates are to be determined, any interest rates or indicies that are used to determine cash flows and if and when notional amounts are exchanged.

Currently the following list of instruments are supported by ``FinMarkets.jl``:

1. ``Cash``: overnight deposits usually with central banks.
2. ``Deposit``: term deposits usually with inter-bank counterparties.
3. ``STIRFuture``: futures contracts on forward starting term deposits.

Each of these is represented as a composite type that extends the ``Instrument`` abstract type and have convenient constructors which load currency based conventions.

Currently it is only possible to ``price`` these instruments and determine their ``CashFlow`` profile.

Cash
-------------------------------------------------------------------------------

Here's how you can create and model a ``Cash`` instrument::

    using Dates, FinMarkets
    audcash = Cash(AUD(), 0.04, Date(2014, 9, 26), 1e6)
    price(audcash)
    CashFlow(audcash)

Notice that the underlying index is based on conventions associated with the AUD overnight cash market.

Deposit
-------------------------------------------------------------------------------

Here's how you can create and model a ``Deposit`` instrument::

    usddepo = Deposit(USD(), Month(3), 0.04, Date(2014, 9, 26), 1e6)
    price(usddepo)
    CashFlow(usddepo)

Notice that the underlying index is based on conventions associated with the USD money market.

STIRFuture
-------------------------------------------------------------------------------

Here's how you can create and model a ``STIRFuture`` instrument::

    # Third nearest futures contract from trade date
    eurstir = STIRFuture(EUR(), 3, 96, Date(2014, 9, 26), 1)
    price(eurstir)
    CashFlow(eurstir)

The conventions used for the EUR money market futures are those specified by EUREX for the EUIBOR futures contract.

Interface
-------------------------------------------------------------------------------

.. function:: Cash(currency::Currency, rate::Real, tradedate::TimeType = EVAL_DATE, amount::Real = 1e6) -> Cash

    Creates a ``Cash`` object where the ``currency`` determines the ``ONIA`` index created, the ``startdate`` is set equal to the ``tradedate`` and the ``enddate`` is equal to one good day after the ``tradedate`` using the ``index`` calendar.

.. function:: Deposit(currency::Currency, term::Period, rate::Real, tradedate::TimeType = EVAL_DATE, amount::Real = 1e6) -> Deposit

    Creates a ``Deposit`` object where the ``currency`` determines the ``IBOR`` index created, the ``startdate`` is equal to the ``tradedate`` offset by the the ``spotlag`` of the ``index`` and the ``enddate`` is equal to the first good day on or after the ``startdate`` shifted by the ``term`` of the deposit using the ``index`` calendar.

.. function:: STIRFuture(ccy::Currency, prompt::Integer, price::Real, tradedate::TimeType = EVAL_DATE, amount::Real = 1) -> STIRFuture

    Creates a ``STIRFuture`` object where the ``currency`` determines the underlying ``Deposit`` (and its ``IBOR``). Note that JPY STIRFutures are written on ``TIBOR`` and not ``JPYLIBOR``. The underlying deposit's ``term`` is 90 days if the ``currency`` is ``AUD`` or ``NZD`` and 3 months otherwise. The underlying deposit's start and end date are determined by the ``prompt`` (nth nearest contract) and market specific future contract conventions which can be found on the futures' exchange websites.
