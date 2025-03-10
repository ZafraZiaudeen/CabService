<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verification Successful</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
            font-family: Arial, sans-serif;
            margin: 0;
        }
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
        }
        .success-box {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }
        .success-title {
            color: #000;
            font-size: 24px;
            margin-bottom: 15px;
        }
        .success-message {
            color: #666;
            margin-bottom: 20px;
            font-size: 16px;
            line-height: 1.5;
        }
        .close-button {
            display: inline-block;
            padding: 10px 30px;
            background-color: #000;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        .close-button:hover {
            background-color: #333;
        }
    </style>
</head>
<body>
    <main class="container">
        <div class="success-box">
            <h2 class="success-title">Email Verified</h2>
            <p class="success-message">
                <% 
                    String verificationMessage = (String) request.getAttribute("verificationMessage");
                    if (verificationMessage != null) {
                        out.print(verificationMessage);
                    } else {
                        out.print("Your email address has been verified. You may now close this window.");
                    }
                %>
            </p>
            <button class="close-button" onclick="window.close()">Close Window</button>
            <p><a href="<%= request.getContextPath() %>/user?action=login">Proceed to Login</a></p>
        </div>
    </main>
</body>
</html>
