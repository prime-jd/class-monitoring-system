package com.class_monitoring;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Retrieve form data
        	PrintWriter out = response.getWriter();
            String username = request.getParameter("username");
            String room = request.getParameter("room");
            String faculty = request.getParameter("faculty");
            int period = Integer.parseInt(request.getParameter("period"));
            String subject = request.getParameter("subject");
            int seat = Integer.parseInt(request.getParameter("seat"));
            LocalDate localDate = LocalDate.parse(request.getParameter("currentDate"));
            LocalTime currentTime = LocalTime.now();
            int enteredOTP = Integer.parseInt(request.getParameter("otp")); // New line to get entered OTP
            
            // Convert LocalDate to java.sql.Date
            Date sqlDate = Date.valueOf(localDate);
            Time sqlTime = Time.valueOf(currentTime);

            // Database connection details (Replace with your own)
            Class.forName("com.mysql.cj.jdbc.Driver"); // Example for MySQL
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/attendance", 
                    "root", "Qwerty@101918" 
            );
            
            // Prepare SQL query to fetch OTP based on class and period
            String otpQuery = "SELECT OTP FROM OTP WHERE DATE_ = ? AND CLASS = ? AND PERIOD = ?";
            PreparedStatement otpStmt = con.prepareStatement(otpQuery);
            otpStmt.setDate(1, sqlDate);;
            otpStmt.setString(2, "CSE-B");
            otpStmt.setInt(3, period);
            ResultSet otpRs = otpStmt.executeQuery();
            
            // If a record is found, retrieve OTP
            int fetchedOTP = 0;
            if (otpRs.next()) {
                fetchedOTP = otpRs.getInt("OTP");
            }
            
            // Compare the entered OTP with the fetched OTP
            if (enteredOTP != fetchedOTP) {
                // Redirect back to classroom.jsp with error message and input data
                String redirectURL = "classroom.jsp?username=" + username +
                                     "&room=" + room +
                                     "&faculty=" + faculty +
                                     "&period=" + period +
                                     "&subject=" + subject +
                                     "&seat=" + seat +
                                     "&currentDate=" + localDate.toString() +
                                     "&error=Incorrect+OTP";
                response.sendRedirect(redirectURL);
                return; // Stop further processing
            }
            
            // Prepare SQL query to insert attendance record
            String sql = "INSERT INTO CSEBstatus (ROLL_NO, DATE_, Time_, CLASS, ROOM_NO, PERIOD, SUBJECT_CODE, Faculty, SEAT_NO) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(sql);

            // Set parameter values
            pstmt.setString(1, username);
            pstmt.setDate(2, sqlDate); 
            pstmt.setTime(3, sqlTime);
            pstmt.setString(4,  "CSE-B"); // Hardcoded class
            pstmt.setString(5, room);
            pstmt.setInt(6, period);
            pstmt.setString(7, subject);
            pstmt.setString(8, faculty);
            pstmt.setInt(9, seat);

            // Execute the query
            pstmt.executeUpdate();
            
            // Redirect to success page
            String redirectURL = "timetable.jsp?username=" + java.net.URLEncoder.encode(username, "UTF-8");
            response.sendRedirect(redirectURL);
                    
        } catch (SQLException e) {
            // Handle SQL-specific issues
            e.printStackTrace(); // Log the error details
            response.sendRedirect("error.jsp?message=Database+error"); 
        } catch (Exception e) {
            // Handle general exceptions
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Unknown+error");
        }
    }
}
