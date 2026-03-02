<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agri-Tech | Login</title> <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary-green: #2e7d32; --accent-blue: #1e88e5; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('images/seed.jpg') no-repeat center center/cover;
            height: 100vh; display: flex; justify-content: center; align-items: center;
        }
        .login-box {
            width: 100%; max-width: 400px; background: rgba(255, 255, 255, 0.95);
            padding: 45px; border-radius: 25px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }
        h2 { text-align: center; color: var(--primary-green); margin-bottom: 20px; font-size: 28px; }
        
        /* Message Box Styling */
        .alert {
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 13px;
            text-align: center;
            font-weight: 600;
        }
        .alert-error { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
        .alert-success { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }

        .input-box { margin-bottom: 20px; }
        .input-box input {
            width: 100%; padding: 15px; border-radius: 12px; border: 1px solid #eee;
            background: #f9f9f9; outline: none; transition: 0.3s;
        }
        .input-box input:focus { border-color: var(--primary-green); background: #fff; }
        button {
            width: 100%; padding: 15px; background: var(--primary-green); color: white;
            border: none; border-radius: 12px; cursor: pointer; font-size: 17px; font-weight: 600;
            transition: 0.3s;
        }
        button:hover { background: #1b5e20; box-shadow: 0 5px 15px rgba(46,125,50,0.3); }
        .options { display: flex; justify-content: space-between; margin-top: 20px; font-size: 13px; }
        .options a { color: var(--accent-blue); text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Welcome Back</h2>

        <%-- Pro-Tip Logic: Display messages based on URL parameters --%>
        <%
            String error = request.getParameter("error");
            String msg = request.getParameter("msg");
            
            if("invalid".equals(error)) {
        %>
            <div class="alert alert-error">Invalid email or password!</div>
        <%
            }
            if("success".equals(msg)) {
        %>
            <div class="alert alert-success">Registration successful! Please login.</div>
        <%
            }
            if("unauthorized".equals(error)) {
        %>
            <div class="alert alert-error">Please login to access the dashboard.</div>
        <%
            }
        %>

        <form action="LoginServlet" method="post">
            <div class="input-box">
                <input type="email" name="email" placeholder="Email Address" required>
            </div>
            <div class="input-box">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit">Login to Dashboard</button>
            <div class="options">
                <a href="forgot_password.jsp">Forgot Password?</a>
                <a href="register.jsp">New User? Register</a>
            </div>
        </form>
    </div>
</body>
</html>