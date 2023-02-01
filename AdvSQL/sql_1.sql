/*The query below pulls information from the stories and comments 
tables to create a table showing all stories posted on January 1, 2012, 
along with the corresponding number of comments. 

We use a LEFT JOIN 
so that the results include stories that didn't receive any comments.*/

WITH c AS (
    SELECT parent, COUNT(*) as num_comments
    FROM `bigquery-public-data.hacker_news.comments` 
    GROUP BY parent
)

SELECT s.id as story_id, s.by, s.title, c.num_comments
FROM `bigquery-public-data.hacker_news.stories` AS s
LEFT JOIN c
    ON s.id = c.parent
WHERE 
    EXTRACT(DATE FROM s.time_ts) = '2012-01-01'
ORDER BY c.num_comments DESC




/*
Next, we write a query to select all usernames corresponding to users who 
wrote stories or comments on January 1, 2014. We use UNION DISTINCT (instead of UNION ALL) 
to ensure that each user appears in the table at most once.
*/

SELECT c.by
FROM `bigquery-public-data.hacker_news.comments` AS c
WHERE EXTRACT(DATE FROM c.time_ts) = '2014-01-01'

UNION DISTINCT --ensure that each user appears in the table at most once.

SELECT s.by
FROM `bigquery-public-data.hacker_news.stories` AS s
WHERE EXTRACT(DATE FROM s.time_ts) = '2014-01-01'





SELECT q.id AS q_id,
    MIN( TIMESTAMP_DIFF(a.creation_date, q.creation_date, SECOND) ) as time_to_answer
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
    INNER JOIN `bigquery-public-data.stackoverflow.posts_answers` AS a
        ON q.id = a.parent_id
WHERE q.creation_date >= '2018-01-01' and q.creation_date < '2018-02-01'
GROUP BY q_id
ORDER BY time_to_answer

--now we what see all questions, even if dont have answer
SELECT q.id AS q_id,
    MIN( TIMESTAMP_DIFF(a.creation_date, q.creation_date, SECOND) ) as time_to_answer
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
    left JOIN `bigquery-public-data.stackoverflow.posts_answers` AS a
        ON q.id = a.parent_id
WHERE q.creation_date >= '2018-01-01' and q.creation_date < '2018-02-01'
GROUP BY q_id
ORDER BY time_to_answer


/*
You want to keep track of users who have asked questions, but have yet to provide answers. 
And, your table should also include users who have answered questions, 
but have yet to pose their own questions.
*/

SELECT q.owner_user_id AS owner_user_id,
    MIN(q.creation_date) AS q_creation_date, --question
    MIN(a.creation_date) AS a_creation_date  --answer
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
    left join  `bigquery-public-data.stackoverflow.posts_answers` AS a
ON q.owner_user_id = a.owner_user_id 
WHERE q.creation_date >= '2019-01-01' AND q.creation_date < '2019-02-01' 
    AND a.creation_date >= '2019-01-01' AND a.creation_date < '2019-02-01'
GROUP BY owner_user_id


/*
With this in mind, say you're interested in understanding users who joined the site in January 2019. 
You want to track their activity on the site: when did they post their first questions and answers, if ever?
*/

SELECT q.owner_user_id AS owner_user_id,
    MIN(q.creation_date) AS q_creation_date, --question
    MIN(a.creation_date) AS a_creation_date  --answer
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
    left join  `bigquery-public-data.stackoverflow.posts_answers` AS a
ON q.owner_user_id = a.owner_user_id 
WHERE q.creation_date >= '2019-01-01' --AND q.creation_date < '2019-02-01' 
    AND a.creation_date >= '2019-01-01' --AND a.creation_date < '2019-02-01'
GROUP BY owner_user_id
