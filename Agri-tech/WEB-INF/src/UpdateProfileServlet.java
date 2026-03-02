import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.security.MessageDigest;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class UpdateProfileServlet extends HttpServlet {
    
    // FOR DEPLOYMENT: Define a path on the server that won't be deleted
    // Example: "/var/www/uploads/" for Linux or "C:/agri_tracker_uploads/" for Windows
    private static final String UPLOAD_DIR = "agri_tracker_assets"; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        String phone = request.getParameter("phone");
        String bio = request.getParameter("bio");
        String newPass = request.getParameter("newPassword");

        // Handle File Upload securely
        Part filePart = request.getPart("profile_pic");
        String fileName = "";
        
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = filePart.getSubmittedFileName();
            // Secure filename: user_1_timestamp.jpg
            fileName = "user_" + userId + "_" + System.currentTimeMillis() + "_" + originalFileName;
            
            // Get the absolute path to the 'external' folder
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
            
            File fileSaveDir = new File(uploadFilePath);
            if (!fileSaveDir.exists()) {
                fileSaveDir.mkdirs(); // Create folder if it doesn't exist
            }
            filePart.write(uploadFilePath + File.separator + fileName);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // FOR DEPLOYMENT: Replace 'localhost' with your server IP if the DB is remote
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
            
            String sql = "UPDATE users SET phone=?, bio=?";
            if (!fileName.isEmpty()) sql += ", profile_pic=?";
            if (newPass != null && !newPass.trim().isEmpty()) sql += ", password=?";
            sql += " WHERE id=?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setString(2, bio);
            
            int index = 3;
            if (!fileName.isEmpty()) ps.setString(index++, fileName);
            if (newPass != null && !newPass.trim().isEmpty()) ps.setString(index++, hashPassword(newPass));
            ps.setInt(index, userId);
            
            ps.executeUpdate();
            con.close();
            response.sendRedirect("profile.jsp?msg=success");
        } catch(Exception e) {
            throw new ServletException(e);
        }
    }

    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) { sb.append(String.format("%02x", b)); }
        return sb.toString();
    }
}