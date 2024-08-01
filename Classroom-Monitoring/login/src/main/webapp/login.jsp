<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <style type="text/css">
            * {
            margin:0;
            padding:0;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background:rgba(255, 165, 0, 0.5);;
            font-size: 2rem;
        }

        .main {
            display: flex;
            width:500px;
            height:400px;
            background: brown;
            align-items: center;
            justify-content: center;
            border-radius: 50% 20% / 10% 40%;
        }

        h1 {
            font-family: "Young Serif", serif;
            font-weight: 400;
            font-style: normal;
            color: orange;
            font-size: 45px;
            text-align: center;
        }

        input {
            height:40px;
            margin:10px;
            width:250px;
            border-radius:  10% 40% / 50% 20% ;
            border-color:#EEE7DA;
            text-align: center;
            font-family: Georgia, 'Times New Roman', Times, serif;
            font-size: 20px;
        }

        .btn {
            font-family: "Martian Mono", monospace;
            font-optical-sizing: auto;
            font-weight: 600;
            background-color: orange;
            font-style: "normal";
            font-variation-settings:"wdth" 100;
            color: white;
            font-weight: "bold";
            margin-left: 120px;
            height:30px;
            width:70px;
            border-radius: 15%;
        }
    </style> 
    
    
    
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