
--query to find the individuals with the most commits in this table in 2016.
select 
    committer.name AS committer_name, 
    COUNT(*) AS num_commits
from `bigquery-public-data.github_repos.sample_commits`
    --unnest(committer) as committer_data  --Inecesary because is RECORD
where 
    EXTRACT(year FROM committer.date) = 2016 
GROUP BY committer_name
ORDER BY num_commits DESC 
;
--Schema
[
    SchemaField('commit', 'STRING', 'NULLABLE', None, (), None),
    SchemaField('tree', 'STRING', 'NULLABLE', None, (), None),
    SchemaField('parent', 'STRING', 'REPEATED', None, (), None),
    SchemaField('author', 'RECORD', 'NULLABLE', None, (SchemaField('name', 'STRING', 'NULLABLE', None, (), None), SchemaField('email', 'STRING', 'NULLABLE', None, (), None), SchemaField('time_sec', 'INTEGER', 'NULLABLE', None, (), None), SchemaField('tz_offset', 'INTEGER', 'NULLABLE', None, (), None), SchemaField('date', 'TIMESTAMP', 'NULLABLE', None, (), None)), None),
    
    SchemaField('committer', 'RECORD', 'NULLABLE', None, 
        (   SchemaField('name', 'STRING', 'NULLABLE', None, (), None), 
            SchemaField('email', 'STRING', 'NULLABLE', None, (), None), 
            SchemaField('time_sec', 'INTEGER', 'NULLABLE', None, (), None), 
            SchemaField('tz_offset', 'INTEGER', 'NULLABLE', None, (), None), 
            SchemaField('date', 'TIMESTAMP', 'NULLABLE', None, (), None)
        ), None
    ),
    
    
    SchemaField('subject', 'STRING', 'NULLABLE', None, (), None),
    SchemaField('message', 'STRING', 'NULLABLE', None, (), None),
    SchemaField('trailer', 'RECORD', 'REPEATED', None, (SchemaField('key', 'STRING', 'NULLABLE', None, (), None), SchemaField('value', 'STRING', 'NULLABLE', None, (), None), SchemaField('email', 'STRING', 'NULLABLE', None, (), None)), None),
    SchemaField('difference', 'RECORD', 'REPEATED', None, (SchemaField('old_mode', 'INTEGER', 'NULLABLE', None, (), None), SchemaField('new_mode', 'INTEGER', 'NULLABLE', None, (), None), SchemaField('old_path', 'STRING', 'NULLABLE', None, (), None), SchemaField('new_path', 'STRING', 'NULLABLE', None, (), None), SchemaField('old_sha1', 'STRING', 'NULLABLE', None, (), None), SchemaField('new_sha1', 'STRING', 'NULLABLE', None, (), None), SchemaField('old_repo', 'STRING', 'NULLABLE', None, (), None), SchemaField('new_repo', 'STRING', 'NULLABLE', None, (), None)), None),
    SchemaField('difference_truncated', 'BOOLEAN', 'NULLABLE', None, (), None),
    SchemaField('repo_name', 'STRING', 'NULLABLE', None, (), None),
    SchemaField('encoding', 'STRING', 'NULLABLE', None, (), None)
 ]





SELECT 
    lenguaje.name as language_name, 
    COUNT(*) as num_repos
FROM `bigquery-public-data.github_repos.languages`,
    UNNEST(language) AS lenguaje
GROUP BY language_name
ORDER BY num_repos DESC

--Which languages are used in the repository with the most languages?¶
--For this question, you'll restrict your attention to the repository with name 'polyrabbit/polyglot'.
--DESC `bigquery-public-data.github_repos.languages`
SELECT lenguajes.name, lenguajes.bytes
FROM `bigquery-public-data.github_repos.languages`,
    UNNEST(language) as lenguajes
WHERE repo_name = '-polyrabbit/polyglot' --repo that whe want
ORDER BY lenguajes.bytes DESC

 