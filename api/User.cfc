component restpath="/users" rest="true" {
    variables.dataSource = application.dataSource;
    variables.utils = new utils.Utils();

    /**
     * Get a specific user's profile by id
     */
    remote any function getUser(required numeric id restargsource="Path") httpmethod="GET" restpath="{id}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "
            SELECT 
                U.user_id, U.username, U.email, U.created_at,
                (SELECT COUNT(*) FROM heart_nest.Followings WHERE followed_by = U.user_id) AS followings_count,
                (SELECT COUNT(*) FROM heart_nest.Followings WHERE following = U.user_id) AS followers_count,
                (SELECT COUNT(*) FROM heart_nest.Goals WHERE user_id = U.user_id) AS total_goals,
                (SELECT COUNT(*) FROM heart_nest.Goals WHERE user_id = U.user_id AND status = 'Completed') AS completed_goals
            FROM heart_nest.Users U
            WHERE U.user_id = ?
        ";
        
        var result = queryExecute(sql, [arguments.id], {dataSource = variables.dataSource});
        
        if (result.recordCount == 0) {
            cfheader(statusCode="404", statusText="Not Found");
            return {"error" = "User with id: #arguments.id# not found"};
        }
        
        var user = structNew("ordered");
        user["user_id"] = result.user_id[1];
        user["username"] = result.username[1];
        user["email"] = result.email[1];
        user["created_at"] = result.created_at[1];
        user["followers_count"] = result.followers_count[1];
        user["followings_count"] = result.followings_count[1];
        user["total_goals"] = result.total_goals[1];
        user["completed_goals"] = result.completed_goals[1];
        
        return user;
    }

    /**
     * Get a list of users matched by username
     */
    remote any function getUsersByUsername(required string username restargsource="Query") httpmethod="GET" restpath="" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "SELECT user_id, username, email, created_at FROM heart_nest.Users WHERE username LIKE ?";
        var result = queryExecute(sql, ["%" & arguments.username & "%"], {dataSource = variables.dataSource});
                
        var users = [];
        for (var i = 1; i <= result.recordCount; i++) {
            var user = structNew("ordered");
            user["user_id"] = result.user_id[i];
            user["username"] = result.username[i];
            user["email"] = result.email[i];
            user["created_at"] = result.created_at[i];
            arrayAppend(users, user);
        }
        
        return users;
    }


   
}
