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

@WebServlet("/AddReviewServlet") // This must match your form action exactly
public class AddReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) { response.sendRedirect("login.jsp"); return; }

        int medId = Integer.parseInt(request.getParameter("med_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO reviews (medicine_id, user_id, rating, comment) VALUES (?, ?, ?, ?)"
            );
            ps.setInt(1, medId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);

            ps.executeUpdate();
            con.close();
            response.sendRedirect("view_medicine.jsp?review=success");
            
        } catch (Exception e) { e.printStackTrace(); }
    }
}