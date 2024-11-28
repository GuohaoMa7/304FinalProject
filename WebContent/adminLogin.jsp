<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }

        form {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        form label {
            font-weight: bold;
            margin-top: 10px;
        }

        form input {
            padding: 8px;
            margin: 5px 0 15px;
            width: calc(100% - 20px);
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        form input[type="submit"] {
            width: auto;
            background-color: #0077b3;
            color: white;
            border: none;
            cursor: pointer;
            padding: 10px 20px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        form input[type="submit"]:hover {
            background-color: #005f5f;
        }

        .message {
            color: red;
        }
    </style>
</head>
<body>
    <h1>Administrator Login</h1>
    <form method="post" action="adminLoginProcess.jsp">
        <label for="adminUsername">Username: </label>
        <input type="text" id="adminUsername" name="adminUsername" placeholder="Admin Username" required><br>

        <label for="adminPassword">Password: </label>
        <input type="password" id="adminPassword" name="adminPassword" placeholder="Admin Password" required><br>

        <input type="submit" value="Login">
    </form>

    <% 
    // Display login error message if set in the session
    String loginError = (String) session.getAttribute("loginError");
    if (loginError != null) {
        out.println("<p class='message'>" + loginError + "</p>");
        session.removeAttribute("loginError");
    }
    %>
</body>
</html>
