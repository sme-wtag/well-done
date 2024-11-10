<nav class="h-14 bg-white border-b fixed w-full top-0 z-50">
    <div class="max-w-6xl mx-auto px-4 h-full">
        <div class="flex items-center justify-between h-full">
            <!-- Logo -->
            <a href="../views/home.cfm">
                <div class="text-2xl font-mono font-semibold text-orange-600">WellDone</div>
            </a>

            <!-- Right Nav Items -->
            <div class="flex items-center gap-4">
                <button id="sign-out" name="sign-out" class="h-8 w-8 rounded-full bg-gray-100 flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 9V5.25A2.25 2.25 0 0 1 10.5 3h6a2.25 2.25 0 0 1 2.25 2.25v13.5A2.25 2.25 0 0 1 16.5 21h-6a2.25 2.25 0 0 1-2.25-2.25V15m-3 0-3-3m0 0 3-3m-3 3H15" />
                    </svg>
                </button>
            </div>
        </div>
    </div>
</nav>

<script>
    document.getElementById('sign-out').addEventListener('click', function() {
        fetch('http://127.0.0.1:8888/rest/api/auth/sign-out', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.message === "Signed out successfully") {
                localStorage.removeItem('user');
                localStorage.removeItem('user_id');
                
                window.location.href = '../index.cfm';
            } else {
                alert("Sign-out failed. Please try again.");
            }
        })
        .catch(error => console.error('Error:', error));
    });
</script>
