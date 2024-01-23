--Syntax

SELECT --(what fields u want, * if you want everything) (column + column AS derived_column)
FROM --(what table to reference)
WHERE --(condition, uses symbols suck as >, <, >=, != )
GROUP BY --(aggregate data within subsets, such as grouping by account or location)
ORDER BY --(temporarily sort) DESC (to differ from default ascending)
LIMIT --(first X rows)

--Logical Operators

LIKE --( WHERE url LIKE '%google%', gives approximations instead of =)
IN --(filter based on several possible values) (WHERE name IN ('Store1', 'store2')
NOT --(excludes, self-explanatory)
AND & BETWEEN --(WHERE std > 100 AND poster = 0 AND gloss = 0) (WHERE std BETWEEN 24 AND 29)
OR

--Joins; tells query additonal table from which to pull data

SELECT orders.* --(orders.* gives all columns of the orders table)
FROM orders
JOIN accounts --(second table)
ON orders.account_id = accounts.id; --specifies column on which to merge the two tables

--Try pulling all the data from the accounts table, and all the data from the orders table.

SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id

--Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.

SELECT orders.standard_qty, orders.gloss_qty, 
          orders.poster_qty,  accounts.website, 
          accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

--Join web_events, accounts, and orders tables

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id --Joins accounts to web_events
JOIN orders
ON accounts.id = orders.account_id --Joins orders to accounts

--Alias

FROM tablename t1
JOIN tablename2 t2

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2 --returns aliasname and aliasname2 instead of t1 t2


--Provide a table for all the for all web_events associated with account name of Walmart.
--There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. 
--Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

SELECT a.primary_poc, w.occurred_at, w.channel, a.name --select columns from web_events w and accounts a
FROM web_events w --table web events
JOIN accounts a --joined accounts a to web events w
ON w.account_id = a.id --fk w.account_id = pk a.id
WHERE a.name = 'Walmart';

--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s --pull from sales_reps table
JOIN region r --join region to sales reps
ON s.region_id = r.id --fk s.region_id = pk r.id
JOIN accounts a --join sales reps to accounts
ON a.sales_rep_id = s.id --fk a.sales_rep_id = pk s.id
ORDER BY a.name; --sort alphabetically by account name

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--Your final table should have 3 columns: region name, account name, and unit price. 
--A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT r.name region, a.name account, 
        o.total_amt_usd/(o.total + 0.01) unit_price --total_amt_usd / total + .01 AS unit_price
FROM region r --get region name from only table with region name 
JOIN sales_reps s --join region r to sales_reps s (big table)
ON s.region_id = r.id --fk s.region_id = pk r.id
JOIN accounts a --join sales_reps to accounts (bigger table)
ON a.sales_rep_id = s.id --fk a.sales_rep_id = pk s.id
JOIN orders o --join accounts to orders o (biggest table)
ON o.account_id = a.id; --fk o.account_id = pk a.id

--Left Join Country to state with c.countryid, c.countryname, and s.statename

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s --Left joins country c to state s (all rows from country, even those that don't match)
ON c.countryid = s.countryid;

--Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name, s.name, a.name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
AND r.name = 'Midwest' --condition can be at the bottom despite join order
ORDER BY a.name;


--Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name. 

SELECT r.name, s.name, a.name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
AND r.name = 'Midwest' --move down next to other AND statement
JOIN accounts a
ON a.sales_rep_id = s.id
AND a.name LIKE 'S%' --next time put r.name AND next to a.name AND and replace one AND with WHERE
ORDER BY a.name;

--Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name, s.name, a.name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
AND r.name = 'Midwest'
JOIN accounts a
ON a.sales_rep_id = s.id
AND a.name LIKE '%K' --for last names the correct syntax is LIKE '% K%'; as in, text space K text as a string (___ K___)
ORDER BY a.name;

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. 
--Your final table should have 3 columns: region name, account name, and unit price. 
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01)

SELECT r.name, s.name, 
  o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o --join accounts to orders o (biggest table)
ON o.account_id = a.id; --fk o.account_id = pk a.id
AND o.standard_qty > 100 --should be WHERE instead of AND

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
--Your final table should have 3 columns: region name, account name, and unit price. 
--Sort for the smallest unit price first. 
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name, s.name, 
  o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o --join accounts to orders o (biggest table)
ON o.account_id = a.id; --fk o.account_id = pk a.id
AND o.standard_qty > 100 AND o.poster_qty > 50 --first 'AND' should be 'WHERE'
ORDER BY o.unit_price; --no 'o.' before 'unit_price'

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
--Your final table should have 3 columns: region name, account name, and unit price. 
--Sort for the largest unit price first. 
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01)

SELECT r.name, a.name, 
  o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o --join accounts to orders o (biggest table)
ON o.account_id = a.id
AND o.standard_qty > 100 AND o.poster_qty > 50 --WHERE instead of AND
ORDER BY o.unit_price DESC; --nice

--What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. 
--You can try SELECT DISTINCT to narrow down the results to only the unique values.

SELECT DISTINCT a.name, w.channel --good!
FROM accounts a 
JOIN w.channel --should be 'web_events w'
ON w.account_id = a.id
AND a.id = 1001 --1001 should be a string ('1001')

--Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occured_at, a.name, o.total, o.total_amt_usd
FROM accounts a 
LEFT JOIN orders o --no LEFT neccessary, just JOIN
ON o.account_id = a.id
AND o.occured_at LIKE '2015' --AND should be WHERE
--^ correct syntax should be (WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016')
ORDER BY o.occured_at DESC; --adding this DESC ordering is just proper formatting

--Aggregations

--Find the total amount of poster_qty paper ordered in the orders table.

SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;

--Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

--Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

--When was the earliest order ever placed? You only need to return the date.

SELECT MIN(occured_at)
FROM orders;

--Try performing the same query as the last question without using an aggregation function. 

SELECT occurred_at 
FROM orders;
ORDER BY occurred_at 
LIMIT 1; --returns 1 row, and since it sorts by ascending by default, it returns the MIN value

--When did the most recent (latest) web_event occur?

SELECT MAX(occured_at)
FROM web_events;

--Try to perform the result of the previous query without using an aggregation function.

SELECT occured_at
FROM web_events;
ORDER BY occurred_at DESC --overrwrites the default ascending with DESC to get the MAX value when sorting instead
LIMIT 1;

--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. 
--Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT AVG(standard_qty),
          AVG(gloss_qty),
          AVG(poster_qty),
          AVG(standard_amt_usd),
          AVG(gloss_amt_usd),
          AVG(poster_amt_usd),
FROM orders;

--GROUP BY

--Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.


--Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.


--Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
--Your query should return only three values - the date, channel, and account name.


--Find the total number of times each type of channel from the web_events was used. 
--Your final table should have two columns - the channel and the number of times the channel was used.




--Who was the primary contact associated with the earliest web_event? 



--What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.



--Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.























