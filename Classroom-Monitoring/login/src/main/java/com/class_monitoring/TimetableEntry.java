package com.class_monitoring;

import java.time.LocalTime;

public class TimetableEntry {
    private String R1;
    private String T1;
    private String SC1;
    
    private String R2;
    private String T2;
    private String SC2;
    
    private String R3;
    private String T3;
    private String SC3;
    
    private String R4;
    private String T4;
    private String SC4;
    
    private String R5;
    private String T5;
    private String SC5;
    
    private String R6;
    private String T6;
    private String SC6;
    
    private String R7;
    private String T7;
    private String SC7;
    // Define getters and setters for other columns
//    1
    public String getR1() {
        return R1;
    }

    public void setR1(String R1) {
        this.R1 = R1;
    }

    public String getT1() {
        return T1;
    }

    public void setT1(String T1) {
        this.T1 = T1;
    }

    public String getSC1() {
        return SC1;
    }

    public void setSC1(String SC1) {
        this.SC1 = SC1;
    }
    // Define getters and setters for other columns
//    2
    public String getR2() {
        return R2;
    }

    public void setR2(String R2) {
        this.R2 = R2;
    }

    public String getT2() {
        return T2;
    }

    public void setT2(String T2) {
        this.T2 = T2;
    }

    public String getSC2() {
        return SC2;
    }

    public void setSC2(String SC2) {
        this.SC2 = SC2;
    }
    
    
// 3
    public String getR3() {
        return R3;
    }

    public void setR3(String R3) {
        this.R3 = R3;
    }

    public String getT3() {
        return T3;
    }

    public void setT3(String T3) {
        this.T3 = T3;
    }

    public String getSC3() {
        return SC3;
    }

    public void setSC3(String SC3) {
        this.SC3 = SC3;
    }
    
//    4
    public String getR4() {
        return R4;
    }

    public void setR4(String R4) {
        this.R4 = R4;
    }

    public String getT4() {
        return T4;
    }

    public void setT4(String T4) {
        this.T4 = T4;
    }

    public String getSC4() {
        return SC4;
    }

    public void setSC4(String SC4) {
        this.SC4 = SC4;
    }
    
//    5
    public String getR5() {
        return R5;
    }

    public void setR5(String R5) {
        this.R5 = R5;
    }

    public String getT5() {
        return T5;
    }

    public void setT5(String T5) {
        this.T5 = T5;
    }

    public String getSC5() {
        return SC5;
    }

    public void setSC5(String SC5) {
        this.SC5 = SC5;
    }
    
    //6
    public String getR6() {
        return R6;
    }

    public void setR6(String R6) {
        this.R6 = R6;
    }

    public String getT6() {
        return T6;
    }

    public void setT6(String T6) {
        this.T6 = T6;
    }

    public String getSC6() {
        return SC6;
    }

    public void setSC6(String SC6) {
        this.SC6 = SC6;
    }
    
    //7
    public String getR7() {
        return R7;
    }

    public void setR7(String R7) {
        this.R7 = R7;
    }

    public String getT7() {
        return T7;
    }

    public void setT7(String T7) {
        this.T7 = T7;
    }

    public String getSC7() {
        return SC7;
    }

    public void setSC7(String SC7) {
        this.SC7 = SC7;
    }
    
 // Define a method to get the room for a specific period
    public String getRoom(int period) {
        switch (period) {
            case 1: return R1;
            case 2: return R2;
            case 3: return R3;
            case 4: return R4;
            case 5: return R5;
            case 6: return R6;
            case 7: return R7;
            default: return null;
        }
    }

    // Define a method to get the faculty for a specific period
    public String getFaculty(int period) {
        switch (period) {
            case 1: return T1;
            case 2: return T2;
            case 3: return T3;
            case 4: return T4;
            case 5: return T5;
            case 6: return T6;
            case 7: return T7;
            default: return null;
        }
    }

    // Define a method to get the subject for a specific period
    public String getSubject(int period) {
        switch (period) {
            case 1: return SC1;
            case 2: return SC2;
            case 3: return SC3;
            case 4: return SC4;
            case 5: return SC5;
            case 6: return SC6;
            case 7: return SC7;
            default: return null;
        }
    }
    
 // Define a method to get the time for a specific period
    public LocalTime getTime(int period) {
        // Implement the logic to get the time for the specific period
        // Example: return LocalTime.of(8, 0) for the first period, LocalTime.of(9, 0) for the second period, and so on
        // This is just a placeholder implementation, you should replace it with your actual logic
        return LocalTime.of(8 + period - 1, 0);
    }
}
