import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest; // Needed for hashing
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");
        String newPass = request.getParameter("newPassword");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
            
            // 1. Verify identity using security question and answer
            String checkSql = "SELECT id FROM users WHERE (name=? OR email=?) AND security_question=? AND security_answer=?";
            PreparedStatement ps = con.prepareStatement(checkSql);
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, question);
            ps.setString(4, answer);
            
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                int userId = rs.getInt("id");
                
                // 2. Identity confirmed, update password with HASHING
                PreparedStatement psUpdate = con.prepareStatement("UPDATE users SET password=? WHERE id=?");
                
                // We MUST hash the new password so it matches the login check logic
                psUpdate.setString(1, hashPassword(newPass));
                psUpdate.setInt(2, userId);
                psUpdate.executeUpdate();
                
                response.sendRedirect("login.jsp?msg=reset_success");
            } else {
                // Wrong security details
                response.sendRedirect("forgot_password.jsp?error=invalid_details");
            }
            con.close();
        } catch(Exception e) { 
            e.printStackTrace();
            response.sendRedirect("forgot_password.jsp?error=server_error");
        }
    }

    // SHA-256 Hashing method - Must be identical to the one in RegisterServlet
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