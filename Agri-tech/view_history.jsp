<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // SESSION GUARD
    if (session.getAttribute("userId") == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    String userName = (String) session.getAttribute("userName");
    Integer userId = (Integer) session.getAttribute("userId");
    String userRole = (String) session.getAttribute("userRole");
    
    // Dynamic Back Link logic
    String backLink = "admin".equalsIgnoreCase(userRole) ? "admin_dashboard.jsp" : "farmer_dashboard.jsp";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Treatment History | Agri-Tech</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>
    
    <style>
        :root { --primary: #2e7d32; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; padding: 0; }
        
        .top-nav { background: white; padding: 15px 60px; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 1000; }
        
        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }

        /* History Table UI */
        .table-card { background: white; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); overflow: hidden; }
        .history-table { width: 100%; border-collapse: collapse; }
        .history-table th { background: var(--primary); color: white; padding: 18px; text-align: left; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }
        .history-table td { padding: 18px; border-bottom: 1px solid #eee; color: #444; font-size: 15px; }
        .history-table tr:hover { background: #f9fdf9; }

        .badge { padding: 6px 14px; border-radius: 20px; font-size: 11px; font-weight: 700; background: #e3f2fd; color: #1565c0; }
        .success-msg { background: #e8f5e9; color: #2e7d32; padding: 15px 25px; border-radius: 10px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; border: 1px solid #c8e6c9; }
        
        .action-btn { background: white; border: 1px solid #ccc; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-family: inherit; font-weight: 600; transition: 0.3s; display: inline-flex; align-items: center; gap: 8px; }
        .action-btn:hover { background: #eee; border-color: #999; }
        .btn-pdf { background: #1565c0; color: white; border: none; }
        .btn-pdf:hover { background: #0d47a1; }

        @media print {
            .top-nav, .action-btn, .back-nav { display: none !important; }
            .container { margin: 0; width: 100%; max-width: 100%; }
        }
    </style>
</head>
<body>

    <div class="top-nav">
        <a href="farmer_dashboard.jsp" class="back-nav" style="text-decoration:none; color:var(--primary); font-weight:600;">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <span style="color: #666; font-size: 14px;">Logged in as: <strong><%= userName %></strong></span>
    </div>

    <div class="container">
        <% if("success".equals(request.getParameter("msg"))) { %>
            <div class="success-msg">
                <i class="fas fa-check-circle"></i> Treatment record saved to database!
            </div>
        <% } %>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
            <div>
                <h1 style="margin:0; font-size: 32px; color: #333;">Usage History</h1>
                <p style="color:#888; margin: 5px 0 0 0;">View and manage your agricultural application logs.</p>
            </div>
            <div style="display: flex; gap: 10px;">
                <button onclick="downloadPDF()" class="action-btn btn-pdf">
                    <i class="fas fa-file-pdf"></i> Download PDF
                </button>
                <button onclick="window.print()" class="action-btn">
                    <i class="fas fa-print"></i> Print
                </button>
            </div>
        </div>

        <div class="table-card">
            <table class="history-table" id="usageTable">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Crop Treated</th>
                        <th>Medicine</th>
                        <th>Dosage</th>
                        <th>Category</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
                            
                            String sql = "SELECT l.application_date, l.crop_name, l.dosage, m.name, m.category " +
                                         "FROM usage_logs l " +
                                         "JOIN medicines m ON l.medicine_id = m.id " +
                                         "WHERE l.user_id = ? " +
                                         "ORDER BY l.application_date DESC";
                            
                            PreparedStatement ps = con.prepareStatement(sql);
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            
                            boolean hasRecords = false;
                            while(rs.next()) {
                                hasRecords = true;
                    %>
                    <tr>
                        <td><strong><%= rs.getDate("application_date") %></strong></td>
                        <td><%= rs.getString("crop_name") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("dosage") %></td>
                        <td><span class="badge"><%= rs.getString("category") %></span></td>
                    </tr>
                    <%
                            }
                            if(!hasRecords) {
                    %>
                    <tr>
                        <td colspan="5" style="text-align:center; padding:100px; color:#999;">
                            <i class="fas fa-clipboard-list" style="font-size:50px; display:block; margin-bottom:15px; opacity: 0.3;"></i>
                            No application history found for this account.
                        </td>
                    </tr>
                    <%
                            }
                            con.close();
                        } catch(Exception e) {
                            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Suggestion: Generate PDF locally using jsPDF
        function downloadPDF() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            doc.text("Agri-Tech Treatment History Report", 14, 15);
            doc.setFontSize(10);
            doc.text("User: <%= userName %>", 14, 22);
            doc.text("Generated on: " + new Date().toLocaleString(), 14, 27);

            doc.autoTable({
                html: '#usageTable',
                startY: 35,
                theme: 'grid',
                headStyles: { fillStyle: [46, 125, 50] }
            });

            doc.save("AgriTech_Usage_Logs.pdf");
        }
    </script>
</body>
</html>