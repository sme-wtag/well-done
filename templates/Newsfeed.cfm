<main class="ml-80 flex-1 py-8 px-4">
    <!-- Create Post -->
    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <div class="flex gap-4">
            <div class="w-10 h-10 rounded-full bg-orange-100 flex items-center justify-center">
                <img id="createPostUserPic" class="rounded-full" alt="Profile Picture" />
            </div>
            
            <div class="flex-1">
                <textarea 
                id="postContent" 
                rows="3" 
                class="w-full bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border mb-3" 
                placeholder="Share your thoughts..."
                ></textarea>
                
                <div class="flex justify-end">
                    <button 
                    onclick="createPost()" 
                    class="bg-orange-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-orange-700 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                    id="postButton"
                    >
                    Post
                </button>
            </div>
        </div>
    </div>
</div>
<!-- Goal Selection (Might Move To Goals Management) -->
<div class="bg-white rounded-xl p-4 shadow-sm mb-6">
    <div class="flex gap-4">
        <div class="w-10 h-10 rounded-full bg-orange-100 flex items-center justify-center">
            <img id="userProfilePic" class="rounded-full" alt="Profile Picture of user" />
        </div>
        
        <div class="flex-1 flex items-center gap-3">
            <select id="goalSelect" class="flex-1 bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border">
                <option value="">Select a goal to complete...</option>
            </select>
            
            <button 
            onclick="completeGoal()" 
            class="bg-orange-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-orange-700 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
            id="completeButton"
            disabled
            >
            Mark Complete
        </button>
    </div>
    </div>
</div>

<!-- Feed Items -->
<div id="postsContainer" class="space-y-6">
    <!-- Posts will be dynamically inserted here -->
</div>

