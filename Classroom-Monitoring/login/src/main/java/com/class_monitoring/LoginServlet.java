package com.class_monitoring;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            PrintWriter out = response.getWriter();
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance", "root",
                    "Qwerty@101918");
            String n = request.getParameter("txtName");
            String p = request.getParameter("txtPwd");
            RequestDispatcher dispatcher = null;
            PreparedStatement ps;
            if(n.charAt(0) == 'T')
            	ps = con.prepareStatement("select TID from teacherinfo where TID=? and TPASSWORD=?");
            else if(n.charAt(0) == 'H')
            	ps = con.prepareStatement("select HID from HODINFO where HID = ? and HPASSWORD = ?");
            else
            	 ps = con.prepareStatement("select username from student where username=? and password=?");
            
            ps.setString(1, n);
            ps.setString(2, p);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Store username in session
                
            	if(n.charAt(0) == 'T') {
                	HttpSession session = request.getSession();
                    session.setAttribute("TID", n);
                    dispatcher = request.getRequestDispatcher("TeacherTimeTable.jsp");
                }
                else if(n.charAt(0) == 'H') {
                    PreparedStatement td = con.prepareStatement("SELECT TID FROM HODINFO WHERE HID = ?");
                    td.setString(1, n);
                    
                    ResultSet hs = td.executeQuery();
                    
                    if (hs.next()) {
                        String TID = hs.getString("TID");
                        
                        // Set TID as a session attribute
                        HttpSession session = request.getSession();
                        session.setAttribute("TID", TID);
                        dispatcher = request.getRequestDispatcher("hod.jsp");
                    }
                    
                    // Close the result set and prepared statement
                    hs.close();
                    td.close();
                }
                // Redirect to the option.jsp if login successful
                else {
                	HttpSession session = request.getSession();
                    session.setAttribute("username", n);
                	dispatcher = request.getRequestDispatcher("option.jsp");
                }
            } else {
            	// No need to print error message here
                // Display error message using JavaScript on the same login.jsp page
                response.setContentType("text/html");
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Username or Password is incorrect!');");
                out.println("window.location.href='login.jsp';");
                out.println("</script>");
            }
            dispatcher.forward(request, response);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

}
