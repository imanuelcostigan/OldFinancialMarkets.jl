daysinyear(year::Int) = isleap(year) ? Day(366) : Day(365)
isweekend(d::Date) = dayofweek(d) == Saturday || dayofweek(d) == Sunday
isnewyears(d::Date) =  month(d) == January && day(d) == 1

function isnewyears(d::Date, substitutedays::Array{Int})
    isnewyears(d) || (dayofweek(d) == Monday &&
        ((day(d) == 2 && Sunday in substitutedays) ||
            (day(d) == 3 && Saturday in substitutedays)))
end
