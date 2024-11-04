-- Select recipe name and feedback text, categorize sentiment based on keyword matching
SELECT 
    [recipe_name],                        
    [feedback_text],                      
    -- Categorize sentiment based on keyword matching in the feedback text
    CASE
        WHEN feedback_text LIKE '%good%' 
            OR feedback_text LIKE '%great%' 
            OR feedback_text LIKE '%excellent%' THEN 'Positive'
        WHEN feedback_text LIKE '%bad%' 
            OR feedback_text LIKE '%terrible%' 
            OR feedback_text LIKE '%poor%' THEN 'Negative'
        ELSE 'Neutral'
    END AS Sentiment
FROM 
    [CustomerFeedbackDB].[dbo].[ft_user_feedback];  

-- Create a temporary table (CTE) to analyze and categorize feedback into sentiment categories
WITH SentimentAnalysis AS (
    SELECT 
        [recipe_name],                   
        -- Categorize sentiment based on keyword matching in the feedback text
        CASE
            WHEN feedback_text LIKE '%good%' 
                OR feedback_text LIKE '%great%' 
                OR feedback_text LIKE '%excellent%'
                OR feedback_text LIKE '%nice%' 
                OR feedback_text LIKE '%delicious%' 
                OR feedback_text LIKE '%awesome%' 
                OR feedback_text LIKE '%pretty%' THEN 'Positive'
            WHEN feedback_text LIKE '%bad%' 
                OR feedback_text LIKE '%terrible%' 
                OR feedback_text LIKE '%poor%' THEN 'Negative'
            ELSE 'Neutral'
        END AS Sentiment                 
    FROM 
        [CustomerFeedbackDB].[dbo].[ft_user_feedback] 
)
-- Main query to calculate sentiment counts for each recipe
SELECT 
    [recipe_name],                       
    -- Count the number of positive feedbacks
    COUNT(CASE WHEN Sentiment = 'Positive' THEN 1 END) AS PositiveFeedbacks,
    -- Count the number of negative feedbacks
    COUNT(CASE WHEN Sentiment = 'Negative' THEN 1 END) AS NegativeFeedbacks,
    -- Count the number of neutral feedbacks
    COUNT(CASE WHEN Sentiment = 'Neutral' THEN 1 END) AS NeutralFeedbacks
FROM 
    SentimentAnalysis                     
GROUP BY 
    [recipe_name]                  
ORDER BY 
    PositiveFeedbacks DESC;               
