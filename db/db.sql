-- SQL Migration Script For WellDone 
-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS after_goal_completion;

-- Drop existing tables if they exist (for re-running migrations)
DROP TABLE IF EXISTS Reactions;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS Goals;
DROP TABLE IF EXISTS Followings;
DROP TABLE IF EXISTS Users;

-- Users Table
CREATE TABLE Users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Followings Table
CREATE TABLE Followings (
    following_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    followed_by BIGINT NOT NULL,
    following BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (followed_by) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (following) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_following (followed_by, following)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Goals Table
CREATE TABLE Goals (
    goal_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(100) NOT NULL,
    status ENUM('Planned', 'InProgress', 'Completed') NOT NULL DEFAULT 'Planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Posts Table
CREATE TABLE Posts (
    post_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    goal_id BIGINT,
    content TEXT NOT NULL,
    post_type ENUM('user', 'system') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (goal_id) REFERENCES Goals(goal_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reactions Table
CREATE TABLE Reactions (
    reaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    type ENUM('Celebrate', 'Support', 'Encourage', 'Appreciate', 'Inspire') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Trigger for automatic post creation on goal completion
DELIMITER //

CREATE TRIGGER after_goal_completion
AFTER UPDATE ON Goals
FOR EACH ROW
BEGIN
    DECLARE user_name VARCHAR(50);
    DECLARE message_content TEXT;

    -- Check if the goal was just marked as completed
    IF NEW.status = 'Completed' AND OLD.status != 'Completed' THEN
        -- Get the username
        SELECT username INTO user_name 
        FROM Users 
        WHERE user_id = NEW.user_id;

        -- Set a single generic message for goal completion
        SET message_content = CONCAT('I’m thrilled to announce that I’ve just completed a goal: "', NEW.title, '".');

        -- Create the automated post
        INSERT INTO Posts (
            user_id,
            goal_id,
            content,
            post_type
        ) VALUES (
            NEW.user_id,
            NEW.goal_id,
            message_content,
            'system'
        );
    END IF;
END//

DELIMITER ;
