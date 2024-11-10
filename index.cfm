<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WellDone</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    
    
        <!-- Authentication Management -->
        <cfinclude template="templates/AuthManagement.cfm">
    
        <script>
            // Already Logged In
            if (localStorage.getItem('user')) {
                window.location.href = 'views/home.cfm';
            }
        </script>
    </body>
    </html>