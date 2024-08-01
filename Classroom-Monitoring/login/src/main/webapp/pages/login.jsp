<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link rel="stylesheet" href="css/loginstyle.css"> 
    
    
    
</head>
<body>
    <div class="main">
        <form action="LoginServlet" method="post"> <!-- Changed action to point to LoginServlet -->
            <h1>LOGIN</h1>
            <div class="input-box">
                <input type="text" placeholder="Username" name=txtName required> <!-- Added name attribute -->
            </div>
            <div class="input-box">
                <input type="password" placeholder="Password" name=txtPwd required> <!-- Added name attribute -->
            </div>

            <button type="submit" class="btn" draggable="true">Submit</button>
        </form>
    </div>
</body>
</html>