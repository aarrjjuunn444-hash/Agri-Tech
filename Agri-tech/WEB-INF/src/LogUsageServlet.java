import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/LogUsageServlet")
public class LogUsageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // Must be set in LoginServlet

        // Safety check for session
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Catching parameters from the form
        String medIdStr = request.getParameter("med_id");
        String crop = request.getParameter("crop_name");
        String dosage = request.getParameter("dosage");
        String appDate = request.getParameter("app_date");

        // FIX: Prevent NumberFormatException if medIdStr is null or empty
        int medId = 0;
        try {
            if (medIdStr != null && !medIdStr.isEmpty()) {
                medId = Integer.parseInt(medIdStr);
            } else {
                response.sendRedirect("farmer_dashboard.jsp?msg=missing_id");
                return;
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");

            // 1. Insert into Logs (Matching schema: user_id, medicine_id, crop_name, dosage, application_date)
            PreparedStatement psLog = con.prepareStatement("INSERT INTO usage_logs(user_id, medicine_id, crop_name, dosage, application_date) VALUES(?,?,?,?,?)");
            psLog.setInt(1, userId);
            psLog.setInt(2, medId);
            psLog.setString(3, crop);
            psLog.setString(4, dosage);
            psLog.setString(5, appDate);
            psLog.executeUpdate();

            // 2. Reduce Stock in Inventory
            PreparedStatement psStock = con.prepareStatement("UPDATE medicines SET stock_level = stock_level - 1 WHERE id = ?");
            psStock.setInt(1, medId);
            psStock.executeUpdate();

            con.close();
            response.sendRedirect("view_history.jsp?msg=success");
        } catch (Exception e) { 
            e.printStackTrace(); 
            response.sendRedirect("farmer_dashboard.jsp?msg=error");
        }
    }
}