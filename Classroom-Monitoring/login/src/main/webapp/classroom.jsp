<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	if (session.getAttribute("username") == null){
		response.sendRedirect("login.jsp");
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Classroom Attendance Form</title>
    <link rel="stylesheet" href="css/classroom_style.css"> 
</head>
<body>
    <%-- Scriptlets to retrieve parameters --%>
    <%
        String username = request.getParameter("username");
        String room = request.getParameter("room");
        String faculty = request.getParameter("faculty");
        String period = request.getParameter("period");
        String subject = request.getParameter("subject");
        String currentDate = request.getParameter("currentDate");
    %>

    <div class="container">
        <div class="heading">
            <h1>Classroom Details</h1>
        </div>
        <form action="AttendanceServlet" method="post">
           <div class="form-group"> 
           	       <label for="Roll No">Roll No:</label>   
                   <input type="text" id="username" name="username" value="<%= username %>" readonly>
            </div> 
            <div class="form-group">
                <label for="room-no">Room:</label>
                <input type="text" id="room-no" name="room" value="<%= room %>" required>
            </div>
            <div class="form-group">
                <label for="faculty">Faculty:</label>
                <input type="text" id="faculty" name="faculty" value="<%= faculty %>" required>
            </div>
            <div class="form-group">
                <label for="period">Period:</label>
                <input type="text" id="period" name="period" value="<%= period %>" readonly>
            </div>
            <div class="form-group">
                <label for="subject">Subject:</label>
                <input type="text" id="subject" name="subject" value="<%= subject %>" required>
            </div>
            <div class="form-group">
                <label for="seat-no">Seat:</label>
                <input type="text" id="seat-no" name="seat" placeholder="Enter Seat No" required>
            </div>

            <div class="form-group">
                <input type="hidden" id="currentDate" name="currentDate" value="<%= currentDate %>">
            </div> 
            <div class="form-group">
                <label for="otp">OTP:</label>
                <input type="number" id="otp" name="otp" maxlength="4" placeholder="Enter OTP (4 digits)" required>
                <!-- Check if error parameter exists and display error message -->
            <% String errorMessage = request.getParameter("error");
            if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <p style="color: red;"><%= errorMessage %></p>
            <% } %>
            </div>
            <button type="submit" class="submit-btn">Submit</button>
        </form>
    </div>
    
    <!-- JS -->
    <script src="vendor/jquery/jquery.min.js"><</script>
    <script src="js/main.js"></script>
     
    
</body>
</html>
