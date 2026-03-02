<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin | Farmer Requests</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --admin-blue: #1565c0; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; padding: 20px; }
        .container { max-width: 1000px; margin: 40px auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        h2 { color: var(--admin-blue); border-bottom: 2px solid var(--admin-blue); padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: var(--admin-blue); color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #ddd; }
        .btn-add { color: #2e7d32; text-decoration: none; font-weight: bold; }
        .btn-delete { color: #d32f2f; text-decoration: none; font-weight: bold; margin-left: 15px; }
        .no-req { text-align: center; padding: 40px; color: #888; }
    </style>
</head>
<body>

    <div class="container">
        <h2><i class="fas fa-envelope-open-text"></i> Pending Farmer Requests</h2>
        <p>The following terms were searched by farmers but were not found in the database.</p>

        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Requested Term</th>
                    <th>Farmer Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
                        
                        // Join with users table to see who made the request
                        String sql = "SELECT r.id, r.requested_term, r.request_date, u.name FROM information_requests r " +
                                     "JOIN users u ON r.user_id = u.id ORDER BY r.request_date DESC";
                        
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery(sql);
                        
                        boolean hasData = false;
                        while(rs.next()) {
                            hasData = true;
                %>
                <tr>
                    <td><%= rs.getTimestamp("request_date") %></td>
                    <td><strong><%= rs.getString("requested_term") %></strong></td>
                    <td><%= rs.getString("name") %></td>
                    <td>
                        <a href="add_disease.jsp?prefill=<%= rs.getString("requested_term") %>" class="btn-add">
                            <i class="fas fa-plus"></i> Add Info
                        </a>
                        <a href="DeleteRequestServlet?id=<%= rs.getInt("id") %>" class="btn-delete" onclick="return confirm('Mark as completed and delete?')">
                            <i class="fas fa-check"></i> Clear
                        </a>
                    </td>
                </tr>
                <%
                        }
                        if(!hasData) {
                %>
                <tr>
                    <td colspan="4" class="no-req">No pending requests from farmers.</td>
                </tr>
                <%
                        }
                        con.close();
                    } catch(Exception e) { out.print(e.getMessage()); }
                %>
            </tbody>
        </table>
        <br>
        <a href="admin_dashboard.jsp" style="color: var(--admin-blue); text-decoration: none;">← Back to Inventory</a>
        </a>
    </div>

</body>
</html>