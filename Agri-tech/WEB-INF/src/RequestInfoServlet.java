import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RequestInfoServlet")
public class RequestInfoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String term = request.getParameter("term");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        // Basic check to ensure user is logged in
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
            
            String sql = "INSERT INTO information_requests (user_id, requested_term) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, term);
            
            ps.executeUpdate();
            con.close();
            
            // Redirect back to dashboard with a success flag
            response.sendRedirect("farmer_dashboard.jsp?request=sent");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("farmer_dashboard.jsp?request=failed");
        }
    }
}