<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale" %>
<%@ include file="auth.jsp" %>  
<%@ include file="jdbc.jsp" %>  
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Portal</title>
    <style>
        body {
            display: flex;
            flex-flow: column;
            align-items: center;
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }

        table, tr, th, td {
            border: 1px solid black;
        }   
    
        td {
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
            text-align: center;
        }
    </style>
</head>
<body>
    <% 
    // 检查管理员是否已登录，并在未登录时重定向
    String adminName = (String) session.getAttribute("authenticatedAdmin");
    if (adminName == null) {
        if (!response.isCommitted()) {
            response.sendRedirect("adminLogin.jsp"); // 未登录管理员将被重定向到 adminLogin.jsp
        }
        return;
    }
    %>
    <header>
        <nav>
            <ul>
                <li><a href='#'><%= adminName %></a></li>
                <li><a href='logout.jsp'>Sign Out</a></li>
            </ul>
        </nav>
    </header>

    <h1>Administrator Portal</h1>
    <a href="index.jsp">Return to main page</a>
    
    <h3>Administrator Sales Report by Day</h3>
    <div>
        <% 
        // SQL 查询显示每日销售报告
        try (Connection con = getConnection();
             Statement stmt = con.createStatement();
             ResultSet rst = stmt.executeQuery(
                "SELECT YEAR(orderDate) AS Year, " +
                "MONTH(orderDate) AS Month, " +
                "DAY(orderDate) AS Day, " +
                "SUM(totalAmount) AS Total " +
                "FROM ordersummary " +
                "GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate) " +
                "ORDER BY Year, Month, Day"
             )) {

            out.println("<table border='1'>");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

            while (rst.next()) {
                String date = rst.getInt("Year") + "-" + rst.getInt("Month") + "-" + rst.getInt("Day");
                double totalSales = rst.getDouble("Total");
                out.println("<tr><td>" + date + "</td><td>" + NumberFormat.getCurrencyInstance(Locale.US).format(totalSales) + "</td></tr>");
            }
            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<h4>Error: " + ex.getMessage() + "</h4>");
        }
        %>
    </div>

    <hr width="40%" height="10px" color="black">
    
    <h3>Customer List</h3>
    <div>
        <% 
        // SQL 查询列出所有客户
        try (Connection con = getConnection();
             Statement stmt = con.createStatement();
             ResultSet rst = stmt.executeQuery("SELECT CONCAT(firstName, ' ', lastName) AS customerName, customerId FROM customer")) {

            out.println("<table border='1'><thead><tr><th>Name</th><th>Customer ID</th></tr></thead>");
            while (rst.next()) {
                out.println("<tr><td>" + rst.getString("customerName") + "</td><td>" + rst.getString("customerId") + "</td></tr>");
            }
            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<h4>Error: " + ex.getMessage() + "</h4>");
        }
        %>
    </div>

    <hr width="40%" height="10px" color="black">
    
    <h3>Add a Product</h3>
    <form method="post" action="addProduct.jsp">
        <input type="text" name="productName" placeholder="Product name" size="50" required><br>
        <input type="number" name="productPrice" placeholder="0.00" step="0.01" min="0.00" size="20" required><br>
        <input type="text" name="productDesc" placeholder="Product description" size="50" required><br>
        <input type="text" name="productCategory" placeholder="Product category" size="50" required><br>
        <input type="submit" value="Add Product"><br>
    </form>

    <hr width="40%" height="10px" color="black">

    <h3>Ship Order</h3>
    <form method="post" action="ship.jsp">
        <label for="orderId">Order to ship: </label>
        <input type="text" name="orderId" size="20" required>
        <input type="submit" value="Ship">
    </form>

    <hr width="40%" height="10px" color="black">

    <h3>Add Customer</h3>
    <form method="post" action="addCustomer.jsp">
        <input type="text" name="fname" placeholder="First Name" size="50" required><br>
        <input type="text" name="lname" placeholder="Last Name" size="50" required><br>
        <input type="email" name="email" placeholder="Email" size="30" required><br>
        <input type="tel" name="phonenum" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"  placeholder="123-456-7890" size="30" required><br>
        <input type="text" name="streetAddress" placeholder="Street Address" size="50" required><br>
        <input type="text" name="city" placeholder="City" size="30" required><br>
        <input type="text" name="state" placeholder="State/Province" size="40" required><br>
        <input type="text" name="postalcode" pattern="[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}" placeholder="A1B2C3" required><br>
        <input type="text" name="country" size="50" placeholder="Country" required><br>
        <input type="text" name="userId" size="50" placeholder="Username" required><br>
        <input type="text" name="password" size="50" placeholder="Password" required><br>
        <input type="submit" value="Add Customer">
    </form>

    <hr width="40%" height="10px" color="black">

    <h3>Add Warehouse</h3>
    <form method="post" action="addWarehouse.jsp">
        <label for="whName">Warehouse Name: </label>
        <input type="text" name="whName" size="50" required>
        <input type="submit" value="Add Warehouse">
    </form>
</body>
</html>
