<main class="ml-80 flex-1 py-8 px-4">
    <!-- Goal Creation Form -->
    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <h2 class="text-xl font-semibold mb-4">Create a New Goal</h2>
        <form id="goalForm" onsubmit="submitGoal(event)">
            <div class="flex flex-col gap-4">
                <!-- Goal Title -->
                <div class="flex flex-col">
                    <label for="goalTitle" class="text-sm font-medium text-gray-700">Goal Title</label>
                    <input 
                        type="text" 
                        id="goalTitle" 
                        name="goalTitle" 
                        required 
                        class="bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border"
                        placeholder="Enter your goal title">
                </div>

                <!-- Goal Type -->
                <div class="flex flex-col">
                    <label for="goalStatus" class="text-sm font-medium text-gray-700">Goal Status</label>
                    <select 
                        id="goalStatus" 
                        name="goalStatus" 
                        required 
                        class="bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border">
                        <option value="Planned">Planned</option>
                        <option value="InProgress">In Progress</option>
                    </select>
                </div>

                <!-- Submit Button -->
                <button 
                    type="submit" 
                    class="bg-orange-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-orange-700 transition-colors duration-200 mt-4">
                    Create Goal
                </button>
            </div>
        </form>
    </div>
    
    <!-- My Goals -->
    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <h2 class="text-xl font-semibold mb-4">My Goals</h2>
        <!-- Goals will be rendered here -->
        <div id="goalsContainer" class="space-y-6">
        </div>
    </div>
</main>

<script>
    // Load goals when page loads
    document.addEventListener('DOMContentLoaded', loadGoals);

    function loadGoals() {
        fetch('http://127.0.0.1:8888/rest/api/goals')
            .then(response => response.json())
            .then(goals => {
                const container = document.getElementById('goalsContainer');
                container.innerHTML = goals.map(goal => `
                    <div class="flex bg-white border border-gray-200 rounded-lg shadow overflow-hidden transform transition-all hover:shadow-lg">
                        <div class="w-1/3 bg-gray-100 flex items-center justify-center">
                            <img src="https://api.dicebear.com/9.x/shapes/svg?seed=${goal.title}" alt="Goal Image" class="object-cover w-full h-full" />
                        </div>
                        <div class="w-2/3 p-6 space-y-4 flex flex-col justify-between">
                            <input type="hidden" name="goal_id" value="${goal.goal_id}">
                            <h3 class="text-2xl font-bold text-gray-800 mb-2">${goal.title}</h3>
                            <p class="text-md text-gray-600"><strong>Status:</strong> ${goal.status}</p>
                            <p class="text-md text-gray-600"><strong>Created At:</strong> ${new Date(goal.created_at).toLocaleDateString()}</p>
                            <p class="text-md text-gray-600">
                                <strong>Completed At:</strong> 
                                ${goal.completed_at ? new Date(goal.completed_at).toLocaleDateString() : 'Not Completed'}
                            </p>
                            <div class="pt-4 border-t border-gray-200">
                                <button onclick="deleteGoal(${goal.goal_id})" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">Delete</button>
                            </div>
                        </div>
                    </div>
                `).join('');
            })
            .catch(error => {
                console.error('Error loading goals:', error);
                alert('Error loading goals');
            });
    }

    function submitGoal(event) {
        event.preventDefault();  
        
        const goalTitle = document.getElementById('goalTitle').value;
        const goalStatus = document.getElementById('goalStatus').value;
        
        fetch('http://127.0.0.1:8888/rest/api/goals', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                title: goalTitle,
                status: goalStatus
            })
        })
        .then(response => {
            if (response.ok) {
                alert('Goal created successfully!');
                loadGoals(); 
                document.getElementById('goalForm').reset();
            } else {
                alert('Error creating goal');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Something went wrong!');
        });
    }

    // Delete goal
    function deleteGoal(goalId) {
        if (confirm("Are you sure you want to delete this goal?")) {
            fetch(`http://127.0.0.1:8888/rest/api/goals/${goalId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => {
                if (response.ok) {
                    alert('Goal deleted successfully!');
                    loadGoals(); 
                } else {
                    alert('Error deleting goal');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Something went wrong!');
            });
        }
    }


</script>
