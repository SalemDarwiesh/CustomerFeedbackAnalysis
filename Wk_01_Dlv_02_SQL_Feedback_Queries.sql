-- Total Number of Responses
SELECT COUNT(comment_id) AS Total_Responses 
FROM ft_feedback;

-- Overall Average Rating Across All Feedback
SELECT AVG(stars) AS Overall_Avg_Rating 
FROM ft_feedback;

-- Top 10 Recipes by Number of Responses
SELECT TOP (10) 
    r.recipe_name, 
    COUNT(f.comment_id) AS Number_of_Responses
FROM ft_feedback f
JOIN dm_recipe r ON f.recipe_number = r.recipe_number
GROUP BY r.recipe_name
ORDER BY Number_of_Responses DESC;

-- Top 10 Recipes by Average Rating
SELECT TOP (10) 
    r.recipe_name, 
    AVG(f.stars) AS Avg_Rating
FROM ft_feedback f
JOIN dm_recipe r ON f.recipe_number = r.recipe_number
GROUP BY r.recipe_name
ORDER BY Avg_Rating DESC;

-- Bottom 10 Recipes by Average Rating
SELECT TOP (10) 
    r.recipe_name, 
    AVG(f.stars) AS Avg_Rating
FROM ft_feedback f
JOIN dm_recipe r ON f.recipe_number = r.recipe_number
GROUP BY r.recipe_name
ORDER BY Avg_Rating ASC;
