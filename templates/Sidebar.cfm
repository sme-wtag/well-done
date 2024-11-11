<aside class="w-72 fixed h-screen py-8 px-4">
    <div class="space-y-6">
        <!-- Profile Overview -->
        <div class="text-center">
            <div class="w-20 h-20 mx-auto rounded-full bg-gradient-to-tr from-orange-200 to-orange-100 flex items-center justify-center">
                <img class="rounded-full" src="https://api.dicebear.com/9.x/thumbs/svg?seed=Mehrab" alt="Profile Picture of user" id="profilePhoto"/>
            </div>
            <h2 class="mt-4 text-lg font-medium" id="username"></h2>
            <p class="text-sm text-gray-500" id="email"></p>
            <p class="text-xs text-gray-400" id="created_at"></p>
        </div>
        
        <!-- Quick Links -->
        <div class="space-y-2">
            <!-- Home -->
            <a href="../views/Home.cfm" class="flex items-center gap-3 px-4 py-2 text-gray-700 rounded-lg hover:bg-gray-50">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
                </svg>
                <span>Home</span>
            </a>
        
            <!-- Profile -->
            <!--- <a href="#" class="flex items-center gap-3 px-4 py-2 text-gray-700 rounded-lg hover:bg-gray-50">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                </svg>
                <span>Profile</span>
            </a> --->
        
            <!-- Goals -->
            <a href="../views/Goals.cfm" class="flex items-center gap-3 px-4 py-2 text-gray-700 rounded-lg hover:bg-gray-50">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M10.125 2.25h-4.5c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125v-9M10.125 2.25h.375a9 9 0 0 1 9 9v.375M10.125 2.25A3.375 3.375 0 0 1 13.5 5.625v1.5c0 .621.504 1.125 1.125 1.125h1.5a3.375 3.375 0 0 1 3.375 3.375M9 15l2.25 2.25L15 12" />
                </svg>
                <span>Goals</span>
            </a>

            <!-- Posts -->
            <a href="../views/Posts.cfm" class="flex items-center gap-3 px-4 py-2 text-gray-700 rounded-lg hover:bg-gray-50">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z"></path>
                </svg>
                <span>Posts</span>
            </a>
        
            <!-- Followings -->
            <a href="../views/Followings.cfm" class="flex items-center gap-3 px-4 py-2 text-gray-700 rounded-lg hover:bg-gray-50">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z" />
                </svg>
                <span>Circle</span>
            </a>
        </div>
    </div>
</aside>

<script>
    document.addEventListener('DOMContentLoaded', loadUserDetails);

    function loadUserDetails() {
        // Get user data from localStorage
        const user = JSON.parse(localStorage.getItem('user')) || {};

        // Format the join date
        const formatDate = (dateString) => {
            const date = new Date(dateString);
            return date.toLocaleDateString('en-US', {
                month: 'long',
                day: '2-digit',
                year: 'numeric'
            });
        };

        // Update profile information
        document.getElementById('profilePhoto').src = `https://api.dicebear.com/9.x/thumbs/svg?seed=${user.username}`;
        document.getElementById('username').innerHTML = user.username;
        document.getElementById('email').innerHTML = user.email;
        document.getElementById('created_at').innerHTML = `Joined on ${formatDate(user.created_at)}`;

    }
    
</script>