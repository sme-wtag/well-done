<main class="ml-80 flex-1 py-8 px-4">
    <!-- My Posts -->
    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <h2 class="text-xl font-semibold mb-4">My Posts</h2>
        <!-- Hydrate Posts -->
        <div id="postsContainer" class="space-y-6">
        </div>
    </div>
</main>


<script>
    // Load posts when page loads
    document.addEventListener('DOMContentLoaded', loadPosts);

    function loadPosts() {
        fetch('http://127.0.0.1:8888/rest/api/posts/user')
            .then(response => response.json())
            .then(posts => {
                const container = document.getElementById('postsContainer');
                container.innerHTML = posts.map(post => `
                    <div class="flex bg-white border border-gray-200 rounded-lg shadow overflow-hidden transform transition-all hover:shadow-lg">
                        <div class="w-5/6 p-6 space-y-4 flex flex-col justify-between">
                            <div>
                                <input type="hidden" name="post_id" value="${post.post_id}">
                                <div class="flex justify-between items-start mb-2">
                                    <div>
                                        <h3 class="text-lg font-bold text-gray-800">${post.username}</h3>
                                        <p class="text-sm text-gray-500">${new Date(post.created_at).toLocaleString()}</p>
                                    </div>
                                    <span class="px-3 py-1 bg-gray-100 text-gray-600 rounded-full text-sm">
                                        ${post.post_type}
                                    </span>
                                </div>
                                <div class="post-content-${post.post_id}">
                                    <p class="text-gray-600 mt-2">${post.content}</p>
                                </div>
                                <div class="post-edit-${post.post_id} hidden">
                                    <textarea 
                                        class="w-full p-2 border border-gray-200 rounded-lg mt-2 focus:outline-none focus:border-orange-500"
                                        rows="3"
                                    >${post.content}</textarea>
                                </div>
                                ${post.goal_id ? `<p class="text-sm text-gray-500 mt-2">Related to Goal ID: ${post.goal_id}</p>` : ''}
                            </div>
                            <div class="pt-4 border-t border-gray-200 flex gap-2">
                                <button onclick="toggleEdit(${post.post_id})" 
                                        class="edit-btn-${post.post_id} px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition-colors duration-200">
                                    Edit
                                </button>
                                <button onclick="updatePost(${post.post_id})" 
                                        class="save-btn-${post.post_id} hidden px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors duration-200">
                                    Save
                                </button>
                                <button onclick="cancelEdit(${post.post_id})" 
                                        class="cancel-btn-${post.post_id} hidden px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors duration-200">
                                    Cancel
                                </button>
                                <button onclick="deletePost(${post.post_id})" 
                                        class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors duration-200">
                                    Delete
                                </button>
                            </div>
                        </div>
                    </div>
                `).join('');
            })
            .catch(error => {
                console.error('Error loading posts:', error);
                alert('Error loading posts');
            });
    }

    // Toggle edit mode
    function toggleEdit(postId) {
        document.querySelector(`.post-content-${postId}`).classList.add('hidden');
        document.querySelector(`.post-edit-${postId}`).classList.remove('hidden');
        document.querySelector(`.edit-btn-${postId}`).classList.add('hidden');
        document.querySelector(`.save-btn-${postId}`).classList.remove('hidden');
        document.querySelector(`.cancel-btn-${postId}`).classList.remove('hidden');
    }

    // Cancel edit mode
    function cancelEdit(postId) {
        document.querySelector(`.post-content-${postId}`).classList.remove('hidden');
        document.querySelector(`.post-edit-${postId}`).classList.add('hidden');
        document.querySelector(`.edit-btn-${postId}`).classList.remove('hidden');
        document.querySelector(`.save-btn-${postId}`).classList.add('hidden');
        document.querySelector(`.cancel-btn-${postId}`).classList.add('hidden');
    }

    // Update post
    function updatePost(postId) {
        const content = document.querySelector(`.post-edit-${postId} textarea`).value;
        
        fetch(`http://127.0.0.1:8888/rest/api/posts/${postId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                content: content
            })
        })
        .then(response => {
            if (response.ok) {
                alert('Post updated successfully!');
                loadPosts();
            } else {
                alert('Error updating post');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Something went wrong!');
        });
    }

    // Delete post
    function deletePost(postId) {
        if (confirm("Are you sure you want to delete this post?")) {
            fetch(`http://127.0.0.1:8888/rest/api/posts/${postId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => {
                if (response.ok) {
                    alert('Post deleted successfully!');
                    loadPosts(); 
                } else {
                    alert('Error deleting post');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Something went wrong!');
            });
        }
    }
</script>