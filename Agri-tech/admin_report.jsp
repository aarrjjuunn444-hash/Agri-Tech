<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Agri-Tech | Usage Reports</title>
    <style>
        :root { --admin-blue: #1565c0; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); padding: 40px; }
        .report-card { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: var(--admin-blue); color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        .count-badge { background: #e3f2fd; color: #0d47a1; padding: 5px 12px; border-radius: 20px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="report-card">
        <h2>Medicine Usage Statistics</h2>
        <p>Total applications recorded across all farms.</p>
        
        <table>
            <thead>
                <tr>
                    <th>Medicine Name</th>
                    <th>Category</th>
                    <th>Total Applications</th>
                    <th>Current Stock Remaining</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
                        
                        // Query to count how many times each medicine appears in usage_logs
                        String sql = "SELECT m.name, m.category, m.stock_level, COUNT(l.id) as total_usage " +
                                     "FROM medicines m " +
                                     "LEFT JOIN usage_logs l ON m.id = l.medicine_id " +
                                     "GROUP BY m.id, m.name, m.category, m.stock_level " +
                                     "ORDER BY total_usage DESC";
                        
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery(sql);
                        
                        while(rs.next()) {
                %>
                <tr>
                    <td><strong><%= rs.getString("name") %></strong></td>
                    <td><%= rs.getString("category") %></td>
                    <td><span class="count-badge"><%= rs.getInt("total_usage") %> Logs</span></td>
                    <td style="<%= (rs.getInt("stock_level") < 10) ? "color:red; font-weight:bold;" : "" %>">
                        <%= rs.getInt("stock_level") %> kg/L
                    </td>
                </tr>
                <%
                        }
                        con.close();
                    } catch(Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>
        <br>
        <a href="admin_dashboard.jsp" style="color: var(--admin-blue); text-decoration: none;">← Back to Inventory</a>
    </div>
</body>
</html>