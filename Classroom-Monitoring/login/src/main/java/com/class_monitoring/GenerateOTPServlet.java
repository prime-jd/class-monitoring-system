package com.class_monitoring;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GenerateOTPServlet")
public class GenerateOTPServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch necessary data
        String tid = (String) request.getSession().getAttribute("TID");
        int currentPeriod = TimeUtil.getCurrentPeriod();
        String className = "CSE-B"; // Fetch class name from database as mentioned in the requirements

        // Get the existing OTP from the database for the current date, class, and period
        String existingOTP = getExistingOTP(className, currentPeriod);

        if (existingOTP != null) {
            // If OTP exists, redirect back to TeacherTimeTable.jsp with the existing OTP
            response.sendRedirect("TeacherTimeTable.jsp?otp=" + existingOTP);
            return;
        }

        // If no existing OTP found, generate a new OTP
        String generatedOTP = OTPGenerator.generateOTP();

        // Store the newly generated OTP in the database
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root", "Qwerty@101918");

            String query = "INSERT INTO OTP (DATE_, CLASS, PERIOD, OTP) VALUES (?, ?, ?, ?)";
            PreparedStatement preparedStatement = conn.prepareStatement(query);
            preparedStatement.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            preparedStatement.setString(2, className);
            preparedStatement.setInt(3, currentPeriod);
            preparedStatement.setString(4, generatedOTP);

            preparedStatement.executeUpdate();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        // Redirect back to TeacherTimeTable.jsp with the newly generated OTP
        response.sendRedirect("TeacherTimeTable.jsp?otp=" + generatedOTP);
    }

    // Method to fetch the existing OTP from the database based on date, class, and period
    private String getExistingOTP(String className, int currentPeriod) {
        String existingOTP = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root", "Qwerty@101918");

            String query = "SELECT OTP FROM OTP WHERE DATE_ = ? AND CLASS = ? AND PERIOD = ?";
            PreparedStatement preparedStatement = conn.prepareStatement(query);
            preparedStatement.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            preparedStatement.setString(2, "CSE-B");
            preparedStatement.setInt(3, currentPeriod);

            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                existingOTP = resultSet.getString("OTP");
            }

            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return existingOTP;
    }
}
