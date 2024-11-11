component restpath="/posts" rest="true" {
    variables.dataSource = application.dataSource;
    variables.utils = new utils.Utils();

    /**
     * Get all posts from user and people followed by the user
     */
    remote any function getPosts() httpmethod="GET" restpath="" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)) {
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        // SQL query to retrieve posts from the current user and the users that the current user follows
        var sql = "
            SELECT DISTINCT P.post_id, P.user_id, U.username, P.goal_id, P.content, P.post_type, P.created_at 
            FROM heart_nest.Posts P
            JOIN heart_nest.Users U ON P.user_id = U.user_id
            LEFT JOIN heart_nest.Followings F ON P.user_id = F.following AND F.followed_by = ?
            WHERE P.user_id = ? OR F.following IS NOT NULL
            ORDER BY P.created_at DESC";
        var result = queryExecute(sql, [userId, userId], {dataSource = variables.dataSource});

        var posts = [];
        for (var i = 1; i <= result.recordCount; i++) {
            var post = structNew("ordered");
            post["post_id"] = result.post_id[i];
            post["user_id"] = result.user_id[i];
            post["username"] = result.username[i];
            post["goal_id"] = result.goal_id[i];
            post["content"] = result.content[i];
            post["post_type"] = result.post_type[i];
            post["created_at"] = result.created_at[i];
            arrayAppend(posts, post);
        }

        return posts;
    }


     /**
     * Create a new post for the authenticated user
     */
    remote any function createPost() httpmethod="POST" restpath="" {
        var userId = utils.getUserContext();
        if (!isNumeric(userId)){
            cfheader(statusCode="401", statusText="Unauthorized");
            return {"error" = "Invalid or expired token"};
        }

        var requestData = getHttpRequestData();
        var newPost = deserializeJSON(requestData.content);

        var sql = "
            INSERT INTO heart_nest.Posts (user_id, content) 
            VALUES (?, ?)";
        queryExecute(sql, [
            userId, 
            newPost.content, 
        ], {dataSource = variables.dataSource});
        
        cfheader(statusCode="201", statusText="Created");
        var response = structNew("ordered");
        response["message"] = "Post created successfully";
        return response;
    }
}

