package com.class_monitoring;

import java.util.Random;

public class OTPGenerator {
    public static String generateOTP() {
        // Generate a 4-digit OTP
        Random random = new Random();
        int otp = 1000 + random.nextInt(9000);
        return String.valueOf(otp);
    }
}
