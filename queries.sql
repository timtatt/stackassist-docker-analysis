-- Posts with mosts upvotes
SELECT 
TOP 100 *
FROM Posts p
WHERE 
p.Tags LIKE '%docker%'
ORDER BY p.Score DESC

-- Posts with most upvotes on answer
SELECT 
TOP 100 *
FROM Posts p
INNER JOIN Posts a ON a.Id = P.AcceptedAnswerId
WHERE 
p.Tags LIKE '%docker%'
ORDER BY a.Score DESC

-- Posts with most views
SELECT 
TOP 100 *
FROM Posts p
WHERE 
p.Tags LIKE '%docker%'
ORDER BY p.Views DESC

-- Posts with most duplicates
SELECT 
TOP 100 * 
FROM Posts p
INNER JOIN
  (SELECT COUNT(pd.Id) AS NumberOfChildren, JSON_VALUE(ph.Text, '$.OriginalQuestionIds[0]') AS OriginalPostId
  FROM posts pd
  INNER JOIN PostHistory ph on ph.postid = pd.id
  WHERE pd.posttypeid = 1 -- q
  AND ph.PostHistoryTypeId = 10 -- closed
  AND ph.comment = 101 -- as duplicate
  GROUP BY JSON_VALUE(ph.Text, '$.OriginalQuestionIds[0]')
  HAVING COUNT(pd.Id) > 0) pd
ON pd.OriginalPostId = p.Id
WHERE p.Tags LIKE '%docker%'
ORDER BY pd.NumberOfChildren DESC