<script>
        // Initialize state
        let goals = [];
        let posts = [];
        const API_BASE = 'http://127.0.0.1:8888/rest/api';

        // Fetch user profile picture
        function setUserProfilePic(username) {
            document.getElementById('userProfilePic').src = `https://api.dicebear.com/9.x/thumbs/svg?seed=${username}`;
        }

        // Fetch goals
        async function fetchGoals() {
            try {
                const response = await fetch(`${API_BASE}/goals`);
                const data = await response.json();
                goals = data.filter(goal => goal.status !== 'Completed');
                renderGoals();
            } catch (error) {
                console.error('Error fetching goals:', error);
            }
        }

        // Render goals in select
        function renderGoals() {
            const select = document.getElementById('goalSelect');
            const options = goals.map(goal => 
                `<option value="${goal.goal_id}">${goal.title}</option>`
            ).join('');
            select.innerHTML = '<option value="">Select a goal to complete...</option>' + options;
        }

        // Fetch posts
        async function fetchPosts() {
            try {
                const response = await fetch(`${API_BASE}/posts`);
                posts = await response.json();
                renderPosts();
            } catch (error) {
                console.error('Error fetching posts:', error);
            }
        }

        // Fetch reactions for a post
        async function fetchReactions(postId) {
            try {
                const response = await fetch(`${API_BASE}/reactions/post/${postId}`);
                return await response.json();
            } catch (error) {
                console.error('Error fetching reactions:', error);
                return [];
            }
        }

        // Render posts
        async function renderPosts() {
            const container = document.getElementById('postsContainer');
            let postsHTML = '';

            for (const post of posts) {
                const reactions = await fetchReactions(post.post_id);
                const reactionCounts = {
                    Celebrate: 0,
                    Support: 0,
                    Encourage: 0,
                    Appreciate: 0,
                    Inspire: 0
                };

                reactions.forEach(reaction => {
                    reactionCounts[reaction.type]++;
                });

                const date = new Date(post.created_at);
                const formattedDate = date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
                const formattedTime = date.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });

                postsHTML += `
                    <article class="bg-white rounded-xl p-4 shadow-sm">
                        <div class="flex items-center gap-3 mb-4">
                            <div class="w-10 h-10 rounded-full bg-orange-100 flex items-center justify-center">
                                <img class="rounded-full" src="https://api.dicebear.com/9.x/thumbs/svg?seed=${post.username}" alt="Profile Picture" />
                            </div>
                            <div>
                                <h3 class="text-sm font-medium">${post.username}</h3>
                                <p class="text-xs text-gray-500">${formattedDate} at ${formattedTime}</p>
                            </div>
                        </div>
                        <p class="text-gray-600 mb-4">${post.content}</p>
                        <div class="flex flex-wrap items-center gap-4 text-sm text-gray-500">
                            <!-- Reaction buttons -->
                            ${renderReactionButton(post.post_id, 'Celebrate', reactionCounts.Celebrate)}
                            ${renderReactionButton(post.post_id, 'Support', reactionCounts.Support)}
                            ${renderReactionButton(post.post_id, 'Encourage', reactionCounts.Encourage)}
                            ${renderReactionButton(post.post_id, 'Appreciate', reactionCounts.Appreciate)}
                            ${renderReactionButton(post.post_id, 'Inspire', reactionCounts.Inspire)}
                        </div>
                    </article>
                `;
            }
            container.innerHTML = postsHTML;
        }

        // Helper function to render reaction buttons
        function renderReactionButton(postId, type, count) {
            const icons = {
                Celebrate: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>',
                Support: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L7 11v9m7-10h-2M7 20H5a2 2 0 01-2-2v-6a2 2 0 012-2h2.5"></path>',
                Encourage: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>',
                Appreciate: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>',
                Inspire: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.879 16.121A3 3 0 1012.015 11L11 14H9c0 .768.293 1.536.879 2.121z"></path>'
            };

            return `
                <button title="${type}" onclick="sendReaction('${postId}', '${type}')" 
                        class="flex items-center gap-2 hover:text-gray-900 bg-gray-50 px-3 py-1.5 rounded-full transition-colors duration-200">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        ${icons[type]}
                    </svg>
                    <span class="ml-1 px-2 py-0.5 bg-gray-100 rounded-full text-xs font-medium">
                        ${count}
                    </span>
                </button>
            `;
        }

        // Complete goal
        async function completeGoal() {
            const goalSelect = document.getElementById('goalSelect');
            const goalId = goalSelect.value;
            if (!goalId) return;
            
            try {
                const response = await fetch(`${API_BASE}/goals/${goalId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        title: goalSelect.options[goalSelect.selectedIndex].text,
                        status: 'Completed',
                        completed_at: new Date().toISOString().split('T')[0]
                    })
                });
                
                if (response.ok) {
                    location.reload();
                }
            } catch (error) {
                console.error('Error completing goal:', error);
            }
        }

        // Send reaction
        async function sendReaction(postId, reactionType) {
            try {
                const response = await fetch(`${API_BASE}/reactions/${postId}/react`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ type: reactionType })
                });
                
                if (response.ok) {
                    location.reload();
                }
            } catch (error) {
                console.error('Error sending reaction:', error);
            }
        }

        // Initialize the page
        document.addEventListener('DOMContentLoaded', () => {
            // Get user data from localStorage
            const user = JSON.parse(localStorage.getItem('user')) || {};
            setUserProfilePic(user.username);
            
            fetchGoals();
            fetchPosts();

            // Setup goal select event listener
            document.getElementById('goalSelect').addEventListener('change', function() {
                document.getElementById('completeButton').disabled = !this.value;
            });
        });

        // Create new post
        async function createPost() {
            const content = document.getElementById('postContent').value.trim();
            if (!content) return;
            
            try {
                const response = await fetch(`${API_BASE}/posts`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ content })
                });
                
                if (response.ok) {
                    document.getElementById('postContent').value = ''; // Clear textarea
                    await fetchPosts(); // Refresh posts
                }
            } catch (error) {
                console.error('Error creating post:', error);
            }
        }

        // Update the DOMContentLoaded event listener to include setting the create post user picture
        document.addEventListener('DOMContentLoaded', () => {
            // Get user data from localStorage
            const user = JSON.parse(localStorage.getItem('user')) || {};
            setUserProfilePic(user.username);
            
            // Set create post user picture
            document.getElementById('createPostUserPic').src = `https://api.dicebear.com/9.x/thumbs/svg?seed=${user.username}`;
            
            fetchGoals();
            fetchPosts();

            // Setup goal select event listener
            document.getElementById('goalSelect').addEventListener('change', function() {
                document.getElementById('completeButton').disabled = !this.value;
            });

            // Setup post content event listener
            document.getElementById('postContent').addEventListener('input', function() {
                document.getElementById('postButton').disabled = !this.value.trim();
            });
        });

    </script>
</main>