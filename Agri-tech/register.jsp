<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agri-Tech | Register</title> <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-green: #2e7d32;
            --accent-blue: #1e88e5;
            --glass-bg: rgba(255, 255, 255, 0.9);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url('images/register.jpg') no-repeat center center/cover;
            min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 20px;
        }
        .container {
            width: 100%; max-width: 450px; background: var(--glass-bg);
            padding: 40px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }
        h2 { text-align: center; color: var(--primary-green); margin-bottom: 25px; font-weight: 600; }
        .form-group { margin-bottom: 15px; }
        input, select {
            width: 100%; padding: 12px 15px; border-radius: 10px; border: 1px solid #ddd;
            font-size: 15px; outline: none; transition: 0.3s;
        }
        input:focus { border-color: var(--primary-green); box-shadow: 0 0 5px rgba(46, 125, 50, 0.2); }
        button {
            width: 100%; padding: 14px; background: var(--primary-green); color: white;
            border: none; border-radius: 10px; cursor: pointer; font-size: 16px; font-weight: 600;
            transition: 0.3s; margin-top: 10px;
        }
        button:hover { background: #1b5e20; transform: translateY(-2px); }
        .login-link { text-align: center; margin-top: 20px; font-size: 14px; color: #666; }
        .login-link a { color: var(--accent-blue); text-decoration: none; font-weight: 600; }
        
        /* Pro Tip: Error Message Styling */
        #error-msg {
            background: #ffebee; color: #c62828; padding: 10px; border-radius: 8px;
            font-size: 12px; margin-bottom: 15px; display: none; text-align: center;
        }
    </style>
    
    <script>
        function validateForm() {
            var pass = document.getElementById("password").value;
            var confirm = document.getElementById("confirm").value;
            var error = document.getElementById("error-msg");
            
            // Rule: Min 8 chars, at least one letter and one number
            var regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

            if (!regex.test(pass)) {
                error.innerText = "Password must be at least 8 characters with letters and numbers.";
                error.style.display = "block";
                return false;
            }
            if (pass !== confirm) {
                error.innerText = "Passwords do not match.";
                error.style.display = "block";
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
   
    <div class="container">
        <h2>Join Agri-Tech</h2>
        
        <div id="error-msg"></div>

        <form action="RegisterServlet" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <input type="text" name="name" placeholder="Full Name" required>
            </div>
            <div class="form-group">
                <input type="email" name="email" placeholder="Email Address" required>
            </div>
            
            <div class="form-group">
                <input type="password" name="password" id="password" placeholder="Create Password" required>
            </div>
            
            <div class="form-group">
                <input type="password" name="confirm" id="confirm" placeholder="Confirm Password" required>
            </div>
            <div class="form-group" style="margin-top: 15px;">
    <label>Security Question (For Password Recovery)</label>
    <select name="security_question" required style="width: 100%; padding: 10px; border-radius: 5px;">
        <option value="What is your favorite crop?">What is your favorite crop?</option>
        <option value="What was your first pet's name?">What was your first pet's name?</option>
        <option value="In which city were you born?">In which city were you born?</option>
    </select>
</div>

<div class="form-group" style="margin-top: 15px;">
    <label>Security Answer</label>
    <input type="text" name="security_answer" placeholder="Answer is case-sensitive" required 
           style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
</div>

            <div class="form-group">
                <select name="role" required>
                    <option value="" disabled selected>Select Your Role</option>
                    <option value="farmer">Farmer</option>
                    <option value="admin">Admin</option> </select>
            </div>
            <div class="form-group">
                <input type="text" name="phone" placeholder="Phone Number" required>
            </div>
            
            <button type="submit">Create Account</button>
            <div class="login-link">Already have an account? <a href="login.jsp">Login here</a></div>
        </form>
    </div>
</body>
</html>