--Syntax

SELECT (what fields u want, * if you want everything) (column + column AS derived_column)
FROM (what table to reference)
WHERE (condition, uses symbols suck as >, <, >=, != )
ORDER BY (temporarily sort) DESC (to differ from default ascending)
LIMIT (first X rows)

--Logical Operators

LIKE ( WHERE url LIKE '%google%', gives approximations instead of =)
IN (filter based on several possible values) (WHERE name IN ('Store1', 'Store2))
NOT (excludes, self-explanatory)
AND & BETWEEN (WHERE std > 100 AND poster = 0 AND gloss = 0) (WHERE std BETWEEN 24 AND 29)
OR

--Joins

Tells query additonal table from which to pull data
