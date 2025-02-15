<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mega City Cab - Welcome</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
            font-family: Arial, sans-serif;
        }
        .card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 450px;
            width: 100%;
            height: 400px;
        }
        h2 {
            margin-bottom: 30px;
        }
        p {
            color: #555;
            margin-bottom: 50px;
        }
        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            color: white;
        }
        .btn-admin {
            background-color: #007bff;
        }
        .btn-admin:hover {
            background-color: #0056b3;
        }
        .btn-customer {
            background-color: #28a745;
        }
        .btn-customer:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Welcome to Mega City Cab</h2>
        <p>Mega City Cab is a leading cab service in Colombo, serving thousands of customers monthly.</p>
        <p>Please choose your login option:</p>
        <button class="btn btn-admin" onclick="location.href='adminLogin.jsp'">Login as Admin</button>
        <button class="btn btn-customer" onclick="location.href='user?action=login'">Login as Customer</button>
    </div>
</body>
</html>
