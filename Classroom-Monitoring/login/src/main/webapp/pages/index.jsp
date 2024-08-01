<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Monitoring System</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-image: url('img/galgotia_college.jpg');
            /* Adjust background properties as needed */
            background-size: cover; /* Cover the entire background */
            background-position: center; /* Center the background image */
            /* Additional background properties */
        
    }
   
    nav {
        background-color:#9d0000/*#4da1ff*/;
        backdrop-filter: blur(40px);
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    nav ul {
        list-style-type: none;
        margin-left:600px ;
        padding: 0;
        display: flex;
        justify-content: center; /* Center list items horizontally */
    }
    
    nav li {
        
        margin-right: 40px;
    }
    
    nav li:last-child {
        margin-right: 400px;
    }
    
    nav a {
        text-decoration: none;
        color:white;
        font-size: 24px;
        text-shadow: #333;
    }

    .content {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 90vh;
    }
    

    
    
    .content h1 {
        font-size: 55px;
        color:#ffbb4d;
        text-shadow: 2px 2px 0 #800000, 4px 4px 0 #400000; 
    }

    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 10vh;
    }
    
    .enlarge-btn {
        padding: 10px 20px;
        font-size: 16px;
        background-color: #4da1ff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: transform 0.3s; 
        text-decoration: none;
    }
    
    .enlarge-btn:hover {
        transform: scale(1.1); /* Enlarge the button on hover */
    }
    nav img{
        border-radius: 25%;
        height: 100px;
        margin-right: -200px;
    }
    footer {
        background-color: #9d0000/*#4da1ff;*/; /* Same background color as nav */
        padding: 20px;
        text-align: center;
        font-size: 24px;
        color:white; /* Adjust text color */
    }
</style>
</head>
<body>
   
    <nav>
        <img src="img/logo.jpg" alt="image">
        <ul>
            <li><a href="#"><b>Contact</b></a></li>
            <li><a href="#"><b>Services</b></a></li>
            <li><a href="#"><b>Help</b></a></li>
            <li><a href="#"><b>About</b></a></li>
        </ul>
        <a href="login.jsp" class="enlarge-btn">Login</a>
    </nav>

    <div class="content">        
        <div>
            <h1 class="monitoring-system">Class Monitoring System</h1>
           
            
        </div>
    </div>
    <footer>
        <p>&copy; 2024 Attendance System</p>
    </footer>
</body>
</html>