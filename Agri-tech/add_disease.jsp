<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Prefill logic: if admin clicks 'Add Info' from a request
    String prefillTerm = request.getParameter("prefill");
    if(prefillTerm == null) prefillTerm = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Agri-Tech | Add Disease Guide</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --admin-blue: #1565c0; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); padding: 40px; }
        
        .container { max-width: 500px; margin: 0 auto; }
        .back-link { text-decoration: none; color: var(--admin-blue); font-weight: 600; margin-bottom: 20px; display: inline-block; transition: 0.3s; }
        .back-link:hover { color: #0d47a1; transform: translateX(-5px); }
        
        .form-card { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        h2 { color: var(--admin-blue); text-align: center; margin-top: 0; }
        
        .form-group { margin-bottom: 18px; }
        label { font-weight: 600; display: block; margin-bottom: 8px; color: #444; font-size: 14px; }
        input, select, textarea { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ddd; box-sizing: border-box; font-family: inherit; }
        textarea { height: 100px; resize: vertical; }
        
        button { width: 100%; padding: 14px; background: var(--admin-blue); color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; margin-top: 10px; font-size: 16px; transition: 0.3s; }
        button:hover { background: #0d47a1; box-shadow: 0 4px 12px rgba(21, 101, 192, 0.3); }
    </style>
</head>
<body>

    <div class="container">
        <a href="admin_dashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>

        <div class="form-card">
            <h2><i class="fas fa-microscope"></i> Add Disease Guide</h2>
            <p style="text-align: center; color: #666; font-size: 13px; margin-bottom: 25px;">Enter details to help farmers identify crop issues.</p>
            
            <form action="AddDiseaseServlet" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Disease Name</label>
                    <input type="text" name="disease_name" value="<%= prefillTerm %>" placeholder="e.g. Rice Blast" required>
                </div>

                <div class="form-group">
                    <label>Target Crop</label>
                    <input type="text" name="target_crop" placeholder="e.g. Rice, Tomato" required>
                </div>

                <div class="form-group">
                    <label>Symptoms</label>
                    <textarea name="symptoms" placeholder="Describe how the farmer can identify this..." required></textarea>
                </div>
                
                <div class="form-group">
                    <label>Recommended Medicine (Solution)</label>
                    <select name="med_id" required>
                        <option value="">-- Select Medicine from Inventory --</option>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery("SELECT id, name FROM medicines ORDER BY name ASC");
                                while(rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                        <%      }
                                con.close();
                            } catch(Exception e) { e.printStackTrace(); }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Identification Photo</label>
                    <input type="file" name="disease_photo" accept="image/*" required style="padding: 8px; background: #fafafa;">
                    <small style="color: #888;">Upload a clear image of the disease symptoms.</small>
                </div>

                <button type="submit">Publish to Farmer Guide</button>
            </form>
        </div>
    </div>

</body>
</html>