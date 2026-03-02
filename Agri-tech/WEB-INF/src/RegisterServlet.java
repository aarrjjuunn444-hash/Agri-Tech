import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.security.MessageDigest;
import javax.servlet.annotation.WebServlet;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // 1. Existing Parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm"); 
        String role = request.getParameter("role"); 
        String phone = request.getParameter("phone");

        // 2. NEW Parameters for Forgot Password
        String securityQuestion = request.getParameter("security_question");
        String securityAnswer = request.getParameter("security_answer");

        // Server-side validation: match passwords
        if (password == null || !password.equals(confirm)) {
            out.println("<script>alert('Passwords do not match!'); window.location='register.jsp';</script>");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369"
            );

            // 3. Updated SQL query with security columns
            String sql = "INSERT INTO users(name, email, password, role, phone, security_question, security_answer) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashPassword(password)); // Keep your SHA-256 hashing
            ps.setString(4, role);
            ps.setString(5, phone);
            ps.setString(6, securityQuestion);
            ps.setString(7, securityAnswer);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                // SUCCESS: Redirect with success flag
                response.sendRedirect("login.jsp?msg=success");
            } else {
                out.println("<script>alert('Registration failed. Try again.'); window.location='register.jsp';</script>");
            }
            con.close();
        } catch (SQLIntegrityConstraintViolationException e) {
            out.println("<script>alert('Email already registered!'); window.location='register.jsp';</script>");
        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }

    // SHA-256 Hashing method (Keep this to ensure passwords remain secure)
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}