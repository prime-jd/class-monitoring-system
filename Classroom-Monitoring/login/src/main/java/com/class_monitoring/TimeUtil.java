package com.class_monitoring;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.Random;

public class TimeUtil {
    public static int getCurrentPeriod() {
        LocalTime currentTime = LocalTime.now();
        int currentPeriod = 0;

        // Define time slots for each period
        LocalTime[] timeSlots = {
            LocalTime.of(00, 30),   // Period 1
            LocalTime.of(10, 21),  // Period 2
            LocalTime.of(11, 11),   // Period 3
            LocalTime.of(12, 51),  // Period 4
            LocalTime.of(14, 31),  // Period 5
            LocalTime.of(15, 21),  // Period 6
            LocalTime.of(16, 10)   // Period 7 (last period starts at 4:11 PM)
        };

        // Determine the current period
        for (int i = 0; i < timeSlots.length; i++) {
            if (currentTime.compareTo(timeSlots[i]) >= 0) {
                currentPeriod = i + 1; // Periods are 1-indexed
            } else {
                break; // Break out of the loop once the current period is found
            }
        }

        return currentPeriod;
    }
    
    public static boolean isCurrentTimeInRange(LocalTime startTime, LocalTime endTime) {
        LocalTime currentTime = LocalTime.now();
        
        // Check if the current time is within the specified range
        return !currentTime.isBefore(startTime) && (endTime == null || !currentTime.isAfter(endTime));
    }
    
    public static boolean isCurrentDay(DayOfWeek day) {
        DayOfWeek currentDay = LocalDate.now().getDayOfWeek();
        
        // Check if the current day matches the desired day
        return currentDay.equals(day);
    }
    
    public static String generateOTP() {
        // Generate a 4-digit OTP
        Random random = new Random();
        int otp = 1000 + random.nextInt(9000);
        return String.valueOf(otp);
    }


}
