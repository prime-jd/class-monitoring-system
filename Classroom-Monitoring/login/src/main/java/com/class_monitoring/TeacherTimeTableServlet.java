package com.class_monitoring;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import java.security.SecureRandom;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/TeacherTimeTableServlet")
public class TeacherTimeTableServlet extends HttpServlet {
	
	
    // doPost method

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String tid = (String) session.getAttribute("TID");
        if (tid == null || tid.isEmpty()) {
            out.println("<html><body><h2>Error: Teacher ID is empty</h2></body></html>");
            return;
        }

        Connection conn = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root", "Qwerty@101918");

            String query = "SELECT * FROM TeacherTimeTable WHERE TID=? and day=?";
            preparedStatement = conn.prepareStatement(query);
            preparedStatement.setString(1, tid);

            out.println("<html><head><style>");
            out.println("table { border-collapse: collapse; width: 100%; margin-top: 30px; margin-bottom: 30px; }"); // Add margin-top and margin-bottom for the table
            out.println("th, td { border: 1px solid brown; text-align: center; padding: 8px; color: brown; }"); // Brown border and text for cells
            out.println("tr:nth-child(even) { background-color: #f2f2f2; }");
            out.println("th { background-color: brown; color: white; }"); // Brown background with white text for headings
            out.println("header { margin-bottom: 30px; }"); // Add margin-bottom for the header
            out.println("footer { margin-top: 1600px; }"); // Add margin-top for the footer
            out.println("header, footer { background-color: rgba(255, 165, 0, 0.5); color: brown; padding: 10px; text-align: center;border-radius:20px; }");
            out.println("</style></head><body>");




            // Header
            out.println("<header>");
            out.println("<h1>Teacher Time Table</h1>");
            out.println("<h2>TID: " + tid + "</h2>");
            out.println("</header>");

            // Table
            out.println("<table>");
            out.println("<tr><th>Day</th>");
            String[] timeSlots = {"1", "2", "3", "4", "5", "6", "7"};
            for (String timeSlot : timeSlots) {
                out.println("<th>" + timeSlot + "</th>");
            }
            out.println("</tr>");

            String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};

            for (int k = 0; k < 6; k++) {
                preparedStatement.setString(2, days[k]);
                resultSet = preparedStatement.executeQuery();

                while (resultSet.next()) {
                    String day = resultSet.getString("Day");
                    out.println("<tr>");
                    out.println("<td>" + day + "</td>");
                    for (int i = 1; i <= 7; i++) {
                        String subject = resultSet.getString("SC" + i);
                        String venue = resultSet.getString("V" + i);
                        if (subject == null && venue == null) {
                            subject = " ";
                            venue = " ";
                            out.println("<td>" + subject + "<br>" + venue + "</td>");
                        } else
                            out.println("<td><form action=\"CSEBStatusServlet\" method=\"post\"><button type=\"submit\" name=\"subject\" value=\"" + subject + "\">" + subject + "<br>" + venue +
                            		"</button></form><br></td>");
                    }
                    out.println("</tr>");
                }

            }

            out.println("</table>");
            out.println("<hr>");
            // Footer
            out.println("<footer style=\"height : 120vh;>");
            out.println("<p>&copy; 2024 Class Monitoring System</p>");
            out.println("</footer>");

            out.println("</body></html>");

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
        }
    }
}