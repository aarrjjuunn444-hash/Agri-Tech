<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
    String userName = (String) session.getAttribute("userName"), contextPath = request.getContextPath();
    Integer uId = (Integer) session.getAttribute("userId");
    String profilePic = "", lowStockList = "";
    boolean hasLowStock = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
        
        // Fetch Profile Pic
        PreparedStatement ps = con.prepareStatement("SELECT profile_pic FROM users WHERE id=?");
        ps.setInt(1, uId);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) profilePic = rs.getString("profile_pic");

        // Fetch Low Stock (Threshold: 5)
        ResultSet rsL = con.createStatement().executeQuery("SELECT name FROM medicines WHERE stock_level <= 5 AND stock_level > 0");
        while(rsL.next()) { hasLowStock = true; lowStockList += rsL.getString(1) + ", "; }
        con.close();
    } catch(Exception e) { e.printStackTrace(); }

    String headerImg = (profilePic != null && !profilePic.isEmpty()) ? contextPath + "/agri_tracker_assets/" + profilePic : "https://ui-avatars.com/api/?name=" + userName + "&background=2e7d32&color=fff";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Farmer Hub | Agri-Tech</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary: #2e7d32; --bg: #f4f7f6; --white: #ffffff; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; display: flex; }
        #welcomeAlert { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); background: var(--primary); color: white; padding: 12px 25px; border-radius: 50px; z-index: 2000; transition: 0.5s; }
        .sidebar { width: 260px; background: var(--white); height: 100vh; position: fixed; border-right: 1px solid #ddd; }
        .sidebar-header { padding: 25px; background: var(--primary); color: white; text-align: center; }
        .menu-item { padding: 15px 25px; display: flex; align-items: center; text-decoration: none; color: #333; font-weight: 500; transition: 0.3s; }
        .menu-item:hover, .menu-item.active { background: #e8f5e9; color: var(--primary); border-right: 4px solid var(--primary); }
        .main { margin-left: 260px; flex: 1; }
        .top-nav { background: var(--white); padding: 10px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #ddd; position: sticky; top: 0; z-index: 900; }
        .profile-img { width: 40px; height: 40px; border-radius: 50%; border: 2px solid var(--primary); object-fit: cover; }
        .content-body { padding: 30px; }
        .hero-search { background: var(--primary); padding: 40px; border-radius: 20px; color: white; text-align: center; margin-bottom: 30px; }
        .search-wrapper { background: white; display: flex; align-items: center; width: 70%; margin: 20px auto 0; border-radius: 40px; padding: 5px 10px; position: relative; }
        .search-bar { flex: 1; border: none; outline: none; padding: 12px 20px; font-size: 16px; border-radius: 40px; }
        #suggestionBox { position: absolute; top: 105%; left: 5%; width: 90%; background: white; border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.15); z-index: 100; display: none; color: #333; text-align: left; }
        .suggest-item { padding: 10px 20px; cursor: pointer; border-bottom: 1px solid #eee; }
        .suggest-item:hover { background: #f1f1f1; color: var(--primary); }
        .grid { display: grid; grid-template-columns: 2fr 1fr; gap: 30px; }
        .card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .log-form input, .log-form select { width: 100%; padding: 12px; margin: 8px 0 15px 0; border: 1px solid #ddd; border-radius: 8px; }
        .btn { background: var(--primary); color: white; border: none; padding: 12px; border-radius: 8px; cursor: pointer; width: 100%; font-weight: 600; }
    </style>
</head>
<body>
    <div id="welcomeAlert"><i class="fas fa-seedling"></i> Welcome back, <%= userName %>!</div>

    <div class="sidebar">
        <div class="sidebar-header"><h2>Agri-Tech</h2></div>
        <a href="#" class="menu-item active"><i class="fas fa-home"></i> Dashboard</a>
        <a href="crop_doctor.jsp" class="menu-item"><i class="fas fa-stethoscope"></i> Crop Doctor</a>
        <a href="view_medicine.jsp" class="menu-item"><i class="fas fa-pills"></i> Directory</a>
        <a href="view_history.jsp" class="menu-item"><i class="fas fa-history"></i> My Logs</a>
        <a href="profile.jsp" class="menu-item"><i class="fas fa-user-circle"></i> Profile</a>
        <a href="logout.jsp" class="menu-item" style="margin-top:50px; color:red;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main">
        <div class="top-nav">
            <span><i class="fas fa-leaf" style="color:var(--primary)"></i> Farmer Hub</span>
            <div style="display:flex; align-items:center; gap:12px; cursor:pointer;" onclick="location.href='profile.jsp'">
                <div style="text-align:right"><div style="font-weight:600; font-size:14px;"><%= userName %></div></div>
                <img src="<%= headerImg %>" class="profile-img">
            </div>
        </div>

        <div class="content-body">
            <% if(hasLowStock) { %>
                <div style="background:#fff3e0; border-left:5px solid #fb8c00; padding:15px; border-radius:10px; margin-bottom:20px; display:flex; align-items:center; gap:15px;">
                    <i class="fas fa-exclamation-triangle" style="color:#fb8c00"></i>
                    <span><strong>Low Stock Warning:</strong> <%= lowStockList.replaceAll(", $", "") %></span>
                </div>
            <% } %>

            <div class="hero-search">
                <h1>Find Solutions Instantly</h1>
                <form action="crop_doctor.jsp" method="get" class="search-wrapper">
                    <input type="text" id="sInput" name="query" class="search-bar" placeholder="Search..." required autocomplete="off" onkeyup="getSug(this.value)">
                    <button type="submit" style="background:var(--primary); color:white; border:none; padding:10px 20px; border-radius:30px; cursor:pointer;"><i class="fas fa-search"></i></button>
                    <div id="suggestionBox"></div>
                </form>
            </div>

            <div class="grid">
                <div class="card">
                    <h3>Log Treatment</h3>
                    <form action="LogUsageServlet" method="post" class="log-form">
                        <select name="med_id" required><option value="">-- Select Medicine --</option>
                        <% try { Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
                           ResultSet r = c.createStatement().executeQuery("SELECT id, name FROM medicines WHERE stock_level > 0");
                           while(r.next()) out.print("<option value='"+r.getInt(1)+"'>"+r.getString(2)+"</option>"); c.close(); } catch(Exception e){} %>
                        </select>
                        <input type="text" name="crop_name" placeholder="Crop Name" required>
                        <input type="text" name="dosage" placeholder="Dosage (ml/g)" required>
                        <input type="date" name="app_date" required>
                        <button type="submit" class="btn">Save Record</button>
                    </form>
                </div>
                <div class="card" style="background: #e8f5e9;">
                    <h4 style="color:var(--primary)"><i class="fas fa-lightbulb"></i> Pro Tip</h4>
                    <p style="font-size:14px; color:#444;">Accurate dosage logging helps the system predict your next required application date.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
      function getSug(s) {
    let b = document.getElementById("suggestionBox");
    if (!s || s.trim().length === 0) { 
        b.style.display = "none"; 
        return; 
    }

    // Direct call to ensure pathing is absolute
    var request = new XMLHttpRequest();
    request.open("GET", "<%=request.getContextPath()%>/SearchSuggestionServlet?q=" + encodeURIComponent(s), true);
    
    request.onreadystatechange = function() {
        if (request.readyState == 4 && request.status == 200) {
            var data = request.responseText;
            if (data && data.trim().length > 0) {
                var items = data.split(",");
                var html = "";
                for(var i=0; i<items.length; i++) {
                    html += "<div class='suggest-item' onclick='sel(\"" + items[i].replace(/'/g, "\\'") + "\")'>" + items[i] + "</div>";
                }
                b.innerHTML = html;
                b.style.display = "block";
            } else {
                // Helpful for debugging: shows if connection worked but DB was empty
                b.innerHTML = "<div class='suggest-item' style='color:#999'>No matches found</div>";
                b.style.display = "block";
            }
        }
    };
    request.send();
}
        
        function sel(v){ document.getElementById("sInput").value=v; document.getElementById("suggestionBox").style.display="none"; }
        window.onload = () => setTimeout(() => document.getElementById('welcomeAlert').style.display='none', 4000);
        document.addEventListener("click", e => { if(e.target.id!=="sInput") document.getElementById("suggestionBox").style.display="none"; });
    </script>
</body>
</html>