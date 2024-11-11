component restpath="/auth" rest="true" {
    variables.dataSource = application.dataSource;

    /**
     * Sign up a new user
     */
    remote struct function signup() httpmethod="POST" restpath="sign-up" {
        try {
            var requestData = getHTTPRequestData();
            var newUser = deserializeJSON(requestData.content);
            var hashedPassword = generateArgon2Hash(newUser["password"]);
            
            newUser["password"] = hashedPassword;

            var sql = "INSERT INTO heart_nest.Users (username, email, password) VALUES (?, ?, ?)";
            queryExecute(sql, [newUser["username"], newUser["email"], newUser["password"]], {dataSource = variables.dataSource});
            
            cfheader(statusCode="201", statusText="Created");
            return {"message": "Sign-up successful"};
        } catch (any e) {
            cfheader(statusCode="500", statusText="Internal Server Error");
            return {
                "error": "Sign-up failed",
                "details": e.message
            };
        }
    }

    /**
     * Sign in an existing user and return a JWT token
     */
    remote struct function signin() httpmethod="POST" restpath="sign-in" {
        try {
            var requestData = getHTTPRequestData();
            var user = deserializeJSON(requestData.content);

            // Check if user exists
            var sql = "SELECT user_id, password FROM heart_nest.Users WHERE username = ?";
            var result = queryExecute(sql, [user["username"]], {dataSource = variables.dataSource});

            if (result.recordCount == 0) {
                cfheader(statusCode="404", statusText="Not Found");
                return {"message": "User with given username not found"};
            }

            // Check password validity
            if (!argon2CheckHash(user["password"], result.password[1])) {
                cfheader(statusCode="401", statusText="Unauthorized");
                return {"message": "Wrong password"};
            }

            // Generate JWT token using user_id
            var jwtToken = application.jwtClient.encode({"user_id": result.user_id[1], "issued_at": now()});
            
            // Store JWT in session
            session.token = jwtToken;

            cfheader(statusCode="200", statusText="OK");
            return {"user_id": result.user_id[1]};
        } catch (any e) {
            cfheader(statusCode="500", statusText="Internal Server Error");
            return {
                "error": "Sign-in failed",
                "details": e.message
            };
        }
    }

    /**
     * Sign out and remove token from session
     */
    remote struct function signout() httpmethod="POST" restpath="sign-out" {
        var tokenDeleted = structDelete(session, "token", true);
        if (tokenDeleted) {
            cfheader(statuscode="200", statustext="Success");
            return {"message": "Signed out successfully"};
        } else {
            cfheader(statuscode="400", statustext="Bad Request");
            return {"message": "Not signed in"};
        }
    }





 
}
