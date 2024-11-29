<%@ page language="java" import="java.io.*, java.sql.*, javax.servlet.http.*" %>
<%@ include file="jdbc.jsp" %>
<%
    String authenticatedUser = null;

    try {
        authenticatedUser = validateLogin(out, request);
    } catch (IOException e) {
        System.err.println(e);
        out.println("<h4>Error during login validation: " + e.getMessage() + "</h4>");
    }

    if (authenticatedUser != null) {
        // 登录成功 - 重定向到主页
        response.sendRedirect("index.jsp");
    } else {
        // 登录失败 - 重定向回登录页
        response.sendRedirect("login.jsp");
    }
%>

<%!
    // 用于验证登录凭证的方法
    String validateLogin(JspWriter out, HttpServletRequest request) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        if (username == null || password == null) {
            return null;
        }
        if (username.length() == 0 || password.length() == 0) {
            return null;
        }

        Connection con = null;

        try {
            con = getConnection(); // 从 jdbc.jsp 获取数据库连接
            con.setNetworkTimeout(null, 5000);

            String SQL = "SELECT customerId FROM customer WHERE userid=? AND password=?";
            PreparedStatement pstmt = con.prepareStatement(SQL);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                retStr = rs.getString("customerId"); // 找到用户
            }
            rs.close();
            pstmt.close();
        } catch (SQLException ex) {
            out.println("<h4>Error: " + ex.getMessage() + "</h4>");
        } finally {
            if (con != null) {
                try {
                    closeConnection(con);
                } catch (Exception e) {
                    out.println("<h4>Error closing connection: " + e.getMessage() + "</h4>");
                }
            }
        }

        HttpSession session = request.getSession(); // 获取会话
        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", retStr); // 存储 customerId
        } else {
            session.setAttribute("loginMessage", "Could not connect to the system using that username/password.");
        }

        return retStr;
    }
%>
