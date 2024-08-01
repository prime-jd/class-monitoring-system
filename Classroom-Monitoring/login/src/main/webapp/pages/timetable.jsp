<%@ page import="com.class_monitoring.TimetableEntry" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.sql.*" %>

<% 
	if (session.getAttribute("username") == null){
		response.sendRedirect("login.jsp");
	}

	String username = request.getParameter("username");
%>

<%
String currentDay = LocalDate.now().getDayOfWeek().toString();
// Get the current time and day
LocalTime currentTime = LocalTime.now();
LocalDate currentDate = LocalDate.now();
DayOfWeek currentDayOfWeek = currentDate.getDayOfWeek();

// Get the selected weekday from the request parameter
String selectedWeekday = request.getParameter("weekday");

// Check if the selected weekday matches the current day of the week
boolean isCurrentDay = (selectedWeekday != null && selectedWeekday.equalsIgnoreCase(currentDayOfWeek.toString()));

// Define the last period's end time (adjust the time as needed)
LocalTime lastPeriodStartTime = LocalTime.of(16, 10); // Assuming the last period starts at 04:10 PM
LocalTime lastPeriodEndTime = LocalTime.of(17, 00); // Assuming the last period ends at 5:00 PM

// Establish database connection
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root", "Qwerty@101918");
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/style.css"> 
    
    <script>
    function redirectToClassroom(room, faculty, period, subject, currentDate, username, checkboxId) {
        var checkBox = document.getElementById(checkboxId);
        if (checkBox) {
            if (checkBox.checked) {
                // Construct the URL with room, faculty, period, subject, current date, and username parameters
                var url = "classroom.jsp?room=" + encodeURIComponent(room) + "&faculty=" + encodeURIComponent(faculty) + "&period=" + encodeURIComponent(period) + "&subject=" + encodeURIComponent(subject) + "&currentDate=" + encodeURIComponent(currentDate) + "&username=" + encodeURIComponent(username);
                window.location.href = url;
            } else {
                alert("Please mark the attendance before selecting.");
            }
        } else {
            alert("Error: Checkbox element not found.");
        }
    }
    </script>
</head>
<body>
<%
        // Redirect to TimetableServlet when the page is first loaded
        if (request.getParameter("weekday") == null & username != null) {
        	String redirectURL = "TimetableServlet?weekday=" + java.net.URLEncoder.encode(java.time.DayOfWeek.from(java.time.LocalDate.now()).name(), "UTF-8") 
        	+ "&username=" + java.net.URLEncoder.encode(username, "UTF-8");
            response.sendRedirect(redirectURL);
            return;
        }
    %>
<header style="background-color: #9d0000/*#4da1ff;*/; color: #fff; padding: 20px 0; margin-bottom: auto;">
    <div class="container">
        <h1 style="text-align: center;">Mark Attendance</h1>
        <h2  style="text-align: center;"><%= request.getParameter("username") %></h2>
        <div class="weekday-options">
            <form action="TimetableServlet" method="get">
                <label for="weekday">Select Weekday:</label>
                <select id="weekday" name="weekday">
                    <option value="Monday" <%= (currentDay.equals("Monday")) ? "selected" : "" %>>Monday</option>
                    <option value="Tuesday" <%= (currentDay.equals("TUESDAY")) ? "selected" : "" %>>Tuesday</option>
                    <option value="Wednesday" <%= (currentDay.equals("WEDNESDAY")) ? "selected" : "" %>>Wednesday</option>
                    <option value="Thursday" <%= (currentDay.equals("THURSDAY")) ? "selected" : "" %>>Thursday</option>
                    <option value="Friday" <%= (currentDay.equals("FRIDAY")) ? "selected" : "" %>>Friday</option>
                </select>
                <input type="hidden" name="username" value="<%= request.getParameter("username") %>">
                <input type="submit" value="View Timetable">
            </form>
        </div>
    </div>
