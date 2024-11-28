<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery Main Page</title>
    <style>
        body {
            background-color: #BFEFFF;
            font-family: Arial, sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
            overflow: hidden; /* 防止页面滚动 */
        }

        h1 {
            color: #0077b3;
            text-align: center;
            margin-top: 20px;
        }

        h2 {
            text-align: center;
            margin: 10px 0;
        }

        a {
            text-decoration: none;
            color: #0077b3;
            font-weight: bold;
        }

        a:hover {
            color: #004d66;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ccc;
        }

        th {
            background-color: #0077b3;
            color: white;
        }

        td {
            background-color: #f1f1f1;
        }

        tr:nth-child(even) td {
            background-color: #e6f7ff;
        }

        .container {
            width: 90%;
            margin: 0 auto;
            text-align: center;
        }

        .section-title {
            color: #004d66;
            margin-bottom: 15px;
        }

        .button-link {
            background-color: #0077b3;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
        }

        .button-link:hover {
            background-color: #004d66;
        }

        .login-logout-button {
            background-color: #ff6f61;  
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin: 10px;
        }

        .login-logout-button:hover {
            background-color: #e65c54; 
        }

        .message {
            color: red;
            font-size: 1.1em;
        }

        .bottom-image {
            width: 100%;
            margin-top: 20px;
        }

        #floatingIcon {
            width: 40px; /* 图标宽度 */
            height: 50px; /* 图标高度 */
            position: absolute;
            top: 50px;
            left: 50px;
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const icon = document.getElementById("floatingIcon");
            let x = 50;
            let y = 50;
            let dx = 0.6;
            let dy = 0.6;

            function moveIcon() {
                const width = window.innerWidth - icon.width;
                const height = window.innerHeight - icon.height;

                x += dx;
                y += dy;

                // 碰到边界时反弹
                if (x <= 0 || x >= width) {
                    dx = -dx;
                }
                if (y <= 0 || y >= height) {
                    dy = -dy;
                }

                icon.style.left = x + 'px';
                icon.style.top = y + 'px';

                requestAnimationFrame(moveIcon);
            }

            moveIcon();
        });
    </script>
</head>
<body>

<h1>Welcome to doujiao's Grocery</h1>

<div class="container">
    <h2><a href="login.jsp" class="login-logout-button">Login</a></h2>

    <% 
        // 检查用户是否已登录
        String userName = (String) session.getAttribute("authenticatedUser");

        if (userName == null) {
            // 用户未登录，显示“创建账户”按钮
    %>
            <h2><a href="createAcc.jsp" class="button-link">Create Account</a></h2>
    <%
        } else {
            // 用户已登录，显示欢迎信息
            out.println("<h3>Welcome, " + userName + "!</h3>");
        }
    %>

    <h2><a href="listprod.jsp" class="button-link">Begin Shopping</a></h2>
    <h2><a href="listorder.jsp" class="button-link">List All Orders</a></h2>
    <h2><a href="customer.jsp" class="button-link">Customer Info</a></h2>
    <h2><a href="admin.jsp" class="button-link">Administrators</a></h2>
    <h2><a href="logout.jsp" class="login-logout-button">Log out</a></h2>
</div>

<img id="floatingIcon" src="img/mixi.png" alt="Flying Icon">

<%
    // Retrieve the logged-in user's name and customerId from the session
    Integer customerId = (Integer) session.getAttribute("customerId");

    // Check if user is logged in
    if (userName != null) {
        out.println("<h3 align='center'>Signed in as: " + userName + "</h3>");
    } else {
        out.println("<p align='center'>Please log in to see personalized recommendations.</p>");
    }

    // Database connection
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rst = null;

    try {
        // Database connection details
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
        String uid = "sa";
        String pw = "304#sa#pw";
        
        // Load the SQL Server JDBC driver and establish connection
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        con = DriverManager.getConnection(url, uid, pw);

        // Fetch top 10 best-selling products
        String sql = "SELECT TOP 10 p.productId, p.productName, p.productPrice, SUM(op.quantity) AS totalSales " +
                     "FROM product p " +
                     "JOIN orderproduct op ON p.productId = op.productId " +
                     "GROUP BY p.productId, p.productName, p.productPrice " +
                     "ORDER BY totalSales DESC";
        pstmt = con.prepareStatement(sql);
        rst = pstmt.executeQuery();

        // Display top 10 products
        out.println("<h3 align='center'>Top 10 Best-Selling Products:</h3>");
        out.println("<table align='center' border='1'>");
        out.println("<tr><th>Product Name</th><th>Price</th><th>Total Sales</th><th>View Details</th></tr>");

        while (rst.next()) {
            int productId = rst.getInt("productId");
            String productName = rst.getString("productName");
            double productPrice = rst.getDouble("productPrice");
            int totalSales = rst.getInt("totalSales");

            out.println("<tr>");
            out.println("<td>" + productName + "</td>");
            out.println("<td>$" + productPrice + "</td>");
            out.println("<td>" + totalSales + "</td>");
            out.println("<td><a href='product.jsp?id=" + productId + "'>View</a></td>");
            out.println("</tr>");
        }
        out.println("</table>");

        // Personalized recommendations based on customerId
        if (customerId != null) {
            out.println("<h3 align='center'>Recommended Products for You:</h3>");

            // Query to get recommended products based on previous purchases
            String recommendationsQuery = 
                "SELECT TOP 2 p.productId, p.productName, p.productPrice " +
                "FROM orderproduct op1 " +
                "JOIN orderproduct op2 ON op1.orderId = op2.orderId AND op1.productId != op2.productId " +
                "JOIN product p ON op2.productId = p.productId " +
                "JOIN ordersummary os ON op1.orderId = os.orderId " +
                "WHERE os.customerId = ? " +
                "GROUP BY p.productId, p.productName, p.productPrice " +
                "ORDER BY COUNT(*) DESC";
            
            pstmt = con.prepareStatement(recommendationsQuery);
            pstmt.setInt(1, customerId);
            rst = pstmt.executeQuery();

            if (rst.next()) {
                out.println("<table align='center' border='1'>");
                out.println("<tr><th>Product Name</th><th>Price</th><th>View Details</th></tr>");

                // Display recommendations
                do {
                    int productId = rst.getInt("productId");
                    String productName = rst.getString("productName");
                    double productPrice = rst.getDouble("productPrice");

                    out.println("<tr>");
                    out.println("<td>" + productName + "</td>");
                    out.println("<td>$" + productPrice + "</td>");
                    out.println("<td><a href='product.jsp?id=" + productId + "'>View</a></td>");
                    out.println("</tr>");
                } while (rst.next());

                out.println("</table>");
            } else {
                out.println("<p align='center'>No personalized recommendations available. Purchase some products to get recommendations.</p>");
            }
        } else {
            out.println("<p align='center'>Log in to see personalized recommendations.</p>");
        }

    } catch (SQLException | ClassNotFoundException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rst != null) rst.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>

<img src="https://wx4.sinaimg.cn/orj480/007846BMgy1hucrdjtb16j30zk0k0wj3.jpg" alt="Grocery Image" class="bottom-image">

</body>
</html>
