<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    String adminUsername = request.getParameter("adminUsername");
    String adminPassword = request.getParameter("adminPassword");

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isValid = false;

    try {
        // 连接数据库，使用您现有的数据库连接设置
        con = DriverManager.getConnection("jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True", "sa", "304#sa#pw");
        
        // 准备语句来查询 admin 表
        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, adminUsername);
        pstmt.setString(2, adminPassword);
        rs = pstmt.executeQuery();

        // 检查凭证是否匹配
        if (rs.next()) {
            isValid = true;
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }

    if (isValid) {
        // 设置 session 属性以指示登录成功
        session.setAttribute("authenticatedAdmin", adminUsername);
        response.sendRedirect("admin.jsp"); // 如果登录成功，重定向到 admin.jsp 页面
    } else {
        // 如果登录失败，设置错误消息并重定向回登录页面
        session.setAttribute("loginError", "用户名或密码无效，请重试。");
        response.sendRedirect("adminLogin.jsp"); // 如果登录失败，重定向回登录页面
    }
%>
