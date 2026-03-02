<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Agri-Tech | Agriculture Info Portal</title>

<style>
body{
    margin:0;
    font-family: Arial, sans-serif;
}

.navbar{
    width:100%;
    position:fixed;
    top:0;
    right:0;
    padding:15px 25px;
    display:flex;
    justify-content:flex-end;
    z-index:10;
}

.navbar a{
    text-decoration:none;
    padding:10px 18px;
    margin-left:10px;
    background:#2e7d32;
    color:white;
    border-radius:5px;
    font-weight:bold;
}

.navbar a:hover{
    background:#1b5e20;
}

.hero{
    height:50vh;
    background-image:url("images/farm.jpg");
    background-size:cover;
    display:flex;
    align-items:center;
    justify-content:center;
    text-align:center;
    color:white;

}

.hero h1{
    font-size:48px;
    margin-bottom:10px;
}

.hero p{
    font-size:20px;
}

.about{
    display:flex;
    justify-content:center;
    margin-top:-60px;
}

.about-box{
    background:#c8e6c9;
    width:70%;
    padding:25px;
    border-radius:10px;
    text-align:center;
    box-shadow:0 4px 10px rgba(0,0,0,0.2);
}

footer{
    text-align:center;
    padding:15px;
    background:#d4ffd4;
    margin-top:30px;
}
</style>
</head>

<body>


<div class="navbar">
    <a href="register.jsp">Register</a>
    <a href="login.jsp">Login</a>
</div>

<div class="hero">
    <div>
        <h1>Welcome to Agri-Tech</h1>
        <p>Smart Agriculture Information Platform</p>
    </div>
</div>


<div class="about">
    <div class="about-box">
        <h2>About Agri-Tech</h2>
        <p>
        Agri-Tech is a web-based application designed to support agricultural activities
        using modern information technology. It helps manage medicines, inventory,
        usage logs, and reports in a digital manner.
        <br><br>
        The system ensures secure access through authentication and promotes smart
        farming practices by reducing manual paperwork and improving efficiency.
        </p>
    </div>
</div>

<footer>
    <p> © 2025 Agri Project | Developed by Arjun T.G, Sravan K. Sasi & Ajay Krishna </p>
</footer>

</body>
</html>