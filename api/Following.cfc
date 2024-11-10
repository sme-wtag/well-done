component restpath="/followings" rest="true" {
    variables.dataSource = application.dataSource;
    variables.utils = new utils.Utils();

    /**
     * Follow a user
     */
    remote any function follow(required numeric followingId restargsource="Path") httpmethod="POST" restpath="/{followingId}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)) {
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }
        
        if (userId == arguments.followingId) {
            cfheader(statusCode="400", statusText="Bad Request");
            return {"error" = "You cannot follow yourself."};
        }
        
        // Check if already following
        var sql = "SELECT following_id FROM heart_nest.Followings WHERE followed_by = ? AND following = ?";
        var result = queryExecute(sql, [userId, arguments.followingId], {dataSource = variables.dataSource});
        
        if (result.recordCount > 0) {
            cfheader(statusCode="409", statusText="Conflict");
            return {"error" = "You are already following this user."};
        }
        
        // Insert new follow record
        sql = "INSERT INTO heart_nest.Followings (followed_by, following) VALUES (?, ?)";
        queryExecute(sql, [userId, arguments.followingId], {dataSource = variables.dataSource});
        
        cfheader(statusCode="201", statusText="Created");
        return {"message" = "Successfully followed the user."};
    }

    /**
     * Unfollow a user
     */
    remote any function unfollow(required numeric followingId restargsource="Path") httpmethod="DELETE" restpath="/{followingId}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)) {
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }
        
        // Check if following exists
        var sql = "SELECT following_id FROM heart_nest.Followings WHERE followed_by = ? AND following = ?";
        var result = queryExecute(sql, [userId, arguments.followingId], {dataSource = variables.dataSource});
        
        if (result.recordCount == 0) {
            cfheader(statusCode="404", statusText="Not Found");
            return {"error" = "You are not following this user."};
        }
        
        // Delete follow record
        sql = "DELETE FROM heart_nest.Followings WHERE followed_by = ? AND following = ?";
        queryExecute(sql, [userId, arguments.followingId], {dataSource = variables.dataSource});
        
        cfheader(statusCode="200", statusText="Deleted");
        return {"message" = "Successfully unfollowed the user."};
    }

    /**
     * Remove a follower
     */
    remote any function removeFollower(required numeric followerId restargsource="Path") httpmethod="DELETE" restpath="remove/{followerId}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)) {
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }
        
        // Check if follower exists
        var sql = "SELECT following_id FROM heart_nest.Followings WHERE followed_by = ? AND following = ?";
        var result = queryExecute(sql, [arguments.followerId, userId], {dataSource = variables.dataSource});
        
        if (result.recordCount == 0) {
            cfheader(statusCode="404", statusText="Not Found");
            return {"error" = "User is not following you."};
        }
        
        // Delete follow record
        sql = "DELETE FROM heart_nest.Followings WHERE followed_by = ? AND following = ?";
        queryExecute(sql, [arguments.followerId, userId], {dataSource = variables.dataSource});
        
        cfheader(statusCode="200", statusText="Deleted");
        return {"message" = "Successfully removed the follower."};
    }

    /**
     * Get followers for a specific user
     */
    remote any function getFollowers() httpmethod="GET" restpath="followers" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)) {
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "
            SELECT U.user_id, U.username, U.email, F.created_at 
            FROM heart_nest.Followings F
            INNER JOIN heart_nest.Users U ON U.user_id = F.followed_by
            WHERE F.following = ?";
        var result = queryExecute(sql, [userId], {dataSource = variables.dataSource});
        
        var followers = [];
        for (var i = 1; i <= result.recordCount; i++) {
            var follower = structNew("ordered");
            follower["user_id"] = result.user_id[i];
            follower["username"] = result.username[i];
            follower["email"] = result.email[i];
            follower["followed_since"] = result.created_at[i];
            arrayAppend(followers, follower);
        }
        
        return followers;
    }

    /**
     * Get followings for a specific user
     */
    remote any function getFollowings() httpmethod="GET" restpath="followings" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)) {
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "
            SELECT U.user_id, U.username, U.email, F.created_at 
            FROM heart_nest.Followings F
            INNER JOIN heart_nest.Users U ON U.user_id = F.following
            WHERE F.followed_by = ?";
        var result = queryExecute(sql, [userId], {dataSource = variables.dataSource});
        
        var followings = [];
        for (var i = 1; i <= result.recordCount; i++) {
            var following = structNew("ordered");
            following["user_id"] = result.user_id[i];
            following["username"] = result.username[i];
            following["email"] = result.email[i];
            following["followed_since"] = result.created_at[i];
            arrayAppend(followings, following);
        }
        
        return followings;
    }
}
