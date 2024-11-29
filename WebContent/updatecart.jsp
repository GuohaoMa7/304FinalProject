<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cart</title>
</head>
<body>

<%
    HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("authenticatedUser") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String userId = session.getAttribute("authenticatedUser").toString();
Connection conn = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "username", "password");

    // 更新数量
    for (String key : request.getParameterMap().keySet()) {
        if (key.startsWith("quantity_")) {
            String productId = key.substring(9);
            int quantity = Integer.parseInt(request.getParameter(key));
            if (quantity < 1) quantity = 1;

            String sqlUpdate = "UPDATE Cart SET Quantity = ? WHERE UserID = ? AND ProductID = ?";
            ps = conn.prepareStatement(sqlUpdate);
            ps.setInt(1, quantity);
            ps.setString(2, userId);
            ps.setString(3, productId);
            ps.executeUpdate();
        }
    }

    // 删除产品
    String removeProductId = request.getParameter("remove");
    if (removeProductId != null) {
        String sqlDelete = "DELETE FROM Cart WHERE UserID = ? AND ProductID = ?";
        ps = conn.prepareStatement(sqlDelete);
        ps.setString(1, userId);
        ps.setString(2, removeProductId);
        ps.executeUpdate();
    }

} catch (Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    if (ps != null) ps.close();
    if (conn != null) conn.close();
}

response.sendRedirect("showcart.jsp");
%>

</body>
</html>
