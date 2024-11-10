<div class="max-w-md w-full space-y-8">
    <!-- Logo/Header -->
    <div class="text-center">
        <h1 class="text-4xl font-bold text-orange-600">WellDone</h1>
        <p class="mt-2 text-gray-600">"Appreciation is just one step away, <br> bringing warmth to every goal we reach."</p>
    </div>

    <!-- Tabs -->
    <div class="bg-white rounded-xl shadow-sm p-6">
        <div class="flex border-b border-gray-200 mb-6">
            <button onclick="switchTab('signin')" id="signinTab" class="flex-1 py-2 text-center font-medium text-orange-600 border-b-2 border-orange-600">
                Sign In
            </button>
            <button onclick="switchTab('signup')" id="signupTab" class="flex-1 py-2 text-center font-medium text-gray-500">
                Sign Up
            </button>
        </div>

        <!-- Sign In Form -->
        <form id="signinForm" class="space-y-4" onsubmit="handleSignIn(event)">
            <div>
                <label for="signin-username" class="text-sm font-medium text-gray-700">Username</label>
                <input 
                    type="text" 
                    id="signin-username" 
                    name="username" 
                    required 
                    class="mt-1 block w-full bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border"
                    placeholder="Enter your username">
            </div>
            <div>
                <label for="signin-password" class="text-sm font-medium text-gray-700">Password</label>
                <input 
                    type="password" 
                    id="signin-password" 
                    name="password" 
                    required 
                    class="mt-1 block w-full bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border"
                    placeholder="Enter your password">
            </div>
            <button 
                type="submit" 
                class="w-full bg-orange-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-orange-700 transition-colors duration-200">
                Sign In
            </button>
        </form>

        <!-- Sign Up Form -->
        <form id="signupForm" class="space-y-4 hidden" onsubmit="handleSignUp(event)">
            <div>
                <label for="signup-username" class="text-sm font-medium text-gray-700">Username</label>
                <input 
                    type="text" 
                    id="signup-username" 
                    name="username" 
                    required 
                    class="mt-1 block w-full bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border"
                    placeholder="Choose a username">
            </div>
            <div>
                <label for="signup-email" class="text-sm font-medium text-gray-700">Email</label>
                <input 
                    type="email" 
                    id="signup-email" 
                    name="email" 
                    required 
                    class="mt-1 block w-full bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border"
                    placeholder="Enter your email">
            </div>
            <div>
                <label for="signup-password" class="text-sm font-medium text-gray-700">Password</label>
                <input 
                    type="password" 
                    id="signup-password" 
                    name="password" 
                    required 
                    class="mt-1 block w-full bg-gray-50 rounded-lg px-4 py-2 text-sm focus:outline-none border-gray-200 border"
                    placeholder="Choose a password">
            </div>
            <button 
                type="submit" 
                class="w-full bg-orange-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-orange-700 transition-colors duration-200">
                Sign Up
            </button>
        </form>
    </div>
</div>

<script>
    function switchTab(tab) {
        const signinForm = document.getElementById('signinForm');
        const signupForm = document.getElementById('signupForm');
        const signinTab = document.getElementById('signinTab');
        const signupTab = document.getElementById('signupTab');

        if (tab === 'signin') {
            signinForm.classList.remove('hidden');
            signupForm.classList.add('hidden');
            signinTab.classList.add('text-orange-600', 'border-b-2', 'border-orange-600');
            signinTab.classList.remove('text-gray-500');
            signupTab.classList.remove('text-orange-600', 'border-b-2', 'border-orange-600');
            signupTab.classList.add('text-gray-500');
        } else {
            signupForm.classList.remove('hidden');
            signinForm.classList.add('hidden');
            signupTab.classList.add('text-orange-600', 'border-b-2', 'border-orange-600');
            signupTab.classList.remove('text-gray-500');
            signinTab.classList.remove('text-orange-600', 'border-b-2', 'border-orange-600');
            signinTab.classList.add('text-gray-500');
        }
    }

    async function handleSignIn(event) {
        event.preventDefault();
        
        const username = document.getElementById('signin-username').value;
        const password = document.getElementById('signin-password').value;

        try {
            // Initial sign-in request
            const signInResponse = await fetch('http://127.0.0.1:8888/rest/api/auth/sign-in', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    username: username,
                    password: password
                })
            });

            const signInData = await signInResponse.json();

            if (signInResponse.ok) {

                const userResponse = await fetch(`http://127.0.0.1:8888/rest/api/users/${signInData.user_id}`, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });

                const userData = await userResponse.json();

                if (userResponse.ok) {
                    localStorage.setItem('user', JSON.stringify(userData));
                    
                    window.location.href = '/views/home.cfm';
                } else {
                    alert('Failed to fetch user details');
                }
            } else {
                alert(signInData.message || 'Sign in failed');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Something went wrong!');
        }
    }

    async function handleSignUp(event) {
        event.preventDefault();
        
        const username = document.getElementById('signup-username').value;
        const email = document.getElementById('signup-email').value;
        const password = document.getElementById('signup-password').value;

        try {
            const response = await fetch('http://127.0.0.1:8888/rest/api/auth/sign-up', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    username: username,
                    email: email,
                    password: password
                })
            });

            const data = await response.json();

            if (response.ok) {
                alert('Sign up successful! Please sign in.');
                switchTab('signin');
            } else {
                alert(data.message || 'Sign up failed');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Something went wrong!');
        }
    }
</script>
</body>