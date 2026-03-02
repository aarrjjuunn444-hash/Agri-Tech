<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equalsIgnoreCase((String)session.getAttribute("userRole"))) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    String userName = (String) session.getAttribute("userName");
    Integer uId = (Integer) session.getAttribute("userId");
    String contextPath = request.getContextPath();

    // Variable for dynamic stats
    int medCount = 0;
    int pendingReq = 0;
    String profilePic = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
        
        // 1. Get Medicine Count
        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) FROM medicines");
        if(rs1.next()) medCount = rs1.getInt(1);

        // 2. Get Pending Requests Count
        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery("SELECT COUNT(*) FROM information_requests");
        if(rs2.next()) pendingReq = rs2.getInt(1);

        // 3. Get Admin Profile Data
        PreparedStatement ps = con.prepareStatement("SELECT profile_pic FROM users WHERE id=?");
        ps.setInt(1, uId);
        ResultSet rs3 = ps.executeQuery();
        if(rs3.next()) profilePic = rs3.getString("profile_pic");

        con.close();
    } catch(Exception e) { e.printStackTrace(); }

    String headerImg = (profilePic != null && !profilePic.isEmpty()) ? 
                      contextPath + "/agri_tracker_assets/" + profilePic : 
                      "https://ui-avatars.com/api/?name=Admin&background=1565c0&color=fff";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Hub | Agri-Tech</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --admin-blue: #1565c0; --bg: #f4f7f6; --white: #ffffff; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; display: flex; }
        
        
        .sidebar { width: 260px; background: var(--white); height: 100vh; position: fixed; border-right: 1px solid #ddd; z-index: 1000; }
        .sidebar-header { padding: 25px; background: var(--admin-blue); color: white; text-align: center; }
        .menu-item { padding: 15px 25px; display: flex; align-items: center; text-decoration: none; color: #333; transition: 0.3s; font-weight: 500; }
        .menu-item:hover, .menu-item.active { background: #e3f2fd; color: var(--admin-blue); border-right: 4px solid var(--admin-blue); }
        .menu-item i { margin-right: 15px; width: 20px; }

        
        .main { margin-left: 260px; flex: 1; }
        .top-nav { background: white; padding: 10px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #ddd; position: sticky; top: 0; z-index: 900; }
        
        .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 5px 15px; border-radius: 30px; transition: 0.2s; }
        .user-profile:hover { background: #f0f0f0; }
        .profile-img { width: 40px; height: 40px; border-radius: 50%; border: 2px solid var(--admin-blue); object-fit: cover; }

        .content-body { padding: 30px; }
        
        
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); text-align: center; border-bottom: 4px solid var(--admin-blue); }
        .mgmt-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px; margin-bottom: 30px; }
        .mgmt-card { background: white; padding: 30px; border-radius: 15px; text-align: center; text-decoration: none; color: #333; box-shadow: 0 4px 10px rgba(0,0,0,0.05); transition: 0.3s; }
        .mgmt-card:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,0,0,0.1); border: 1px solid var(--admin-blue); }
        .mgmt-card i { font-size: 40px; color: var(--admin-blue); margin-bottom: 15px; }
        .mgmt-card h3 { margin: 10px 0; }
        .mgmt-card p { color: #888; font-size: 14px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><h2>Agri-Admin</h2></div>
        <a href="admin_dashboard.jsp" class="menu-item active"><i class="fas fa-chart-line"></i> Dashboard Hub</a>
        <a href="profile.jsp" class="menu-item"><i class="fas fa-user-shield"></i> Admin Profile</a>
        <a href="logout.jsp" class="menu-item" style="margin-top:50px; color:red;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main">
        <div class="top-nav">
            <span style="color: #888;">Admin Control / <b>Home Dashboard</b></span>
            <div class="user-profile" onclick="location.href='profile.jsp'">
                <div style="text-align: right;">
                    <div style="font-weight: 600; font-size: 14px; color: #333;"><%= userName %></div>
                    <div style="font-size: 11px; color: #888;">System Administrator</div>
                </div>
                <img src="<%= headerImg %>" class="profile-img">
            </div>
        </div>

        <div class="content-body">
            <h1>Platform Overview</h1>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <h3 style="font-size: 28px; margin: 0;"><%= medCount %></h3>
                    <p style="color: #666; margin: 5px 0;">Active Medicines</p>
                </div>
                <div class="stat-card" style="border-color: #fbc02d;">
                    <h3 style="font-size: 28px; margin: 0;"><%= pendingReq %></h3>
                    <p style="color: #666; margin: 5px 0;">Pending Requests</p>
                </div>
                <div class="stat-card" style="border-color: #43a047;">
                    <h3 style="font-size: 28px; margin: 0;">Online</h3>
                    <p style="color: #666; margin: 5px 0;">Database Status</p>
                </div>
            </div>

            <h2 style="margin-top: 40px;">Management Actions</h2>
            <div class="mgmt-grid">
                <a href="add_medicine.jsp" class="mgmt-card">
                    <i class="fas fa-pills"></i>
                    <h3>Add New Medicine</h3>
                    <p>Expand the inventory with new agricultural products.</p>
                </a>
                <a href="add_disease.jsp" class="mgmt-card">
                    <i class="fas fa-microscope"></i>
                    <h3>Add Disease Guide</h3>
                    <p>Update the identification guide for farmers.</p>
                </a>
                <a href="view_requests.jsp" class="mgmt-card">
                    <i class="fas fa-comments"></i>
                    <h3>Farmer Support</h3>
                    <p>Address specific information requests from the community.</p>
                </a>
                <a href="admin_report.jsp" class="mgmt-card">
                    <i class="fas fa-chart-pie"></i>
                    <h3>System Analytics</h3>
                    <p>View global usage reports and medicine statistics.</p>
                </a>
            </div>
        </div>
    </div>

</body>
</html>