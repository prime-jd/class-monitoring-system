<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.class_monitoring.TimetableEntry" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<% 
    if (session.getAttribute("TID") == null){
        response.sendRedirect("login.jsp");
    }
%>

<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/attendance";
    String username = "root";
    String password = "Qwerty@101918";

    // Get the selected date from the request parameter or default to the current date
    String selectedDateStr = request.getParameter("date");
    if (selectedDateStr == null || selectedDateStr.isEmpty()) {
        // Default to current date if no date is selected
        selectedDateStr = new java.sql.Date(Calendar.getInstance().getTime().getTime()).toString();
    }
    
    // Get the day of the selected date
    Calendar cal = Calendar.getInstance();
    cal.setTime(java.sql.Date.valueOf(selectedDateStr));
    int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    String dayOfWeekStr;
    switch (dayOfWeek) {
        case Calendar.SUNDAY:
            dayOfWeekStr = "Sunday";
            break;
        case Calendar.MONDAY:
            dayOfWeekStr = "Monday";
            break;
        case Calendar.TUESDAY:
            dayOfWeekStr = "Tuesday";
            break;
        case Calendar.WEDNESDAY:
            dayOfWeekStr = "Wednesday";
            break;
        case Calendar.THURSDAY:
            dayOfWeekStr = "Thursday";
            break;
        case Calendar.FRIDAY:
            dayOfWeekStr = "Friday";
            break;
        case Calendar.SATURDAY:
            dayOfWeekStr = "Saturday";
            break;
        default:
            throw new IllegalStateException("Unexpected value: " + dayOfWeek);
    }


    // Initialize database connection and prepare SQL statements
    List<String> classNames = new ArrayList<>();
    Map<String, List<Integer>> classCounts = new HashMap<>();
    Map<String, TimetableEntry> timetableMap = new HashMap<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);

        // Retrieve the TID from the session
        HttpSession sessionObj = request.getSession(false);
        String TID = null;
        if (sessionObj != null) {
            TID = (String) sessionObj.getAttribute("TID");
        }
        if (TID != null) {
            // Fetch class names based on TID
            String classQuery = "SELECT CLASSNAME FROM CLASSES WHERE DEPTNAME = (SELECT DEPTNAME FROM TEACHERINFO WHERE TID=?)";
            PreparedStatement classStmt = conn.prepareStatement(classQuery);
            classStmt.setString(1, TID);
            ResultSet classRs = classStmt.executeQuery();
            while (classRs.next()) {
                classNames.add(classRs.getString("CLASSNAME"));
            }

            // Fetch count for each class and period
            String countQuery = "SELECT COUNT(*) AS count FROM CSEBstatus WHERE CLASS = ? AND PERIOD = ? AND DATE_ = ?";
            PreparedStatement countStmt = conn.prepareStatement(countQuery);

            // Fetch timetable information for the selected date
            String timetableQuery = "SELECT * FROM Timetable WHERE Day = ?";
            PreparedStatement timetableStmt = conn.prepareStatement(timetableQuery);
            timetableStmt.setString(1, dayOfWeekStr);
            ResultSet timetableRs = timetableStmt.executeQuery();
            while (timetableRs.next()) {
                TimetableEntry entry = new TimetableEntry();
                entry.setR1(timetableRs.getString("R1"));
                entry.setT1(timetableRs.getString("T1"));
                entry.setSC1(timetableRs.getString("SC1"));
                // Set other periods as well...
                entry.setR2(timetableRs.getString("R2"));
                entry.setT2(timetableRs.getString("T2"));
                entry.setSC2(timetableRs.getString("SC2"));
                entry.setR3(timetableRs.getString("R3"));
                entry.setT3(timetableRs.getString("T3"));
                entry.setSC3(timetableRs.getString("SC3"));
                entry.setR4(timetableRs.getString("R4"));
                entry.setT4(timetableRs.getString("T4"));
                entry.setSC4(timetableRs.getString("SC4"));
                entry.setR5(timetableRs.getString("R5"));
                entry.setT5(timetableRs.getString("T5"));
                entry.setSC5(timetableRs.getString("SC5"));
                entry.setR6(timetableRs.getString("R6"));
                entry.setT6(timetableRs.getString("T6"));
                entry.setSC6(timetableRs.getString("SC6"));
                entry.setR7(timetableRs.getString("R7"));
                entry.setT7(timetableRs.getString("T7"));
                entry.setSC7(timetableRs.getString("SC7"));
                timetableMap.put(timetableRs.getString("Class"), entry);
            }

            // Loop through each class and populate classCounts
            for (String className : classNames) {
                List<Integer> counts = new ArrayList<>();
                for (int period = 1; period <= 7; period++) {
                    countStmt.setString(1, className);
                    countStmt.setInt(2, period);
                    countStmt.setString(3, selectedDateStr);
                    ResultSet countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        counts.add(countRs.getInt("count"));
                    } else {
                        counts.add(0);
                    }
                    countRs.close();
                }
                classCounts.put(className, counts);
            }

            // Close resources
            classRs.close();
            classStmt.close();
            countStmt.close();
            timetableRs.close();
            timetableStmt.close();
        }
        conn.close();
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Timetable</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="css/HodStyle.css" rel="stylesheet">
   
</head>

<body >
    <!-- Logout button -->
    <a href="logout" class="logout-btn">Logout</a>
    
    <div class="container">
        <h2>Select Date:</h2>
        <form action="hod.jsp" method="get">
            <input type="date" name="date" value="<%= selectedDateStr %>">
            <input type="submit" value="View Status">
        </form>
        
        <h2>Status of Date <%= selectedDateStr %></h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Class</th>
                    <th>Period 1</th>
                    <th>Period 2</th>
                    <th>Period 3</th>
                    <th>Period 4</th>
                    <th>Period 5</th>
                    <th>Period 6</th>
                    <th>Period 7</th>
                </tr>
            </thead>
            <tbody>
                <% for(String className : classNames) { %>
                    <tr>
                        <td><%= className %></td>
                        <% TimetableEntry timetableEntry = timetableMap.get(className); %>
                        <% if (timetableEntry != null) { %>
                            <% for (int period = 1; period <= 7; period++) { %>
                                <td>
                                    <%= timetableEntry.getRoom(period) %><br>
                                    <%= timetableEntry.getSubject(period) %><br>
                                    <% if (classCounts.get(className).get(period - 1) != 0) { %>
                                        <a href="ClassInfo.jsp?class=<%= className %>&period=<%= period %>&room=<%= timetableEntry.getRoom(period) %>&selectedDateStr=<%= selectedDateStr %>&subject=<%= timetableEntry.getSubject(period) %>&count=<%= classCounts.get(className).get(period - 1) %>">
                                            <%= classCounts.get(className).get(period - 1) %>
                                        </a>
                                    <% } else { %>
                                        <%= classCounts.get(className).get(period - 1) %>
                                    <% } %>
                                </td>
                            <% } %>
                        <% } else { %>
                            <td colspan="7">No Status available for this class</td>
                        <% } %>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
