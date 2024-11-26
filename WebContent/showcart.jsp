<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }
        h1 {
            color: #008080;
            text-align: left;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #ffffff;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #008080;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .total-row {
            font-weight: bold;
            background-color: #f2f2f2;
        }
        .footer-links {
            text-align: center;
            margin-top: 20px;
        }
        .footer-links a {
            color: #008080;
            text-decoration: none;
            font-size: 16px;
        }
        .footer-links a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: #ff0000;
            text-align: left;
        }
    </style>
</head>
<body>

<%
    // Remove duplicate variable declaration of session, just use the one available in JSP
    if (session == null || session.getAttribute("authenticatedUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userId = session.getAttribute("authenticatedUser").toString();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Load the SQL Server JDBC driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // Establish a connection to the SQL Server database
        conn = DriverManager.getConnection("jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=testuser", "sa", "304#sa#pw");

        // Prepare and execute the SQL query to fetch cart items
        String sql = "SELECT p.ProductID, p.Name, p.Price, c.Quantity FROM Cart c JOIN Products p ON c.ProductID = p.ProductID WHERE c.UserID = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, userId);
        rs = ps.executeQuery();

        // Display the cart details
        out.println("<h1>Your Shopping Cart</h1>");
        out.println("<table><tr><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

        double total = 0;
        while (rs.next()) {
            String productName = rs.getString("Name");
            double price = rs.getDouble("Price");
            int quantity = rs.getInt("Quantity");
            double subtotal = price * quantity;

            out.println("<tr>");
            out.println("<td>" + productName + "</td>");
            out.println("<td>" + quantity + "</td>");
            out.println("<td>" + price + "</td>");
            out.println("<td>" + subtotal + "</td>");
            out.println("</tr>");

            total += subtotal;
        }
        out.println("<tr class='total-row'><td colspan='3'>Total</td><td>" + total + "</td></tr>");
        out.println("</table>");

    } catch (ClassNotFoundException e) {
        out.println("<p class='error-message'>Error: JDBC Driver not found - " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p class='error-message'>Error: Database connection issue - " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p class='error-message'>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>

</body>
</html>
