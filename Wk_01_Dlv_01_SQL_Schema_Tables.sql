-- Create a new database for customer feedback management
CREATE DATABASE CustomerFeedbackDB;

-- Create staging table
CREATE TABLE stg_Recipe_Feedback (
    ID INT IDENTITY(1,1) PRIMARY KEY, 
    recipe_number INT, 
    recipe_code INT, 
    recipe_name NVARCHAR(255),
    comment_id NVARCHAR(100),
    user_id NVARCHAR(50),
    user_name NVARCHAR(100),
    user_reputation INT, 
    created_at INT, 
    reply_count INT,
    thumbs_up INT,
    thumbs_down INT,
    stars INT,
    best_score INT,
    feedback_text NVARCHAR(MAX)
);

-- Bulk Insert
BULK INSERT stg_Recipe_Feedback
FROM '[ADD FILE PATH]'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Create the dimension and fact tables

-- dm_recipe table
CREATE TABLE dm_recipe (
    recipe_number INT PRIMARY KEY,
    recipe_code INT,
    recipe_name NVARCHAR(255)
);

-- dm_user table
CREATE TABLE dm_user (
    user_id NVARCHAR(50) PRIMARY KEY,
    user_name NVARCHAR(100)
);

-- ft_user_feedback (fact table)
CREATE TABLE ft_user_feedback (
    comment_id NVARCHAR(100) PRIMARY KEY,
    recipe_number INT, -- Foreign key
    recipe_code INT, 
    recipe_name NVARCHAR(255),
    user_id NVARCHAR(50), -- Foreign key
    user_name NVARCHAR(100), 
    user_reputation INT, 
    created_at DATETIME,
    reply_count INT,
    thumbs_up INT,
    thumbs_down INT,
    stars INT,
    best_score INT,
    feedback_text NVARCHAR(MAX),
    FOREIGN KEY (recipe_number) REFERENCES dm_recipe(recipe_number),
    FOREIGN KEY (user_id) REFERENCES dm_user(user_id)
);

-- Insert distinct recipes
INSERT INTO dm_recipe (recipe_number, recipe_code, recipe_name)
SELECT DISTINCT recipe_number, recipe_code, recipe_name
FROM stg_Recipe_Feedback
WHERE recipe_number IS NOT NULL;

-- Insert distinct users
INSERT INTO dm_user (user_id, user_name)
SELECT DISTINCT user_id, user_name
FROM stg_Recipe_Feedback
WHERE user_id IS NOT NULL;

-- Insert feedback
INSERT INTO ft_user_feedback (comment_id, recipe_number, recipe_code, recipe_name, user_id, user_name, user_reputation, created_at, reply_count, thumbs_up, thumbs_down, stars, best_score, feedback_text)
SELECT comment_id, 
       recipe_number, 
       recipe_code, 
       recipe_name,
       user_id, 
       user_name, 
       user_reputation, 
       DATEADD(SECOND, created_at, '1970-01-01'),
       reply_count, 
       thumbs_up, 
       thumbs_down, 
       stars, 
       best_score, 
       feedback_text
FROM stg_Recipe_Feedback;
