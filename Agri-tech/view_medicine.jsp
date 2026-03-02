<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Medicine Directory | Agri-Tracker</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary: #2e7d32; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; padding: 20px; }
        
        /* Grid Layout */
        .gallery { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 20px; transition: filter 0.3s ease; }
        .card { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); cursor: pointer; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .card img { width: 100%; height: 180px; object-fit: cover; }
        .card-body { padding: 15px; text-align: center; }

        /* Blur/Focus Effect */
        .blurred { filter: blur(10px); pointer-events: none; }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); z-index: 1500; }
        .medicine-modal {
            display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
            width: 90%; max-width: 700px; background: white; border-radius: 20px; box-shadow: 0 20px 50px rgba(0,0,0,0.2); z-index: 2000; overflow: hidden;
        }

        .modal-flex { display: flex; flex-wrap: wrap; }
        .modal-left { flex: 1; padding: 30px; border-right: 1px solid #eee; min-width: 280px; }
        .modal-right { flex: 1; padding: 30px; background: #fafafa; min-width: 280px; max-height: 450px; overflow-y: auto; }
        
        .close-btn { float: right; cursor: pointer; font-size: 24px; color: #aaa; }
        .btn-log { display: block; text-align: center; background: var(--primary); color: white; padding: 12px; border-radius: 8px; text-decoration: none; font-weight: 600; margin-top: 15px; }
    </style>
</head>
<body>

    <a href="farmer_dashboard.jsp" style="text-decoration:none; color:var(--primary); font-weight:600;"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    <h2 style="margin: 20px 0;">Medicine Inventory</h2>

    <div class="gallery" id="mainGallery">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/agri_tech", "root", "arjun369");
                
                // LEFT JOIN ensures medicine shows even if reviews table is empty
                String sql = "SELECT m.*, ROUND(AVG(r.rating), 1) as avg_rating FROM medicines m " +
                             "LEFT JOIN reviews r ON m.id = r.medicine_id " +
                             "GROUP BY m.id ORDER BY m.name ASC";
                
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(sql);

                while(rs.next()) {
                    double avgRating = rs.getDouble("avg_rating");
        %>
            <div class="card" onclick="openModal('<%= rs.getString("name") %>', '<%= rs.getString("category") %>', '<%= rs.getInt("stock_level") %>', '<%= contextPath %>/agri_tracker_assets/<%= rs.getString("photo") %>', '<%= rs.getInt("id") %>', <%= avgRating %>)">
                <img src="<%= contextPath %>/agri_tracker_assets/<%= rs.getString("photo") %>" onerror="this.src='https://via.placeholder.com/300x180?text=Medicine'">
                <div class="card-body">
                    <span style="font-size: 10px; font-weight: 700; color: var(--primary); text-transform: uppercase;"><%= rs.getString("category") %></span>
                    <h3 style="margin: 5px 0;"><%= rs.getString("name") %></h3>
                    <div style="color: #ffb300; font-size: 13px;">
                        <%= (avgRating > 0) ? "⭐ " + avgRating : "<span style='color:#ccc'>No ratings yet</span>" %>
                    </div>
                </div>
            </div>
        <%
                }
                con.close();
            } catch(Exception e) { out.print("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); }
        %>
    </div>
    <form action="AddReviewServlet" method="post">
    </form>
    <div class="modal-overlay" id="overlay" onclick="closeModal()"></div>
    <div class="medicine-modal" id="medicineModal">
        <div class="modal-flex">
            <div class="modal-left">
                <span class="close-btn" onclick="closeModal()">&times;</span>
                <img id="modalImg" src="" style="width:100%; height:200px; object-fit:contain; margin-bottom:15px;">
                <div id="starContainer" style="font-size: 20px; margin-bottom: 5px;"></div>
                <h2 id="modalName" style="color: var(--primary); margin: 0;"></h2>
                <p id="modalCategory" style="color: #888; font-weight: 600; margin: 5px 0;"></p>
                <p id="modalStock" style="font-size: 14px; color: #444;"></p>
                <a href="farmer_dashboard.jsp" class="btn-log">Log Usage of This</a>
            </div>

            <div class="modal-right">
                <h4 style="margin-top: 0;"><i class="fas fa-star" style="color:#ffb300"></i> Rate this Product</h4>
                <form action="AddReviewServlet" method="post">
                    <input type="hidden" name="med_id" id="modalMedId">
                    <select name="rating" required style="width:100%; padding:8px; margin-bottom:10px;">
                        <option value="5">⭐⭐⭐⭐⭐ (Excellent)</option>
                        <option value="4">⭐⭐⭐⭐ (Good)</option>
                        <option value="3">⭐⭐⭐ (Average)</option>
                        <option value="2">⭐⭐ (Poor)</option>
                        <option value="1">⭐ (Very Bad)</option>
                    </select>
                    <textarea name="comment" placeholder="Your experience..." required style="width:100%; height:80px; padding:10px; border-radius:8px; border:1px solid #ddd; box-sizing: border-box;"></textarea>
                    <button type="submit" class="btn-log" style="width:100%; border:none; cursor:pointer;">Submit Review</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function openModal(name, category, stock, img, id, rating) {
            document.getElementById('modalName').innerText = name;
            document.getElementById('modalCategory').innerText = category;
            document.getElementById('modalStock').innerText = "Stock available: " + stock + " kg/L";
            document.getElementById('modalImg').src = img;
            document.getElementById('modalMedId').value = id;

            let stars = "";
            if (rating > 0) {
                for (let i = 1; i <= 5; i++) {
                    stars += (i <= Math.round(rating)) ? "<i class='fas fa-star' style='color:#ffb300'></i>" : "<i class='far fa-star' style='color:#ccc'></i>";
                }
            } else {
                stars = "<i class='far fa-star' style='color:#ccc'></i>".repeat(5);
            }
            document.getElementById('starContainer').innerHTML = stars;

            document.getElementById('medicineModal').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
            document.getElementById('mainGallery').classList.add('blurred');
        }

        function closeModal() {
            document.getElementById('medicineModal').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
            document.getElementById('mainGallery').classList.remove('blurred');
        }
    </script>
</body>
</html>