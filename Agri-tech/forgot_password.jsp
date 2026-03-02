<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password | Agri-Tech</title>
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .reset-box { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 400px; }
        .reset-box h2 { color: #2e7d32; margin-bottom: 20px; text-align: center; }
        input, select { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
        .btn-reset { width: 100%; background: #2e7d32; color: white; border: none; padding: 12px; border-radius: 8px; cursor: pointer; font-weight: 600; }
    </style>
</head>
<body>

<div class="reset-box">
    <h2>Account Recovery</h2>
    <form action="ResetPasswordServlet" method="post">
        <label>Username / Email</label>
        <input type="text" name="username" required placeholder="Enter your registered name">
        
        <label>Security Question</label>
        <select name="question">
            <option>What is your favorite crop?</option>
            <option>What was your first pet's name?</option>
            <option>In which city were you born?</option>
        </select>
        
        <label>Your Answer</label>
        <input type="text" name="answer" required placeholder="Answer is case-sensitive">
        
        <label>New Password</label>
        <input type="password" name="newPassword" required placeholder="Enter new password">
        
        <button type="submit" class="btn-reset">Reset Password</button>
    </form>
    <p style="text-align: center; font-size: 14px; margin-top: 15px;">
        <a href="login.jsp" style="color: #666; text-decoration: none;">Back to Login</a>
    </p>
</div>

</body>
</html>