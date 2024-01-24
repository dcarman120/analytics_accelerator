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
ON accounts.id = orders.account_id;

--Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.

SELECT orders.standard_qty, orders.gloss_qty, 
          orders.poster_qty,  accounts.website, 
          accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

--Join web_events, accounts, and orders tables

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id --Joins accounts to web_events
JOIN orders
ON accounts.id = orders.account_id; --Joins orders to accounts

--Alias

FROM tablename t1
JOIN tablename2 t2

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2; --returns aliasname and aliasname2 instead of t1 t2


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

--GROUP BY; whenever there's a column in SELECT that is not being aggregated, SQL expects it to be in the GROUP BY clause as well

--Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at --sorts by time ascending, meaning oldest first
LIMIT 1;

--Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name; --a.name is not being aggregated (SUM'd) so it goes in GROUP BY as well

--Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
--Your query should return only three values - the date, channel, and account name.
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;

--Find the total number of times each type of channel from the web_events was used. 
--Your final table should have two columns - the channel and the number of times the channel was used.

SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel; --w.channel is not being aggregated (COUNT'd) so it goes in GROUP BY as well


--Who was the primary contact associated with the earliest web_event? 

SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

--What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name --a.name is not being aggregated (MIN'd) so it goes in GROUP BY as well
ORDER BY smallest_order;

--Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name --r.name is not being aggregated (COUNT'd) so it goes in GROUP BY as well
ORDER BY num_reps;

--For each account, determine the average amount of each type of paper they purchased across their orders. 
--Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account. 

SELECT a.name, AVG(o.standard_qty), AVG(o.gloss_qty), AVG(o.poster_qty) --make sure to name the AVGs after [ (AVG(o.standard_qty)) 'avg_stand', ] etc.
FROM accounts a
JOIN orders o 
ON o.account_id = a.id
GROUP BY a.name;

--For each account, determine the average amount spent per order on each paper type. 
--Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT a.name, AVG(o.standard_amt_usd), AVG(o.gloss_amt_usd), AVG(o.poster_amt_usd), AVG(o.total_amt_usd) --missed the o. before the amt_usd columns,as well as naming
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name; --rest of the query is perfect

--Determine the number of times a particular channel was used in the web_events table for each sales rep. 
--Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.

SELECT s.name, w.channel,  COUNT(*) channel_num 
FROM sales_reps s --accounts a should be in the FROM, sales_reps s should be in the JOIN; fk sales_rep_id is linking it, so the pk is joined
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON w.account_id = a.id
GROUP BY s.name, w.channel --nice
ORDER BY occurences DESC; --good

--Determine the number of times a particular channel was used in the web_events table for each region. 
--Your final table should have three columns - the region name, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.

SELECT r.name, w.channel, COUNT(*) occurrences
FROM region r --region r should be JOIN, accounts a should be FROM; same reason as above, region r is the fk in sales_reps, which is the fk in accounts, so accounts takes FROM priority and the rest are JOIN
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON w.account_id = a.id
GROUP BY r.name, w.channel
ORDER BY occurences DESC; --rest is fine

--Use DISTINCT to test if there are any accounts associated with more than one region.

SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

--after running first query

SELECT DISTINCT id, name
FROM accounts;

--Have any sales reps worked on more than one account?

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

--after running first query

SELECT DISTINCT id, name
FROM sales_reps;

--How many of the sales reps have more than 5 accounts that they manage?

SELECT s.id, s.name, COUNT(*) num_accounts --sales reps' names, id, and count the accounts that they manage
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name 
HAVING COUNT(*) > 5 --having a num_accounts of more than 5
ORDER BY num_accounts;

--How many accounts have more than 20 orders?

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

--Which account has the most orders?

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC --descending, meaning most to least
LIMIT 1; --first account in descending order has the most orders

--Which accounts spent more than 30,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent --account id, name, and sum of total amount as total spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000 
ORDER BY total_spent;

--Which accounts spent less than 1,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

--Which account has spent the most with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

--Which account has spent the least with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

--Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

--Which account used facebook most as a channel? 

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

--Which channel was most frequently used by most accounts?

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

--DATE_TRUNC truncates dates to a easier to group format such as day, month, quarter, and year

SELECT DATE_PART('dow', occured_at) AS day_of_week, --'dow' stands for day of week
          acccount_id,
          occurred_at,
          total
FROM demo.orders

SELECT DATE_PART('dow', occured_at) AS day_of_week, --'dow' stands for day of week
          SUM(total) AS total_qty
FROM demo.orders
GROUP BY 1 --1 and 2 identify the columns in the SELECT statement (day_of_week)
ORDER BY 2 DESC; --1 and 2 identify the columns in the SELECT statement  (total_qty)


--Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

SELECT DATE_PART('year' occurred_at) ord_year, SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

SELECT DATE_PART('month' occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM  orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;


--Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?

SELECT DATE_PART('year'occurred_at) ord_year, COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


--Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?

SELECT DATE_PART('month' occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_PART('month' occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent --month of occurred at AS ord_date, SUM of gloss paper spent AS tot_spent
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
WHERE w.channel = "Walmart" --should be a.name (account name = 'Walmart'), you're pulling from the accounts table after all
GROUP BY 1
ORDER BY 2
LIMIT 1; --only care about the largest month

--CASE statements, which go in the SELECT clause, handle IF/THEN logic, rather than arithmetic. 
--Syntax is CASE WHEN (condition) THEN (result) END AS (name of condition). ELSE can go after THEN and before END for capturing additional values

--Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

SELECT account_id,
          total_amt_usd
          CASE WHEN total >= 3000 THEN 'Large'
          CASE WHEN total < 3000 THEN 'Small' END AS order_level --replace second CASE WHEN with ELSE, other than that perfect
FROM orders;


--Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
--The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT
          CASE WHEN order_count >= 2000 THEN 'At least 2000'
          CASE WHEN order_count BETWEEN 1000 AND 2000 THEN 'Between 1k and 2k' --instead of BETWEEN, use arithmetic (total >= 1000 AND total < 2000)
          CASE WHEN order_count < 1000 THEN 'less than 1k' --change final CASE WHEN statement to ELSE and add END AS statement (ELSE 'Less than 1k' END AS order_category)
--COUNT(*) AS order_count | should be here to count the number of orders in each category
FROM orders
GROUP BY 1;

--We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
--The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. 
--The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. 
--You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT a.name, SUM(total_amt_usd) total_spent --grab SUM of total money spent AS total_spent
          CASE WHEN total_amt_usd > 200000 --add THEN statement (THEN 'top')
          CASE WHEN total_amt_usd <= 200000 AND >= 100000 --add THEN statement (THEN 'middle')
          ELSE 'low' END AS value_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY 1
ORDER BY 2 DESC; --rest is good

          
--We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. 
--Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle' --second CASE not needed, just another WHEN
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a --we're using name from accounts a, so we need a join statement here
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' --after the end of 2015 is 2016 and 2017
GROUP BY 1
ORDER BY 2 DESC;

--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
--Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. 
--Place the top sales people first in your final table.

SELECT s.name, COUNT(*) num_ords, --creates a table with the salesrep name and counts the total orders for each sales rep
          CASE WHEN COUNT(*) > 200 THEN 'top' --CASE WHEN statement that creates a column with top if they meet the criteria
        ELSE 'not' END AS sales_rep_level --ELSE when a rep does not meet the criteria
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name --we don't use 1 here as s.name is not created in the SELECT statement like something like 'total_spent'
ORDER BY 2 DESC;


--The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. 
--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
--The middle group has any rep with more than 150 orders or 500000 in sales. 
--Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. 
--Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!

SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total spent,
          CASE WHEN COUNT(*) 200 OR sales > 750000 THEN 'top' --sales should be SUM(o.total_amt_usd) 
          WHEN COUNT(*) > 150 OR sales > 500000 THEN 'mid' --sales should be SUM(o.total_amt_usd) 
          ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name 
ORDER BY 3 DESC; --orders by sales_rep_level




