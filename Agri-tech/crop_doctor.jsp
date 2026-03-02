<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
    
    String query = request.getParameter("query");
    String contextPath = request.getContextPath();
    boolean isSearching = (query != null && !query.trim().isEmpty());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Crop Doctor | Results</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary: #2e7d32; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; padding: 20px; }
        .gallery { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 25px; }
        .card { background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .card img { width: 100%; height: 200px; object-fit: cover; }
        .card-body { padding: 20px; }
        .badge { background: #e8f5e9; color: var(--primary); padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700; margin-bottom: 10px; display: inline-block; }
        .sol-box { background: #f1f8e9; padding: 12px; border-radius: 8px; color: #1b5e20; border-left: 4px solid var(--primary); margin-top: 15px; }
    </style>
</head>
<body>

    <a href="farmer_dashboard.jsp" style="text-decoration:none; color:var(--primary); font-weight:600;"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    
    <h2><%= isSearching ? "Results for \"" + query + "\"" : "All Disease Guides" %></h2>

    <div class="gallery">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
                
                // JOIN query to get the medicine name from the medicines table
                String sql = "SELECT d.*, m.name AS med_name FROM diseases d " +
                             "LEFT JOIN medicines m ON d.solution_med_id = m.id";
                
                if(isSearching) {
                    sql += " WHERE d.disease_name LIKE ? OR d.target_crop LIKE ? OR m.name LIKE ?";
                }

                PreparedStatement ps = con.prepareStatement(sql);
                if(isSearching) {
                    String p = "%" + query + "%";
                    ps.setString(1, p); ps.setString(2, p); ps.setString(3, p);
                }

                ResultSet rs = ps.executeQuery();
                boolean found = false;

                while(rs.next()) {
                    found = true;
        %>
            <div class="card">
                <img src="<%= contextPath %>/agri_tracker_assets/<%= rs.getString("disease_photo") %>" 
                     onerror="this.src='https://via.placeholder.com/350x200?text=No+Image'">
                <div class="card-body">
                    <span class="badge"><%= rs.getString("target_crop").toUpperCase() %></span>
                    <h3 style="margin:0;"><%= rs.getString("disease_name") %></h3>
                    <p style="font-size:14px; color:#666;"><%= rs.getString("symptoms") %></p>
                    
                    <div class="sol-box">
                        <strong>Recommended Medicine:</strong><br>
                        <%= (rs.getString("med_name") != null) ? rs.getString("med_name") : "Consult Admin" %>
                    </div>
                    
                    <a href="farmer_dashboard.jsp" style="display:block; text-align:center; background:var(--primary); color:white; padding:10px; border-radius:8px; text-decoration:none; margin-top:15px; font-weight:600;">Log Usage</a>
                </div>
            </div>
        <%
                }
                if(!found) {
        %>
            <div style="grid-column: 1/-1; text-align:center; padding:80px; background:white; border-radius:20px;">
                <i class="fas fa-search" style="font-size:50px; color:#ccc;"></i>
                <h3>No information found for "<%= query %>"</h3>
                <p>Would you like to request our experts to add this data?</p>
                <form action="RequestInfoServlet" method="post">
                    <input type="hidden" name="term" value="<%= query %>">
                    <button type="submit" style="background:var(--primary); color:white; border:none; padding:12px 30px; border-radius:30px; cursor:pointer;">Request Info</button>
                </form>
            </div>
        <%
                }
                con.close();
            } catch(Exception e) { out.print("System Error: " + e.getMessage()); }
        %>
    </div>

</body>
</html>