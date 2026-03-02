import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.security.MessageDigest;
import javax.servlet.annotation.WebServlet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String hashedPassword = hashPassword(password);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369"
            );

            // 1. UPDATED QUERY: We MUST select 'id' to make the dashboard session guard work
            PreparedStatement ps = con.prepareStatement(
                "SELECT id, name, role FROM users WHERE email=? AND password=?"
            );
            ps.setString(1, email);
            ps.setString(2, hashedPassword);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                
                // 2. SET THE CRITICAL ID ATTRIBUTE
                session.setAttribute("userId", rs.getInt("id")); 
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userRole", rs.getString("role"));

                String userRole = rs.getString("role");

                // 3. REDIRECT with return statements (Best practice for deployment)
                if ("admin".equalsIgnoreCase(userRole)) {
                    response.sendRedirect("admin_dashboard.jsp");
                    return; 
                } else {
                    response.sendRedirect("farmer_dashboard.jsp");
                    return;
                }
            } else {
                response.sendRedirect("login.jsp?error=invalid");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server_error");
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }
}