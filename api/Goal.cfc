component restpath="/goals" rest="true" {
    variables.dataSource = application.dataSource;
    variables.utils = new utils.Utils();
    
    /**
     * Get all goals for the authenticated user
     */
    remote any function getGoals() httpmethod="GET" restpath="" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "SELECT * FROM heart_nest.Goals WHERE user_id = ?";
        var result = queryExecute(sql, [userId], {dataSource = variables.dataSource});
        
        var goals = [];
        for (var i = 1; i <= result.recordCount; i++) {
            var goal = structNew("ordered");
            goal["goal_id"] = result.goal_id[i];
            goal["title"] = result.title[i];
            goal["status"] = result.status[i];
            goal["created_at"] = result.created_at[i];
            goal["completed_at"] = result.completed_at[i];
            arrayAppend(goals, goal);
        }
                
        return goals;
    }

    /**
     * Get a specific goal for the authenticated user
     */
    remote any function getGoal(required numeric id restargsource="Path") httpmethod="GET" restpath="{id}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "SELECT * FROM heart_nest.Goals WHERE goal_id = ? AND user_id = ?";
        var result = queryExecute(sql, [arguments.id, userId], {dataSource = variables.dataSource});
    
        if (result.recordCount == 0) {
            cfheader(statusCode="404", statusText="Not Found");
            return {"error" = "Goal with id: #arguments.id# not found for this user"};
        }
        
        var goal = structNew("ordered");
        goal["goal_id"] = result.goal_id[1];
        goal["title"] = result.title[1];
        goal["status"] = result.status[1];
        goal["created_at"] = result.created_at[1];
        goal["completed_at"] = result.completed_at[1];
        
        return goal;
    }

    /**
     * Create a new goal for the authenticated user
     */
    remote any function createGoal() httpmethod="POST" restpath="" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var requestData = getHttpRequestData();
        var newGoal = deserializeJSON(requestData.content);

        var sql = "
            INSERT INTO heart_nest.Goals (user_id, title, status) 
            VALUES (?, ?, ?)";
        queryExecute(sql, [
            userId, 
            newGoal.title, 
            newGoal.status ?: "Planned"
        ], {dataSource = variables.dataSource});
        
        cfheader(statusCode="201", statusText="Created");
        var response = structNew("ordered");
        response["message"] = "Goal created successfully";
        return response;
    }
    
    /**
     * Update an existing goal for the authenticated user
     */
    remote any function updateGoal(required numeric id restargsource="Path") httpmethod="PUT" restpath="{id}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "SELECT * FROM heart_nest.Goals WHERE goal_id = ? AND user_id = ?";
        var result = queryExecute(sql, [arguments.id, userId], {dataSource = variables.dataSource});
    
        if (result.recordCount == 0) {
            cfheader(statusCode="404", statusText="Not Found");
            var errorResponse = structNew("ordered");
            errorResponse["error"] = "Goal with id: #arguments.id# not found for this user";
            return errorResponse;
        }

        var requestData = getHttpRequestData();
        var updatedGoal = deserializeJSON(requestData.content);

        sql = "
            UPDATE heart_nest.Goals 
            SET title = ?, status = ?, completed_at = ?
            WHERE goal_id = ? AND user_id = ?";
        queryExecute(sql, [
            updatedGoal.title, 
            updatedGoal.status, 
            updatedGoal.completed_at ?: null,
            arguments.id,
            userId
        ], {dataSource = variables.dataSource});
        
        cfheader(statusCode="200", statusText="Updated");
        var response = structNew("ordered");
        response["message"] = "Goal updated successfully";
        return response;
    }

    /**
     * Delete a goal for the authenticated user
     */
    remote any function deleteGoal(required numeric id restargsource="Path") httpmethod="DELETE" restpath="{id}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "SELECT * FROM heart_nest.Goals WHERE goal_id = ? AND user_id = ?";
        var result = queryExecute(sql, [arguments.id, userId], {dataSource = variables.dataSource});
    
        if (result.recordCount == 0) {
            cfheader(statusCode="404", statusText="Not Found");
            var errorResponse = structNew("ordered");
            errorResponse["error"] = "Goal with id: #arguments.id# not found for this user";
            return errorResponse;
        }

        sql = "DELETE FROM heart_nest.Goals WHERE goal_id = ? AND user_id = ?";
        queryExecute(sql, [arguments.id, userId], {dataSource = variables.dataSource});
        
        cfheader(statusCode="200", statusText="Deleted");
        var response = structNew("ordered");
        response["message"] = "Goal deleted successfully";
        return response;
    }
}