</header>
<!-- Logout button -->
    <a href="logout" class="logout-btn">Logout</a>


<div class="container">
    <div class="dashboard">
        <h2>CSE-B (<%= (selectedWeekday != null) ? selectedWeekday.toUpperCase() : "Select a weekday" %>)</h2>
        <table class="attendance-table">
            <thead>
                <tr>
                    <th>Period</th>
                    <th>Room</th>
                    <th>Faculty</th>
                    <th>Subject</th>
                    <th>Mark</th>
                    <th>Status</th>
                    <th>Select</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String[] timeSlots = {"09:30 - 10:20", "10:20 - 11:10", "12:00 - 12:50", "12:50 - 01:40", "02:30 - 03:20", "03:20 - 04:10", "04:10 - 05:00"};
                    List<TimetableEntry> timetableData = (List<TimetableEntry>) request.getAttribute("timetableData");
                    if (timetableData != null && !timetableData.isEmpty()) {
                        // Get the current period from the request attribute
                        int currentPeriod = (int) request.getAttribute("currentPeriod");
                        // Iterate over the timetable entries
                        for (int period = 1; period <= 7; period++) {
                            TimetableEntry entry = timetableData.get(0); // Assuming all entries have the same data

                            // Check if the student's data exists in the csebstatus table for the current roll number, date, and period
                            boolean isChecked = false;
                            boolean isDisabled = false;
                            String rollNo = request.getParameter("username");
                            String date = currentDate.toString();
                            // Query to check if the student's data exists in csebstatus table
                            String checkQuery = "SELECT * FROM csebstatus WHERE ROLL_NO=? AND DATE_=? AND PERIOD=?";
                            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                            checkStmt.setString(1, rollNo);
                            checkStmt.setString(2, date);
                            checkStmt.setInt(3, period);
                            ResultSet checkRs = checkStmt.executeQuery();
                            if (checkRs.next()) {
                                isChecked = true;
                                isDisabled = true; // Disable both checkbox and select button if data exists
                            }
                    %>
                            <tr>
                                <td><%=timeSlots[period-1]%></td>
                                <td><%= entry.getRoom(period) %></td>
                                <td><%= entry.getFaculty(period) %></td>
                                <td><%= entry.getSubject(period) %></td>
                                <td>
                                    <input type="checkbox" id="mark<%= period %>" <%= (isCurrentDay && ((period == currentPeriod && period != 7) || (period == 7 && currentTime.isBefore(lastPeriodEndTime) && currentTime.isAfter(lastPeriodStartTime)))) ? "" : "disabled" %> <%= (isChecked) ? "checked" : "" %> <%= (isDisabled) ? "disabled" : "" %>>
                                </td>
                                <td>
                                    <span class="<%= (isChecked) ? "green" : "red" %>">
                                        <%= (isChecked) ? "Checked" : "Uncheck" %>
                                    </span>
                                </td>
                                <td>
                                    <button onclick="redirectToClassroom('<%= entry.getRoom(period) %>', '<%= entry.getFaculty(period) %>', '<%= period %>', '<%= entry.getSubject(period) %>', '<%= currentDate %>', '<%= request.getParameter("username") %>', 'mark<%= period %>')" <%= (isCurrentDay && ((period == currentPeriod && period != 7) || (period == 7 && currentTime.isBefore(lastPeriodEndTime)))) ? "" : "disabled" %> <%= (isDisabled) ? "disabled" : "" %>>Select</button>
                                </td>
                            </tr>
                    <%
                        }
                    } else { %>
                        <tr>
                            <td colspan="6">No timetable data available for <%= selectedWeekday %></td>
                        </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<footer style="background-color: #9d0000/*#4da1ff;*/; color: #fff; padding: 20px 0; margin-bottom: auto;">
    <div class="container">
        <p>&copy; 2024 Attendance System</p>
    </div>
</footer>
</body>
</html>
