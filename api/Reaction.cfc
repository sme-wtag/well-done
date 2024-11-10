component restpath="/reactions" rest="true" {
    variables.dataSource = application.dataSource;
    variables.utils = new utils.Utils();

    /**
     * Get all reactions for a specific post
     */
    remote any function getReactions(required numeric postId restargsource="Path") httpmethod="GET" restpath="/post/{postId}" {
        var sql = "SELECT * FROM heart_nest.Reactions WHERE post_id = ?";
        var result = queryExecute(sql, [arguments.postId], {dataSource = variables.dataSource});
        
        var reactions = [];
        for (var i = 1; i <= result.recordCount; i++) {
            var reaction = structNew("ordered");
            reaction["reaction_id"] = result.reaction_id[i];
            reaction["post_id"] = result.post_id[i];
            reaction["user_id"] = result.user_id[i];
            reaction["type"] = result.type[i];
            reaction["created_at"] = result.created_at[i];
            arrayAppend(reactions, reaction);
        }
                
        return reactions;
    }

    /**
     * Create or update a reaction on a post
     */
    remote any function createOrUpdateReaction(required numeric postId restargsource="Path") httpmethod="POST" restpath="/{postId}/react" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var requestData = getHttpRequestData();
        var reactionType = deserializeJSON(requestData.content)["type"];

        var validReactions = ["Celebrate", "Support", "Encourage", "Appreciate", "Inspire"];
        
        // Guard clause for invalid reaction types
        if (!arrayFindNoCase(validReactions, reactionType)) {
            cfheader(statusCode="400", statusText="Bad Request");
            return { "error" = "Invalid reaction type. Must be one of: " & arrayToList(validReactions, ", ") };
        }

        // Check if the user has already reacted to this post
        var existingReaction = queryExecute(
            "SELECT reaction_id FROM heart_nest.Reactions WHERE post_id = ? AND user_id = ?", 
            [arguments.postId, userId], 
            {dataSource = variables.dataSource}
        );

        if (existingReaction.recordCount > 0) {
            // Update existing reaction
            queryExecute(
                "UPDATE heart_nest.Reactions SET type = ?, created_at = CURRENT_TIMESTAMP WHERE reaction_id = ?", 
                [reactionType, existingReaction.reaction_id[1]], 
                {dataSource = variables.dataSource}
            );
            
            return { "message" = "Reaction updated successfully", "reactionType" = reactionType };
        } else {
            // Create new reaction
            queryExecute(
                "INSERT INTO heart_nest.Reactions (post_id, user_id, type) VALUES (?, ?, ?)", 
                [arguments.postId, userId, reactionType], 
                {dataSource = variables.dataSource}
            );

            return { "message" = "Reaction created successfully", "reactionType" = reactionType };
        }
    }

    /**
     * Delete a reaction by reaction_id
     */
    remote any function deleteReaction(required numeric reactionId restargsource="Path") httpmethod="DELETE" restpath="/{reactionId}" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var sql = "SELECT * FROM heart_nest.Reactions WHERE reaction_id = ? AND user_id = ?";
        var result = queryExecute(sql, [arguments.reactionId, userId], {dataSource = variables.dataSource});
        
        if (result.recordCount == 0) {
            cfheader(statusCode="404", statusText="Not Found");
            var errorResponse = structNew("ordered");
            errorResponse["error"] = "Reaction not found or you do not have permission to delete it.";
            return errorResponse;
        }

        sql = "DELETE FROM heart_nest.Reactions WHERE reaction_id = ?";
        queryExecute(sql, [arguments.reactionId], {dataSource = variables.dataSource});
        
        cfheader(statusCode="200", statusText="Deleted");
        var response = structNew("ordered");
        response["message"] = "Reaction deleted successfully";
        return response;
    }
}
