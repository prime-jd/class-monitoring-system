<%@ page import="com.class_monitoring.TimetableEntry" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.temporal.TemporalAdjusters" %>

<% 
    if (session.getAttribute("username") == null){
        response.sendRedirect("login.jsp");
    }

    String username = request.getParameter("username");

    // Redirect to TimetableServlet when the page is first loaded
    if (request.getParameter("selectedDate") == null && username != null) {
        String redirectURL = "TimetableServlet?selectedDate=" + java.net.URLEncoder.encode(java.time.LocalDate.now().toString(), "UTF-8") 
            + "&username=" + java.net.URLEncoder.encode(username, "UTF-8");
        response.sendRedirect(redirectURL);
        return;
    }
%>

<%
//Get the current date
LocalDate currentDate = LocalDate.now();
LocalTime currentTime = LocalTime.now();

//Get the selected date from the request parameter
String selectedDateParam = request.getParameter("selectedDate");

// Parse the selected date into a LocalDate object
LocalDate selectedDate = LocalDate.parse(selectedDateParam);

// Get the selected weekday from the selected date
DayOfWeek selectedDayOfWeek = selectedDate.getDayOfWeek();

// Convert the DayOfWeek enum to a string representation
String selectedWeekday = selectedDayOfWeek.toString();

DayOfWeek currentDayOfWeek = currentDate.getDayOfWeek();

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
    function performAction() {
        // Get the selected date from the input field
        var selectedDate = document.getElementById("selectedDate").value;
        // Get the username from the hidden input field
        var username = '<%= username %>'; // Retrieve username from JSP
        // Call the redirectToClassroom function with the selected date
        redirectToClassroom(room, faculty, period, subject, currentDate, username, checkboxId);
    }

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
            <h1 style="text-align: center;">Mark Attendance</h1>
            <div class="weekday-options">
                <!-- Add an input field for selecting a date -->
               
                <!-- Add a button to trigger the action -->
             

                <!-- Modify the form action to send the selected date to the servlet -->
                <form action="TimetableServlet" method="get">
                 <label for="selectedDate">Select Date:</label>
                <input type="date" id="selectedDate" name="selectedDate" value="<%= LocalDate.now() %>">
                    <!-- Include other form elements if needed -->
                    <!-- Pass the selected date as a parameter to the servlet -->
                    <input type="hidden" name="selectedDate" id="selectedDateHidden">
                    <input type="hidden" name="username" value="<%= username %>">
                    <button type="submit">View</button>
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
                        // Retrieve the selected date
                        // Retrieve the selected date as a String
String selectedDateStr = request.getParameter("selectedDate");

// Parse the String representation of the date into a LocalDate object
selectedDate = LocalDate.parse(selectedDateStr);

java.sql.Date sqlDate = java.sql.Date.valueOf(selectedDate);
                        // Determine the current day of the week
                        String currentDayOfWeeks = LocalDate.now().getDayOfWeek().toString();
                        // Iterate over the timetable entries
                        for (int period = 1; period <= 7; period++) {
    // Get the timetable entry for the current period
    TimetableEntry entry = timetableData.get(0); // Adjust index to start from 0

    // Check if the student's data exists in the csebstatus table for the current roll number, date, and period
    boolean isChecked = false;
    boolean isDisabled = false;
    String rollNo = username;
    
    // Check if the current day matches the selected weekday
    //isCurrentDay = (selectedWeekday != null && selectedWeekday.equalsIgnoreCase(currentDayOfWeeks));

    // Checkbox enablement condition
   // boolean isCheckboxEnabled = isCurrentDay && (period == currentPeriod);
    
    // Query to check if the student's data exists in csebstatus table
    String checkQuery = "SELECT * FROM csebstatus WHERE ROLL_NO=? AND DATE_=? AND PERIOD=?";
    PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
    checkStmt.setString(1, rollNo);
    checkStmt.setDate(2, sqlDate); 
    checkStmt.setInt(3, period);
    ResultSet checkRs = checkStmt.executeQuery();
    
    // Check if the student's data exists
    if (checkRs.next()) {
        isChecked = true;
        isDisabled = true; // Disable both checkbox and select button if data exists
    }
                    %>
                    <tr>
                        <td><%= timeSlots[period-1] %></td>
                        <td><%= entry.getRoom(period) %></td>
                        <td><%= entry.getFaculty(period) %></td>
                        <td><%= entry.getSubject(period) %></td>
                        <td>
                            <input type="checkbox" id="mark<%= period %>" <%= (isCurrentDay && (period == currentPeriod)) ? "" : "disabled" %> <%= (isChecked) ? "checked" : "" %> <%= (isDisabled) ? "disabled" : "" %>>
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
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2024 Attendance System</p>
        </div>
    </footer>
</body>
</html>
