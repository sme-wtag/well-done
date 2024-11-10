<main class="ml-80 flex-1 py-8 px-4">
    <!-- Search Users by Username -->
    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <h2 class="text-xl font-semibold mb-4">Search for Users</h2>
        <form id="userSearchForm" onsubmit="searchUsers(); return false;">
            <input type="text" id="usernameInput" placeholder="Enter username" class="border p-2 rounded-lg w-1/2" />
            <button type="submit" class="ml-2 px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700">Search</button>
        </form>
        
        <!-- Search Results -->
        <div id="userResults" class="space-y-6">
            <!--- Hydrate Search Results --->
        </div>

    </div>
        
    <!-- My Followings -->
    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <h2 class="text-xl font-semibold mb-4">My Followings</h2>
        <div id="followingsContainer" class="space-y-6">
            <!-- Hydrate Following List -->
        </div>
    </div>

    <!-- My Followers -->
    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <h2 class="text-xl font-semibold mb-4">My Followers</h2>
        <div id="followersContainer" class="space-y-6">
            <!-- Hydrate Follower List -->
        </div>
    </div>
</main>

<cfoutput>
<script>
    // Trigger Following and Follower List Hydrate
    document.addEventListener("DOMContentLoaded", function() {
        loadFollowings();
        loadFollowers();
    });

    // Function to load followings
    async function loadFollowings() {
        const apiUrl = `http://127.0.0.1:8888/rest/api/followings/followings/`;

        try {
            const response = await fetch(apiUrl, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (response.ok) {
                const followings = await response.json();
                displayFollowings(followings);
            } else {
                console.error("Failed to fetch followings:", response.statusText);
            }
        } catch (error) {
            console.error("Error fetching followings:", error);
        }
    }

    // Function to display followings as cards
    function displayFollowings(followings) {
        const followingsContainer = document.getElementById("followingsContainer");
        followingsContainer.innerHTML = ""; 

        followings.forEach(following => {
            const followingCard = `
                <div class="flex bg-white border border-gray-200 rounded-lg shadow overflow-hidden transform transition-all hover:shadow-lg">
                    <!-- Left Side: Profile Image -->
                    <div class="w-1/3 bg-gray-100 flex items-center justify-center">
                        <img src="https://api.dicebear.com/9.x/thumbs/svg?seed=${following.username}" alt="Profile Picture of ${following.username}" class="object-cover w-full h-full" />
                    </div>

                    <!-- Right Side: User Details and Unfollow Button -->
                    <div class="w-2/3 p-6 space-y-4 flex flex-col justify-between">
                        <h3 class="text-2xl font-bold text-gray-800">${following.username}</h3>
                        <p class="text-md text-gray-600"><strong>Email:</strong> ${following.email}</p>
                        <p class="text-md text-gray-600"><strong>Following since:</strong> ${new Date(following.followed_since).toLocaleDateString()}</p>
                        
                        <!-- Unfollow Button -->
                        <div class="pt-4 border-t border-gray-200">
                            <button onclick="unfollowUser(${following.user_id});" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">Unfollow</button>
                        </div>
                    </div>
                </div>
            `;

            followingsContainer.innerHTML += followingCard;
        });
    }

        
    // Function to load followers
    async function loadFollowers() {
        const apiUrl = `http://127.0.0.1:8888/rest/api/followings/followers/`;

        try {
            const response = await fetch(apiUrl, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (response.ok) {
                const followers = await response.json();
                displayFollowers(followers);
            } else {
                console.error("Failed to fetch followers:", response.statusText);
            }
        } catch (error) {
            console.error("Error fetching followers:", error);
        }
    }

        // Function to display followers as cards
        function displayFollowers(followers) {
        const followersContainer = document.getElementById("followersContainer");
        followersContainer.innerHTML = ""; 

        followers.forEach(follower => {
            const followerCard = `
                <div class="flex bg-white border border-gray-200 rounded-lg shadow overflow-hidden transform transition-all hover:shadow-lg">
                    <!-- Left Side: Profile Image -->
                    <div class="w-1/3 bg-gray-100 flex items-center justify-center">
                        <img src="https://api.dicebear.com/9.x/thumbs/svg?seed=${follower.username}" alt="Profile Picture of ${follower.username}" class="object-cover w-full h-full" />
                    </div>

                    <!-- Right Side: User Details and Remove Button -->
                    <div class="w-2/3 p-6 space-y-4 flex flex-col justify-between">
                        <h3 class="text-2xl font-bold text-gray-800">${follower.username}</h3>
                        <p class="text-md text-gray-600"><strong>Email:</strong> ${follower.email}</p>
                        <p class="text-md text-gray-600"><strong>Follower since:</strong> ${new Date(follower.followed_since).toLocaleDateString()}</p>
                        
                        <!-- Remove Button -->
                        <div class="pt-4 border-t border-gray-200">
                            <button onclick="removeFollower(${follower.user_id});" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">Remove</button>
                        </div>
                    </div>
                </div>
            `;

            followersContainer.innerHTML += followerCard;
        });
    }


    // Function to unfollow a user
    async function unfollowUser(followingId) {
        const apiUrl = `http://127.0.0.1:8888/rest/api/followings/${followingId}`;

        try {
            const response = await fetch(apiUrl, {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (response.ok) {
                location.reload();
            } else {
                console.error("Failed to unfollow:", response.statusText);
            }
        } catch (error) {
            console.error("Error unfollowing:", error);
        }
    }

    // Function to remove a follower
    async function removeFollower(followerId) {
        const apiUrl = `http://127.0.0.1:8888/rest/api/followings/remove/${followerId}`;

        try {
            const response = await fetch(apiUrl, {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (response.ok) {
                location.reload();
            } else {
                console.error("Failed to remove follower:", response.statusText);
            }
        } catch (error) {
            console.error("Error removing follower:", error);
        }
    }

    // Function to search for users
    function searchUsers() {
        var username = document.getElementById("usernameInput").value;
        if (username.trim() === "") {
            alert("Please enter a username to search.");
            return;
        }

        fetch(`http://127.0.0.1:8888/rest/api/users?username=${username}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.length == 0) {
                document.getElementById("userResults").innerHTML = `<p class="text-red-600">No users found with name: ${username}</p>`;
            } else {
                displayUsers(data);
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("Something went wrong with the search.");
        });
    }

    // Function to display users as cards
    function displayUsers(users) {
        var resultsDiv = document.getElementById("userResults");
        resultsDiv.innerHTML = ""; 

        users.forEach(user => {
            var userCard = `
                <h2 class="text-xl font-semibold mb-4">Search Results</h2>
                <div class="flex bg-white border border-gray-200 rounded-lg shadow overflow-hidden transform transition-all hover:shadow-lg">
                    <!-- Left Side: Profile Image -->
                    <div class="w-1/3 bg-gray-100 flex items-center justify-center">
                        <img src="https://api.dicebear.com/9.x/thumbs/svg?seed=${user.username}" alt="Profile Picture of user" class="object-cover w-full h-full" />
                    </div>

                    <!-- Right Side: User Details and Follow Button -->
                    <div class="w-2/3 p-6 space-y-4 flex flex-col justify-between">
                        <h3 class="text-2xl font-bold text-gray-800 mb-2">${user.username}</h3>
                        <p class="text-md text-gray-600"><strong>Email:</strong> ${user.email}</p>
                        <p class="text-md text-gray-600"><strong>Joined:</strong> ${new Date(user.created_at).toLocaleDateString()} </p>
                        
                        <!-- Follow Button -->
                        <div class="pt-4 border-t border-gray-200">
                            <button onclick="followUser(${user.user_id});" class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">Follow</button>
                        </div>
                    </div>
                </div>
            `;
            resultsDiv.innerHTML += userCard;
        });
    }

    // Function to follow a user
    function followUser(followingId) {
        fetch(`http://127.0.0.1:8888/rest/api/followings/${followingId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.message) {
                location.reload();
            } else if (data.error) {
                alert(data.error);
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("Something went wrong while trying to follow.");
        });
    }
</script>
</cfoutput>