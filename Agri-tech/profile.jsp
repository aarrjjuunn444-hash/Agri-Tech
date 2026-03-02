<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // SESSION GUARD: Protects the page from unauthorized access
    if (session.getAttribute("userId") == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    Integer uId = (Integer) session.getAttribute("userId");
    String userRole = (String) session.getAttribute("userRole"); // Fetch role from session
    String contextPath = request.getContextPath();
    
    // Determine the correct dashboard link based on the user's role
    String dashboardLink = "farmer_dashboard.jsp"; // Default
    if (userRole != null && userRole.equalsIgnoreCase("admin")) {
        dashboardLink = "admin_dashboard.jsp";
    }
    
    String name="", email="", phone="", bio="", role="", profilePic="";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
        PreparedStatement ps = con.prepareStatement("SELECT name, email, phone, bio, role, profile_pic FROM users WHERE id=?");
        ps.setInt(1, uId);
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()){
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            bio = rs.getString("bio") != null ? rs.getString("bio") : "";
            role = rs.getString("role");
            profilePic = rs.getString("profile_pic");
        }
        con.close();
    } catch(Exception e) { 
        e.printStackTrace(); 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | Agri-Tracker</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary: #2e7d32; --primary-dark: #1b5e20; --admin-blue: #1565c0; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; padding: 20px; }
        
        /* Change theme color if Admin */
        <% if (userRole != null && userRole.equalsIgnoreCase("admin")) { %>
            :root { --primary: #1565c0; --primary-dark: #0d47a1; }
        <% } %>

        .profile-container { max-width: 700px; margin: 40px auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .header-bg { height: 140px; background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%); }
        
        .profile-header-wrapper { padding: 0 40px; margin-top: -60px; display: flex; align-items: flex-end; gap: 20px; }
        
        .avatar-container { flex-shrink: 0; }
        .avatar { width: 120px; height: 120px; border-radius: 50%; border: 5px solid white; background: white; object-fit: cover; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        
        .letter-avatar { width: 120px; height: 120px; border-radius: 50%; border: 5px solid white; background: var(--primary-dark); color: white; display: flex; align-items: center; justify-content: center; font-size: 50px; font-weight: bold; text-transform: uppercase; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }

        .user-title-meta { padding-bottom: 10px; }
        .user-title-meta h2 { margin: 0; color: #333; font-size: 28px; }
        .user-title-meta p { margin: 5px 0 0 0; color: #666; font-weight: 500; font-size: 15px; }

        .profile-body-content { padding: 30px 40px 40px; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-top: 10px; }
        .info-item label { display: block; font-size: 11px; font-weight: 700; color: var(--primary); text-transform: uppercase; margin-bottom: 5px; }
        .info-item p { margin: 0; font-size: 16px; color: #444; }

        .btn-group { margin-top: 35px; display: flex; gap: 15px; }
        .btn { padding: 12px 28px; border-radius: 10px; cursor: pointer; border: none; font-weight: 600; font-family: inherit; transition: 0.3s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; font-size: 15px; }
        
        .btn-edit { background: var(--primary); color: white; }
        .btn-edit:hover { background: var(--primary-dark); transform: translateY(-2px); }
        
        .btn-back { background: #f0f0f0; color: #444; border: 1px solid #ddd; }
        .btn-back:hover { background: var(--primary); color: white; border-color: var(--primary); transform: translateY(-2px); }

        #editForm { display: none; margin-top: 30px; border-top: 1px solid #eee; padding-top: 30px; }
        input, textarea, select { width: 100%; padding: 12px; margin-bottom: 18px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; font-family: inherit; font-size: 14px; }
        label.form-label { display: block; font-size: 13px; font-weight: 600; color: #555; margin-bottom: 8px; }
    </style>
</head>
<body>

    <div class="profile-container">
        <div class="header-bg"></div>
        
        <div class="profile-header-wrapper">
            <div class="avatar-container">
                <% if (profilePic != null && !profilePic.isEmpty() && !profilePic.equals("default_user.png")) { %>
                    <img src="<%= contextPath %>/agri_tracker_assets/<%= profilePic %>" class="avatar" alt="Profile Picture">
                <% } else { %>
                    <div class="letter-avatar"><%= name.substring(0, 1) %></div>
                <% } %>
            </div>

            <div class="user-title-meta">
                <h2><%= name %></h2>
                <p><i class="fas fa-shield-alt" style="color: var(--primary);"></i> Verified <%= role %></p>
            </div>
        </div>

        <div class="profile-body-content">
            <div id="viewMode">
                <div class="info-grid">
                    <div class="info-item"><label>Email Address</label><p><%= email %></p></div>
                    <div class="info-item"><label>Phone Number</label><p><%= (phone != null && !phone.isEmpty()) ? phone : "Not Provided" %></p></div>
                    <div class="info-item" style="grid-column: span 2;">
                        <label>Account Bio</label>
                        <p style="line-height: 1.6;"><%= (bio != null && !bio.isEmpty()) ? bio : "Update your bio to introduce yourself." %></p>
                    </div>
                </div>
                
                <div class="btn-group">
                    <button class="btn btn-edit" onclick="showEdit()"><i class="fas fa-user-edit"></i> Edit Profile</button>
                    <a href="<%= dashboardLink %>" class="btn btn-back"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
                </div>
            </div>

            <div id="editForm">
                <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data">
                    <label class="form-label">Update Profile Picture</label>
                    <input type="file" name="profile_pic" accept="image/*" style="padding: 8px; background: #fafafa;">

                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phone" value="<%= (phone != null) ? phone : "" %>" placeholder="e.g. +91 9876543210">

                    <label class="form-label">Bio / Description</label>
                    <textarea name="bio" rows="4" placeholder="Tell us about yourself..."><%= bio %></textarea>

                    <label class="form-label">New Password (Optional)</label>
                    <input type="password" name="newPassword" placeholder="Leave blank to keep your current password">

                    <div class="btn-group">
                        <button type="submit" class="btn btn-edit">Save Changes</button>
                        <button type="button" class="btn btn-back" onclick="hideEdit()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function showEdit() {
            document.getElementById('viewMode').style.display = 'none';
            document.getElementById('editForm').style.display = 'block';
        }
        function hideEdit() {
            document.getElementById('viewMode').style.display = 'block';
            document.getElementById('editForm').style.display = 'none';
        }
    </script>
</body>
</html>