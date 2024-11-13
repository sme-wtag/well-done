component {
    // General settings
    this.name = "heart_nest";
    this.sessionManagement = true;

    // Set data source
    this.datasources["heart_nest"] = {
        class: "com.mysql.cj.jdbc.Driver", 
        bundleName: "com.mysql.cj", 
        bundleVersion: "8.4.0",
        connectionString: "jdbc:mysql://host.docker.internal:3306/heart_nest?characterEncoding=UTF-8&serverTimezone=Etc/UTC&maxReconnects=3",
        username: "mehrab",
        password: "encrypted:13183193be67d495e18ade169c76d02e452c36c62f18199b45161691725f9710",
        
        // optional settings
        connectionLimit:-1, // default:-1
        liveTimeout:15, // default: -1; unit: minutes
        alwaysSetTimeout:true, // default: false
        validate:false, // default: false
    };

    function onApplicationStart() {
        // Set REST mappings
        restInitApplication( 
                dirPath="/var/www/api",
                serviceMapping="/api",
                password="admin"
        );



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