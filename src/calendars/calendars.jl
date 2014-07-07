function isweekend(d::Date)
    dayofweek(d) == Saturday || dayofweek(d) == Sunday
end

function isnewyearsday(d::Date)
    month(d) == January && day(d) == 1
end

function isnewyearsday(d::Date, substitutedays::Array{Int})
    isnyd = isnewyearsday(d)
    isnyd || (dayofweek(d) == Monday &&
        ((day(d) == 2 && Sunday in substitutedays) ||
            (day(d) == 3 && Saturday in substitutedays)))
end
