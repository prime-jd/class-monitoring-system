package com.class_monitoring;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CSEBStatusServlet")
public class CSEBStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve the subject code and date from the request parameters
        String subjectCode = request.getParameter("subject");
        String date = request.getParameter("date"); // Assuming the date format is yyyy-MM-dd

        Connection conn = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            // Establish database connection
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root", "Qwerty@101918");

            // If date is null, set it to the current date
            if (date == null || date.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                date = sdf.format(new Date());
            }

            // Query to select data from CSEBstatus table for the given subject code and date
            String query = "SELECT * FROM CSEBstatus WHERE SUBJECT_CODE=? AND DATE_=?";
            preparedStatement = conn.prepareStatement(query);
            preparedStatement.setString(1, subjectCode);
            preparedStatement.setString(2, date);

            // Execute the query
            resultSet = preparedStatement.executeQuery();

            // Generate HTML table to display the results
            out.println("<html><head><title>Subject Code Status</title>");
            out.println("<style>");
            out.println("table { border-collapse: collapse; width: 100%;margin-bottom:500px }");
            out.println("th, td { border: 1px solid #dddddd; text-align: center; padding: 8px; }");
            out.println("th { background-color: #f2f2f2; }");
            out.println("header, footer { background-color: rgba(255, 165, 0, 0.5); color: brown; padding: 10px; text-align: center; border-radius:20px;}");
            
            out.println("</style>");
            out.println("</head><body>");

            // Header
            out.println("<header>");
            out.println("<h1>Subject Code Status</h1>");
            out.println("</header>");
            
            out.println("<a href = \"TeacherTimeTable.jsp\" >Back</a>");

            // Table content
            out.println("<h2 style=\"color: brown; text-align: center;\">Subject : "+ subjectCode + " on " + date + "</h2>");

            // Date input field
            out.println("<form action=\"\" method=\"post\">");
            out.println("<label for=\"date\" style=\"font-weight: bold;\">Select Date:</label>");
            out.println("<input type=\"date\" id=\"date\" name=\"date\" value=\"" + date + "\" style=\"margin-left: 10px;\">");
            out.println("<input type=\"hidden\" name=\"subject\" value=\"" + subjectCode + "\">");
            out.println("<input type=\"submit\" value=\"Submit\" style=\"margin-left: 10px; background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer;\">");
            out.println("</form>");

            // Table
            out.println("<table>");
            out.println("<tr><th>Roll No</th><th>Date</th><th>Time</th><th>Room No</th><th>Period</th><th>Subject Code</th><th>Faculty</th><th>Seat No</th></tr>");
            while (resultSet.next()) {
                out.println("<tr>");
                out.println("<td>" + resultSet.getString("ROLL_NO") + "</td>");
                out.println("<td>" + resultSet.getDate("DATE_") + "</td>");
                out.println("<td>" + resultSet.getTime("TIME_") + "</td>");
                out.println("<td>" + resultSet.getString("ROOM_NO") + "</td>");
                out.println("<td>" + resultSet.getInt("PERIOD") + "</td>");
                out.println("<td>" + resultSet.getString("SUBJECT_CODE") + "</td>");
                out.println("<td>" + resultSet.getString("Faculty") + "</td>");
                out.println("<td>" + resultSet.getInt("SEAT_NO") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");

            // Footer
            out.println("<footer  style=\\\"height : 120vh;>");
            out.println("<p>&copy; 2024 Class Monitoring System</p>");
            out.println("</footer>");

            out.println("</body></html>");

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}