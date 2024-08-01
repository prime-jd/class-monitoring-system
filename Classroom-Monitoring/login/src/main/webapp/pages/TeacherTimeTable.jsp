<%@ page import="com.class_monitoring.OTPGenerator" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.annotation.WebServlet" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Teacher Time Table</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        th, td {
            border: 1px solid brown;
            text-align: center;
            padding: 8px;
            color: brown;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        th {
            background-color: brown;
            color: white;
        }

        header {
            margin-bottom: 30px;
            background-color: rgba(255, 165, 0, 0.5);
            color: brown;
            padding: 10px;
            text-align: center;
            border-radius: 20px;
        }

        footer {
    background-color: rgba(255, 165, 0, 0.5);
    color: brown;
    padding: 10px;
    text-align: center;
    border-radius: 20px;
}

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
<%
    HttpSession sessionObj = request.getSession();
    String tid = (String) sessionObj.getAttribute("TID");
    if (tid == null || tid.isEmpty()) {
%>
    <header>
        <h1>Error: Teacher ID is empty</h1>
    </header>
<%
        return;
    }
 // Fetch existing OTP from request parameter
    String existingOTP = request.getParameter("otp");
%>


<header>
    <h1>Teacher Time Table</h1>
    <h2>TID: <%= tid %></h2>
</header>
<!-- Logout button -->
    <a href="logout" class="logout-btn">Logout</a>
<table>
    <tr>
        <th>Day</th>
        <%
            String[] timeSlots = {"1", "2", "3", "4", "5", "6", "7"};
            for (String timeSlot : timeSlots) {
        %>
            <th><%= timeSlot %></th>
        <%
            }
        %>
    </tr>
    <%
        Connection conn = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root", "Qwerty@101918");

            String query = "SELECT * FROM TeacherTimeTable WHERE TID=? and day=?";
            preparedStatement = conn.prepareStatement(query);
            preparedStatement.setString(1, tid);

            String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};

            for (String day : days) {
                preparedStatement.setString(2, day);
                resultSet = preparedStatement.executeQuery();

                while (resultSet.next()) {
                    String dbDay = resultSet.getString("Day");
                    if (dbDay.equals(day)) {
    %>
                        <tr>
                            <td><%= dbDay %></td>
                            <%
                                for (int i = 1; i <= 7; i++) {
                                    String subject = resultSet.getString("SC" + i);
                                    String venue = resultSet.getString("V" + i);
                                    if (subject == null && venue == null) {
                                        subject = " ";
                                        venue = " ";
                            %>
                                        <td><%= subject %><br><%= venue %></td>
                            <%
                                    } else {
                            %>
                                        <td>
                                            <form action="CSEBStatusServlet" method="post">
                                                <button type="submit" name="subject" value="<%= subject %>">
                                                    <%= subject %><br><%= venue %>
                                                </button>
                                            </form>
                                            <br>
                                        </td>
                            <%
                                    }
                                }
                            %>
                        </tr>
    <%
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>
</table>
<!-- Display the existing or generated OTP -->
<div>
    <%  
    // Display the existing OTP if available, otherwise display the newly generated OTP
    String displayedOTP = existingOTP != null ? existingOTP : OTPGenerator.generateOTP();
    %>
    <p>Generated OTP: <%= displayedOTP %></p>
</div>

<!-- Generate OTP button -->
<form action="GenerateOTPServlet" method="post">
    <button type="submit">GENERATE OTP</button>
</form>
<hr>
<footer>
    <p>&copy; 2024 Class Monitoring System</p>
</footer>
</body>
</html>

