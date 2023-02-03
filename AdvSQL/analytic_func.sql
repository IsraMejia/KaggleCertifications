/*
 you'd like to create a plot that shows a rolling average of the 
daily number of taxi trips.  

trip_date - contains one entry for each date from January 1, 2016, to March 31, 2016.
avg_num_trips - shows the average number of daily trips, calculated over a 
window including the value for the current date, along with the values 
for the preceding 3 days and the following 3 days, as long as the days 
fit within the three-month time frame. For instance, when calculating the 
value in this column for January 3, 2016, the window will include the number 
of trips for the preceding 2 days, the current date, and the following 3 days.
*/


WITH 
    trips_by_day AS (
      SELECT 
        DATE(trip_start_timestamp) AS trip_date,
        COUNT(*) as num_trips
      FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
      WHERE 
            trip_start_timestamp >= '2016-01-01' 
        AND trip_start_timestamp < '2016-04-01'
      GROUP BY trip_date
      ORDER BY trip_date
    )
    
SELECT 
    trip_date,
    AVG(num_trips) OVER (
        --partition by trip_date --Its not necessary because they are only one num_trips by day
        --order by trip_date asc
        rows between 3 preceding and 3 following
    ) AS avg_num_trips
FROM trips_by_day
order by trip_date asc


/*
The query below returns a DataFrame with three columns from the table: 
pickup_community_area, trip_start_timestamp, and trip_end_timestamp.

Amend the query to return an additional column called trip_number 
which shows the order in which the trips were taken from their respective community areas.
*/

SELECT pickup_community_area,
    trip_start_timestamp,
    trip_end_timestamp,
    RANK() OVER (
        partition BY pickup_community_area
        ORDER BY trip_start_timestamp asc
    ) AS trip_number
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE DATE(trip_start_timestamp) = '2013-10-03'
ORDER BY trip_start_timestamp asc, pickup_community_area


/*
Your task in this exercise is to edit the query to include an additional prev_break column 
that shows the length of the break (in minutes) that the driver 
had before each trip started (this corresponds to the time 
between trip_start_timestamp of the current trip and trip_end_timestamp of the previous trip). 
Partition the calculation by taxi_id, 
and order the results within each partition by trip_start_timestamp.
*/

WITH 
    trips_with_prev_break AS (
    SELECT
        taxi_id,
        trip_start_timestamp,
        trip_end_timestamp,
        LAG(trip_end_timestamp, 1) OVER (
            PARTITION BY taxi_id ORDER BY trip_start_timestamp
            ) AS prev_trip_end_timestamp
    FROM bigquery-public-data.chicago_taxi_trips.taxi_trips
    WHERE DATE(trip_start_timestamp) = '2013-10-03' 
    )

SELECT
    taxi_id,
    trip_start_timestamp,
    trip_end_timestamp,
    TIMESTAMP_DIFF(
            trip_start_timestamp, 
            prev_trip_end_timestamp, 
            MINUTE
        ) AS prev_break
FROM trips_with_prev_break
ORDER BY taxi_id, trip_start_timestamp
;