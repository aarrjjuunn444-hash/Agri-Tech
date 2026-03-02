import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/AddMedicineServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AddMedicineServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String stock = request.getParameter("stock");
        
        // Handle File Upload
        Part part = request.getPart("photo");
        String fileName = part.getSubmittedFileName();
        
        // Path where images will be saved
        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();
        
        part.write(uploadPath + File.separator + fileName);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
            
            String query = "INSERT INTO medicines (name, category, stock_level, photo) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, stock);
            ps.setString(4, fileName);
            
            int result = ps.executeUpdate();
            if(result > 0) {
                response.sendRedirect("admin_dashboard.jsp?msg=success");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}