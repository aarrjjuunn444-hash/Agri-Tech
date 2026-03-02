import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SearchSuggestionServlet")
public class SearchSuggestionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (query == null || query.trim().isEmpty()) return;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
            
            // This query joins medicines and diseases to give you full coverage
            String sql = "SELECT name FROM (SELECT name FROM medicines UNION SELECT disease_name AS name FROM diseases) AS combined WHERE name LIKE ? LIMIT 5";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, query + "%");
            
            ResultSet rs = ps.executeQuery();
            StringBuilder sb = new StringBuilder();
            while (rs.next()) {
                sb.append(rs.getString(1)).append(",");
            }
            
            // Remove trailing comma and send
            String result = sb.toString();
            out.print(result.endsWith(",") ? result.substring(0, result.length()-1) : result);
            out.flush();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}