<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
   // Replace your current parsing line with this:
String medIdStr = request.getParameter("med_id");
int medId = 0;
if (medIdStr != null && !medIdStr.isEmpty()) {
    medId = Integer.parseInt(medIdStr);
} else {
    // If ID is missing, don't crash; just go back
    response.sendRedirect("farmer_dashboard.jsp?error=missing_id");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Agri-Tech | Log Treatment</title>
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f4f7f6; display: flex; justify-content: center; padding: 50px; }
        .form-card { background: white; padding: 30px; border-radius: 15px; width: 400px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        input { width: 100%; padding: 10px; margin: 10px 0; border-radius: 5px; border: 1px solid #ddd; }
        .btn { width: 100%; background: #2e7d32; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>Record Treatment</h2>
        <form action="LogUsageServlet" method="post">
            <input type="hidden" name="med_id" value="<%= medId %>">
            <label>Selected Medicine:</label>
            <input type="text" value="<%= medName %>" readonly style="background: #eee;">

            <label>Your Specific Crop Variety:</label>
            <input type="text" name="crop_name" placeholder="e.g. Basmati Rice" required>

            <label>Dosage (e.g. 200ml per acre):</label>
            <input type="text" name="dosage" required>

            <label>Application Date:</label>
            <input type="date" name="app_date" required>

            <button type="submit" class="btn">Save Record</button>
        </form>
    </div>
</body>
</html>