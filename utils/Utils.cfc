
component output = "false"{

    public any function init() {
		return( this );
	}

    /**
     * Validate JWT from session and check expiry
     */
    public any function getUserContext() {
        if (!structKeyExists(session, "token")){
            return false
        }

        var token = session.token;
        
        try {
            var payload = application.jwtClient.decode(token);
            // Check if issued_at is within allowed time frame (8 hours)
            if (DateDiff("s", payload.issued_at, now()) > 28800) {
                return false;
            }

            return payload.user_id;
        } catch (any e) {
            return false;
        }

    }
}