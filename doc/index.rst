FinMarkets.jl overview
=====

FinMarkets.jl will help you describe and model financial market objects in
Julia.

For example, you can describe a 3 month USD LIBOR deposit::

    using Dates, FinMarkets
    Deposit(USD(), Month(3), 0.05)

Pricing this deposit at its trade date is easy::

    price(Deposit(USD(), Month(3), 0.05))

