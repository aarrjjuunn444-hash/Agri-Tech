<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Agri-Tech | Add Medicine</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --admin-green: #2e7d32; --admin-dark: #1b5e20; --bg: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); padding: 40px; }
        
        .container { max-width: 450px; margin: 0 auto; }
        .back-link { text-decoration: none; color: var(--admin-green); font-weight: 600; margin-bottom: 20px; display: inline-block; transition: 0.3s; }
        .back-link:hover { color: var(--admin-dark); transform: translateX(-5px); }
        
        .form-card { background: white; padding: 35px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        h2 { color: var(--admin-green); text-align: center; margin-top: 0; margin-bottom: 10px; }
        p.subtitle { text-align: center; color: #666; font-size: 13px; margin-bottom: 25px; }
        
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 14px; }
        input, select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; font-family: inherit; }
        
        button { width: 100%; padding: 14px; background: var(--admin-green); color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; margin-top: 10px; font-size: 16px; transition: 0.3s; }
        button:hover { background: var(--admin-dark); box-shadow: 0 4px 12px rgba(46, 125, 50, 0.3); }
    </style>
</head>
<body>

    <div class="container">
        <a href="admin_dashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>

        <div class="form-card">
            <h2><i class="fas fa-pills"></i> Add New Medicine</h2>
            <p class="subtitle">Register new products into the Agri-Tech inventory.</p>
            
            <form action="AddMedicineServlet" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Medicine Name</label>
                    <input type="text" name="name" placeholder="e.g. NPK Fertilizer" required>
                </div>
                
                <div class="form-group">
                    <label>Category</label>
                    <select name="category">
                        <option value="Fertilizer">Fertilizer</option>
                        <option value="Pesticide">Pesticide</option>
                        <option value="Fungicide">Fungicide</option>
                        <option value="Growth Booster">Growth Booster</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Initial Stock (kg/L)</label>
                    <input type="number" name="stock" placeholder="e.g. 100" min="1" required>
                </div>
                
                <div class="form-group">
                    <label>Product Photo</label>
                    <input type="file" name="photo" accept="image/*" required style="padding: 8px; background: #fafafa;">
                    <small style="color: #888;">Clear packaging photos are recommended.</small>
                </div>
                
                <button type="submit">Save to Inventory</button>
            </form>
        </div>
    </div>

</body>
</html>