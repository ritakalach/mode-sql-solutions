-- SQL Data Types
-- Convert the funding_total_usd and founded_at_clean columns in the tutorial.crunchbase_companies_clean_date table 
-- to strings (varchar format) using a different formatting function for each one.
SELECT CAST(funding_total_usd AS varchar) AS funding_total_usd_string,
       founded_at_clean::varchar AS founded_at_string
  FROM tutorial.crunchbase_companies_clean_date;


-- SQL Date Format
-- Write a query that counts the number of companies acquired within 3 years, 5 years, and 10 years of being founded. 
-- Include a column for total companies acquired as well. Group by category and limit to only rows with a founding date.
SELECT companies.category_code,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years'
                  THEN 1 ELSE NULL END) AS acquired_3_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
                  THEN 1 ELSE NULL END) AS acquired_5_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years'
                  THEN 1 ELSE NULL END) AS acquired_10_yrs,
       COUNT(1) AS total
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
 WHERE founded_at_clean IS NOT NULL
 GROUP BY 1
 ORDER BY 5 DESC;


-- Using SQL String Functions to Clean Data
-- Write a query that separates the `location` field into separate fields for latitude and longitude. 
-- You can compare your results against the actual `lat` and `lon` fields in the table.
SELECT location,
       TRIM(leading '(' FROM LEFT(location, POSITION(',' IN location) - 1)) AS lattitude,
       TRIM(trailing ')' FROM RIGHT(location, LENGTH(location) - POSITION(',' IN location) ) ) AS longitude
  FROM tutorial.sf_crime_incidents_2014_01;
                                  
-- Concatenate the lat and lon fields to form a field that is equivalent to the location field.
SELECT CONCAT('(', lat, ', ', lon, ')') AS concat_location,
       location
  FROM tutorial.sf_crime_incidents_2014_01;
                                  
-- Create the same concatenated location field, but using the || syntax instead of CONCAT.
SELECT '(' || lat || ', ' || lon || ')' AS concat_location,
       location
  FROM tutorial.sf_crime_incidents_2014_01;
                                  
-- Write a query that creates a date column formatted YYYY-MM-DD.
SELECT incidnt_num,
       date,
       SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01;                                  

-- Write a query that returns the `category` field, 
-- but with the first letter capitalized and the rest of the letters in lower-case.
SELECT incidnt_num,
       category,
       UPPER(LEFT(category, 1)) || LOWER(RIGHT(category, LENGTH(category) - 1)) AS category_cleaned
  FROM tutorial.sf_crime_incidents_2014_01;
                                               
-- Write a query that creates an accurate timestamp using the date and time columns in tutorial.sf_crime_incidents_2014_01. 
-- Include a field that is exactly 1 week later as well.
SELECT incidnt_num,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp
        + INTERVAL '1 week' AS timestamp_plus_interval
  FROM tutorial.sf_crime_incidents_2014_01;
                                              
-- Write a query that counts the number of incidents reported by week. 
-- Cast the week as a date to get rid of the hours/minutes/seconds.
SELECT DATE_TRUNC('week', cleaned_date)::date AS week_beginning,
       COUNT(1) AS incidents
  FROM tutorial.sf_crime_incidents_cleandate
 GROUP BY 1
 ORDER BY 1;
                                               
-- Write a query that shows exactly how long ago each indicent was reported. 
-- Assume that the dataset is in Pacific Standard Time (UTC - 8).
SELECT incidnt_num,
       cleaned_date,
       NOW() AT TIME ZONE 'PST' AS now,
       NOW() AT TIME ZONE 'PST' - cleaned_date AS time_ago 
  FROM tutorial.sf_crime_incidents_cleandate;
                                               

-- Writing Subqueries in SQL
-- Write a query that selects all Warrant Arrests from the tutorial.sf_crime_incidents_2014_01 dataset, 
-- then wrap it in an outer query that only displays unresolved incidents.
SELECT *
  FROM (SELECT *
          FROM tutorial.sf_crime_incidents_2014_01
         WHERE descript = 'WARRANT ARREST') sub
 WHERE resolution = 'NONE';
                                               
