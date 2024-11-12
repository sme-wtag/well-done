<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WellDone</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50">
        <!-- Navbar -->
        <cfinclude template="../templates/Navbar.cfm">
        
    
        <!-- Main Content -->
        <div class="pt-14 max-w-6xl mx-auto flex gap-8">
            <!-- Profile Sidebar -->
            <cfinclude template="../templates/Sidebar.cfm">
            
            <!-- Posts Management -->
            <cfinclude template="../templates/ProfileManagement.cfm">
            
        </div>
    </body>
</html>