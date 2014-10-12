Cash flows
===============================================================================

Introduction
-------------------------------------------------------------------------------

Financial market contracts are essentially a set of (possibly state space contingent) cash flows. The pricing and valuation of financial market contracts relies on the ability to net present value a stream of cash flows. For example, bonds are a stream of regularly paid cash flows and are valued by calculating the net present value of these cash flows using an appropriate term structure of interest rates.

Details
-------------------------------------------------------------------------------

``FinancialMarkets.jl`` provides a mutable composite ``CashFlow`` type that represents the dates, amounts and currencies of a set of cash flows::

    using Dates, FinancialMarkets
    CashFlow([AUD(), AUD()], [Date(2014, 1, 1), Date(2014, 4, 1)], [1000, 1000])

A ``CashFlow`` can be elegantly coerced to a ``DataFrame`` as you may have inferred from executing the last expression. A CashFlow with mixed currencies is possible::

    CashFlow([AUD(), USD()], [Date(2014, 1,1), Date(2014,2,1)], [100, 100])

Interface
-------------------------------------------------------------------------------

.. function:: CashFlow(currency::Vector{Currency}, date::Vector{TimeType}, amount::Vector{Real}) -> CashFlow

    This is the CashFlow type's inner constructor. The inner constructor simply checks that the length of each of the arguments is the same. Note that since Julia's type parameters are invariant, this method will only work where ``currency`` is contains more than one type of currency (the vector will be promoted to a ``Vector{Currency}``).

.. function:: CashFlow(currency::Currency, date::TimeType, amount::Real) -> Cashflow

    This allows for the quick creation of ``CashFlow`` with one cash flow. It simply turns the arguments into length one vectors and calls the default constructor.

.. function:: CashFlow{C<:Currency, T<:TimeType, R<:Real}(currency::Vector{C}, date::Vector{T}, amount::Vector{R}) -> CashFlow

    This allows for the construction of ``CashFlow`` where the ``currency`` field contains only one type of currency.

.. function:: DataFrame(cf::CashFlow) -> DataFrame

    This creates a ``DataFrame`` representation of a ``CashFlow``. It is used to nicely present a ``CashFlow`` instance in the REPL.
