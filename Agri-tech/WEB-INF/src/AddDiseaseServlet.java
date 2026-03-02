import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/AddDiseaseServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class AddDiseaseServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("disease_name");
        String crop = request.getParameter("target_crop");
        String symptoms = request.getParameter("symptoms");
        int medId = Integer.parseInt(request.getParameter("med_id"));

        // Handle Photo Upload
        Part part = request.getPart("disease_photo");
        String fileName = part.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "diseases";
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs(); // Creates the directory if missing
        
        part.write(uploadPath + File.separator + fileName);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
            
            String sql = "INSERT INTO diseases (disease_name, target_crop, symptoms, solution_med_id, disease_photo) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, crop);
            ps.setString(3, symptoms);
            ps.setInt(4, medId);
            ps.setString(5, fileName);
            
            ps.executeUpdate();
            con.close();
            response.sendRedirect("admin_dashboard.jsp?msg=disease_added");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}