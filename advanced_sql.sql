-- SQL Data Types
-- Convert the funding_total_usd and founded_at_clean columns in the tutorial.crunchbase_companies_clean_date table 
-- to strings (varchar format) using a different formatting function for each one.


-- SQL Date Format
-- Write a query that counts the number of companies acquired within 3 years, 5 years, and 10 years of being founded. 
-- Include a column for total companies acquired as well. Group by category and limit to only rows with a founding date.


-- Using SQL String Functions to Clean Data
-- Write a query that separates the `location` field into separate fields for latitude and longitude. 
-- You can compare your results against the actual `lat` and `lon` fields in the table.

-- Concatenate the lat and lon fields to form a field that is equivalent to the location field.

-- Create the same concatenated location field, but using the || syntax instead of CONCAT.

-- Write a query that creates a date column formatted YYYY-MM-DD.

-- Write a query that returns the `category` field, 
-- but with the first letter capitalized and the rest of the letters in lower-case.

-- Write a query that creates an accurate timestamp using the date and time columns in tutorial.sf_crime_incidents_2014_01. 
-- Include a field that is exactly 1 week later as well.

-- Write a query that counts the number of incidents reported by week. 
-- Cast the week as a date to get rid of the hours/minutes/seconds.

-- Write a query that shows exactly how long ago each indicent was reported. 
-- Assume that the dataset is in Pacific Standard Time (UTC - 8).


-- Writing Subqueries in SQL
-- Write a query that selects all Warrant Arrests from the tutorial.sf_crime_incidents_2014_01 dataset, 
-- then wrap it in an outer query that only displays unresolved incidents.

-- Write a query that displays the average number of monthly incidents for each category.

-- Write a query that displays all rows from the three categories with the fewest incidents reported.

-- Write a query that counts the number of companies founded and acquired by quarter starting in Q1 2012. 
-- Create the aggregations in two separate queries, then join them.

-- Write a query that ranks investors from the combined dataset above by the total number of investments they have made.

-- Write a query that does the same thing as in the previous problem, except only for companies that are still operating. 


-- SQL Window Functions
-- Write a query modification of the above example query that shows the duration of each ride as 
-- a percentage of the total time accrued by riders from each start_terminal

-- Write a query that shows a running total of the duration of bike rides (similar to the last example), 
-- but grouped by end_terminal, and with ride duration sorted in descending order.

-- Write a query that shows the 5 longest rides from each starting terminal, ordered by terminal, 
-- and longest to shortest rides within each terminal. Limit to rides that occurred before Jan. 8, 2012.

-- Write a query that shows only the duration of the trip and the percentile into which that duration falls 
-- (across the entire dataset—not partitioned by terminal).
