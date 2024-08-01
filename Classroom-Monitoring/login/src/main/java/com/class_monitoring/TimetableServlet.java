package com.class_monitoring;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/TimetableServlet")
public class TimetableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Get the selected date from the request parameter
        String selectedDateStr = request.getParameter("selectedDate");
        
        // Parse the selected date into a LocalDate object
        LocalDate selectedDate = LocalDate.parse(selectedDateStr);
        
        // Get the day of the week from the selected date
        DayOfWeek selectedDayOfWeek = selectedDate.getDayOfWeek();

        // Convert the selected day of week to a string (e.g., "MONDAY")
        String selectedDay = selectedDayOfWeek.toString();

        // Your existing database connection and query code
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root", "Qwerty@101918");

            String query = "SELECT * FROM Timetable WHERE Day=?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, selectedDay);
            rs = stmt.executeQuery();

            // Store fetched data in a list of timetable entries
            List<TimetableEntry> timetableData = new ArrayList<>();
            while (rs.next()) {
                TimetableEntry entry = new TimetableEntry();
                // Populate TimetableEntry object with data from the ResultSet
                // (Assuming the column names in the ResultSet match the property names in TimetableEntry)
                // For example:
                entry.setR1(rs.getString("R1"));
                entry.setT1(rs.getString("T1"));
                entry.setSC1(rs.getString("SC1"));
                
                entry.setR2(rs.getString("R2"));
                entry.setT2(rs.getString("T2"));
                entry.setSC2(rs.getString("SC2"));
                
                entry.setR3(rs.getString("R3"));
                entry.setT3(rs.getString("T3"));
                entry.setSC3(rs.getString("SC3"));
                
                entry.setR4(rs.getString("R4"));
                entry.setT4(rs.getString("T4"));
                entry.setSC4(rs.getString("SC4"));
                
                entry.setR5(rs.getString("R5"));
                entry.setT5(rs.getString("T5"));
                entry.setSC5(rs.getString("SC5"));
                
                entry.setR6(rs.getString("R6"));
                entry.setT6(rs.getString("T6"));
                entry.setSC6(rs.getString("SC6"));
                
                entry.setR7(rs.getString("R7"));
                entry.setT7(rs.getString("T7"));
                entry.setSC7(rs.getString("SC7"));
                
                
                
               
                // Similarly for other columns...
                
                timetableData.add(entry);
            }

            // Set timetableData as a request attribute
            request.setAttribute("timetableData", timetableData);

            // Get the current period
            int currentPeriod = TimeUtil.getCurrentPeriod();
            // Set currentPeriod as a request attribute
            request.setAttribute("currentPeriod", currentPeriod);

            // Get the current date
            LocalDate currentDate = LocalDate.now();
            // Set currentDate as a request attribute
            request.setAttribute("currentDate", currentDate);

            // Forward the request to the timetable.jsp page
            request.getRequestDispatcher("timetable.jsp").forward(request, response);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // Close database resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
