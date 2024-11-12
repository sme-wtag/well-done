<main class="ml-80 flex-1 py-8 px-4">
    <!-- User Profile Header -->
    <div class="bg-white rounded-xl p-6 shadow-sm mb-6">
        <div class="flex items-start gap-8">            
            <!-- Profile Info -->
            <div class="flex-1">                
                <h2 class="text-xl font-semibold mb-4">Stats</h2>
                <!-- Stats Grid -->
                <div class="grid grid-cols-4 gap-4 mt-6">
                    <div class="bg-orange-50 rounded-lg p-4 text-center">
                        <p class="text-2xl font-bold text-orange-600" id="followersCount">-</p>
                        <p class="text-sm text-gray-600">Followers</p>
                    </div>
                    <div class="bg-orange-50 rounded-lg p-4 text-center">
                        <p class="text-2xl font-bold text-orange-600" id="followingCount">-</p>
                        <p class="text-sm text-gray-600">Following</p>
                    </div>
                    <div class="bg-orange-50 rounded-lg p-4 text-center">
                        <p class="text-2xl font-bold text-orange-600" id="totalGoals">-</p>
                        <p class="text-sm text-gray-600">Total Goals</p>
                    </div>
                    <div class="bg-orange-50 rounded-lg p-4 text-center">
                        <p class="text-2xl font-bold text-orange-600" id="completedGoals">-</p>
                        <p class="text-sm text-gray-600">Completed</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Progress Section -->
    <div class="bg-white rounded-xl p-6 shadow-sm mb-6">
        <h2 class="text-xl font-semibold mb-4">Progress Overview</h2>
        <div class="relative pt-1">
            <div class="flex mb-2 items-center justify-between">
                <div>
                    <span id="completionRate" class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full text-orange-600 bg-orange-200">
                    </span>
                </div>
            </div>
            <div class="overflow-hidden h-2 mb-4 text-xs flex rounded bg-orange-200">
                <div id="progressBar" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-orange-500 transition-all duration-500">
                </div>
            </div>
        </div>
    </div>

</main>


<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Get user data from localStorage
        const user = JSON.parse(localStorage.getItem('user')) || {};
        loadUserProfile(user.user_id);

    });

    function loadUserProfile(userId) {
        fetch(`http://127.0.0.1:8888/rest/api/users/${userId}`)
            .then(response => response.json())
            .then(user => {
                                
                // Set stats
                document.getElementById('followersCount').textContent = user.followers_count;
                document.getElementById('followingCount').textContent = user.followings_count;
                document.getElementById('totalGoals').textContent = user.total_goals;
                document.getElementById('completedGoals').textContent = user.completed_goals;

                // Calculate and set progress
                const completionRate = user.total_goals > 0 
                    ? Math.round((user.completed_goals / user.total_goals) * 100) 
                    : 0;
                document.getElementById('completionRate').textContent = `${completionRate}% Goals Complete`;
                document.getElementById('progressBar').style.width = `${completionRate}%`;
            })
            .catch(error => {
                console.error('Error loading user profile:', error);
                alert('Error loading user profile');
            });
    }

    
</script>