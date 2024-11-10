component {

    this.name = "heart_nest";
    this.sessionManagement = true;

    function onApplicationStart() {
        // Set data source
        application.dataSource = "heart_nest";

        // Read env.json
        try {   
            var envPath = expandPath("env.json");
            var envData = fileRead(envPath);
            variables.env = deserializeJSON(envData);
        } catch (any e) {
            throw(type="ApplicationError", message="Failed to read env.json: " & e.message);
        }

        // Initialize JWT Client & Set Mode
        try {
            application.jwtClient = new lib.JsonWebTokens().createClient("HS256", variables.env.secret_key);
            application.mode = variables.env.mode;
        } catch (any e) {
            throw(type="ApplicationError", message="Failed to create JWT client: " & e.message);
        }

        return true;
    }
    



}