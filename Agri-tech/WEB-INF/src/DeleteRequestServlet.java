import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteRequestServlet")
public class DeleteRequestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
            
            PreparedStatement ps = con.prepareStatement("DELETE FROM information_requests WHERE id = ?");
            ps.setString(1, id);
            ps.executeUpdate();
            
            con.close();
            response.sendRedirect("view_requests.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}