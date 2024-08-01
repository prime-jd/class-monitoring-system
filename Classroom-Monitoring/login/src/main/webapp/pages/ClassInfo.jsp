<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Calendar" %>
<% 
	if (session.getAttribute("TID") == null){
		response.sendRedirect("login.jsp");
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Classroom Attendance Form</title>
    <link rel="stylesheet" type="text/css" href="css/ClassInfoStyle.css">
</head>
<body>
    <div class="container">
        <div class="heading">
            <h1>Class Info</h1>
        </div>
        <% 
            String className = request.getParameter("class");
            String period = request.getParameter("period");
            String selectedDateStr = request.getParameter("selectedDateStr");
            String subject = request.getParameter("subject");
            String count = request.getParameter("count");
            String room = request.getParameter("room");

            String faculty = "";
            String firstResponse = "";
            String roll = "";
            String seatNo = "";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/attendance";
                String username = "root";
                String password = "Qwerty@101918";

                Connection conn = DriverManager.getConnection(url, username, password);
                String query = "SELECT Faculty, TIME_, ROLL_NO, SEAT_NO FROM csebstatus WHERE CLASS = ? AND DATE_ = ? AND PERIOD = ? ORDER BY TIME_ LIMIT 1";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, className);
                pstmt.setDate(2, java.sql.Date.valueOf(selectedDateStr));
                pstmt.setInt(3, Integer.parseInt(period));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    faculty = rs.getString("Faculty");
                    firstResponse = rs.getTime("TIME_").toString();
                    roll = rs.getString("ROLL_NO");
                    seatNo = rs.getString("SEAT_NO");
                }

                rs.close();
                pstmt.close();
                conn.close();
            } catch (ClassNotFoundException | SQLException e) {
                // Log the error for debugging
                e.printStackTrace(); 
                // Display a generic error message to the user, don't expose internal details
                out.println("<p>An error occurred. Please contact the administrator.</p>"); 
            } catch (NumberFormatException e) {
                 // Handle the case where the "period" parameter is not a valid number
            } catch (IllegalArgumentException e) {
                // Handle invalid date format, display a suitable message to the user
            }
        %>
        <form action="" >
            <div class="form-group"> 
                <label for="Class">Class:</label>   
                <input type="text" id="Class" name="Class" value="<%= className %>" readonly>
            </div> 
            <div class="form-group"> 
                <label for="Period">Period:</label>   
                <input type="text" id="Period" name="Period" value="<%= period %>" readonly>
            </div> 
            <div class="form-group">
                <label for="room-no">Room:</label>
                <input type="text" id="room-no" name="room" value="<%= room %>" readonly>
            </div>
            <div class="form-group">
                <label for="subject">Subject:</label>
                <input type="text" id="subject" name="subject" value="<%= subject %>" readonly>
            </div>
            <div class="form-group">
                <label for="faculty">Faculty:</label>
                <input type="text" id="faculty" name="faculty" value="<%= faculty %>" readonly>
            </div>
            <div class="form-group">
                <label for="count">Total Response:</label>
                <input type="text" id="count" name="count" value="<%= count %>" readonly>
            </div>
            <div class="form-group">
                <label for="First-Response">First Response:</label>
                <input type="text" id="First-Response" name="First-Response" value="<%= firstResponse %>" readonly>
            </div>
            <div class="form-group">
                <label for="Roll">Roll:</label>
                <input type="text" id="Roll" name="Roll" value="<%= roll %>" readonly>
            </div>
            <div class="form-group">
                <label for="seat">Seat No:</label>
                <input type="text" id="seat" name="seat" value="<%= seatNo %>" readonly>
            </div>
            <a href = "hod.jsp" >Back</a>
        </form>
    </div>
</body>
</html>
