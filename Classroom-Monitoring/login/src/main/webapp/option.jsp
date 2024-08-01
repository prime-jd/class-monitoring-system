<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<% 
	if (session.getAttribute("username") == null){
		response.sendRedirect("login.jsp");
	}

	String username = request.getParameter("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
    /* CSS for logout button */
        .logout-btn {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #4da1ff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: transform 0.3s; 
            text-decoration: none;
            position: absolute;
            top: 20px;
            right: 20px;
        }
        
        .logout-btn:hover {
            transform: scale(1.1); /* Enlarge the button on hover */
        }
    </style>
    
</head>
<body>
    <header>
        <div class="container">
            <h1 style="text-align: center;">Welcome</h1> <!-- Displaying the username -->
        </div>
    </header>

    <!-- Logout button -->
    <a href="logout" class="logout-btn">Logout</a>

    <div class="container">
        <div class="dashboard">
            <!-- Check if success parameter is present in URL -->
            <% if (request.getParameter("success") != null && request.getParameter("success").equals("true")) { %>
                <div id="successMessage" style="color: green; text-align: center;">
                    Successfully logged in!
                </div>
            <% } %>
            
            <a href="timetable.jsp?username=<%=session.getAttribute("username") %>">Mark Attendance</a> <!-- Pass username to timetable.jsp -->
            <a href="#">View Profile</a>
            <a href="#">Login History</a>
        </div>
    </div>

    <footer>
        <div class="container bottom">
            <p>&copy; 2024 Attendance System</p>
        </div>
    </footer>
</body>
</html>
