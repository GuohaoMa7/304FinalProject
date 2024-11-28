<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // 获取表单中的输入数据
    String fname = request.getParameter("fname");
    String lname = request.getParameter("lname");
    String email = request.getParameter("email");
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");
    String phonenum = request.getParameter("phonenum");
    String streetAddress = request.getParameter("streetAddress");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalcode = request.getParameter("postalcode");
    String country = request.getParameter("country");

    // 数据库连接信息
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection con = null;
    PreparedStatement pstmt = null;

    try {
        // 加载SQL Server JDBC驱动程序并建立连接
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        con = DriverManager.getConnection(url, uid, pw);

        // 准备SQL语句以将数据插入到customer表中
        String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, fname);
        pstmt.setString(2, lname);
        pstmt.setString(3, email);
        pstmt.setString(4, phonenum);
        pstmt.setString(5, streetAddress);
        pstmt.setString(6, city);
        pstmt.setString(7, state);
        pstmt.setString(8, postalcode);
        pstmt.setString(9, country);
        pstmt.setString(10, userId);
        pstmt.setString(11, password);

        // 执行SQL语句
        int rows = pstmt.executeUpdate();
        
        if (rows > 0) {
            out.println("<h2>Account created successfully!</h2>");
            out.println("<p><a href='login.jsp'>Click here to login</a></p>");
        } else {
            out.println("<h2>Failed to create account. Please try again later.</h2>");
        }
    } catch (SQLException | ClassNotFoundException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>