-- Write a query that displays the average number of monthly incidents for each category.
SELECT category, AVG(incidents)
  FROM (SELECT category, 
               EXTRACT(month FROM cleaned_date) AS month, 
               COUNT(1) AS incidents
          FROM tutorial.sf_crime_incidents_cleandate
         GROUP BY category, month) sub
 GROUP BY category;
                                               
-- Write a query that displays all rows from the three categories with the fewest incidents reported.
SELECT incidents.*, sub.count
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN (SELECT category, COUNT(1) AS count
          FROM tutorial.sf_crime_incidents_2014_01
         GROUP BY category
         ORDER BY count
         LIMIT 3) sub
    ON incidents.category = sub.category;
                                              
-- Write a query that counts the number of companies founded and acquired by quarter starting in Q1 2012. 
-- Create the aggregations in two separate queries, then join them.
SELECT COALESCE(companies.quarter, acquisitions.quarter) AS quarter,
       companies.companies_founded,
       acquisitions.companies_acquired
  FROM (SELECT founded_quarter AS quarter,
               COUNT(permalink) AS companies_founded
          FROM tutorial.crunchbase_companies
         WHERE founded_year >= 2012
         GROUP BY 1) companies
                                               
  LEFT JOIN (SELECT acquired_quarter AS quarter,
                    COUNT(DISTINCT company_permalink) AS companies_acquired
               FROM tutorial.crunchbase_acquisitions
              WHERE acquired_year >= 2012
              GROUP BY 1) acquisitions   
                                               
    ON companies.quarter = acquisitions.quarter
 ORDER BY 1;
                                               
-- Write a query that ranks investors from the combined dataset above by the total number of investments they have made.
SELECT investor_name,
       COUNT(*) AS investments
  FROM (SELECT *
          FROM tutorial.crunchbase_investments_part1
         
         UNION ALL
        
         SELECT *
           FROM tutorial.crunchbase_investments_part2) sub
 GROUP BY 1
 ORDER BY 2 DESC;
                                               
-- Write a query that does the same thing as in the previous problem, except only for companies that are still operating. 
SELECT investments.investor_name,
       COUNT(investments.*) AS investments
  FROM tutorial.crunchbase_companies companies
  JOIN (SELECT *
          FROM tutorial.crunchbase_investments_part1
         
         UNION ALL
        
         SELECT *
           FROM tutorial.crunchbase_investments_part2) investments
    ON investments.company_permalink = companies.permalink
 WHERE companies.status = 'operating'
 GROUP BY 1
 ORDER BY 2 DESC;
                                               

-- SQL Window Functions
-- Write a query modification of the above example query that shows the duration of each ride as 
-- a percentage of the total time accrued by riders from each start_terminal
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS start_terminal_sum,
       (duration_seconds/SUM(duration_seconds) OVER (PARTITION BY start_terminal))*100 AS pct_of_total_time
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY 1, 4 DESC;
                                                     
-- Write a query that shows a running total of the duration of bike rides (similar to the last example), 
-- but grouped by end_terminal, and with ride duration sorted in descending order.
SELECT end_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY end_terminal ORDER BY duration_seconds DESC)
         AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08';
                                                     
-- Write a query that shows the 5 longest rides from each starting terminal, ordered by terminal, 
-- and longest to shortest rides within each terminal. Limit to rides that occurred before Jan. 8, 2012.
SELECT *
  FROM (
        SELECT start_terminal,
               start_time,
               duration_seconds AS trip_time,
               RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
          FROM tutorial.dc_bikeshare_q1_2012
         WHERE start_time < '2012-01-08'
               ) sub
 WHERE rank <= 5;
                                                     
-- Write a query that shows only the duration of the trip and the percentile into which that duration falls 
-- (across the entire dataset—not partitioned by terminal).
SELECT duration_seconds,
       NTILE(100) OVER (ORDER BY duration_seconds)
         AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY 1 DESC;
