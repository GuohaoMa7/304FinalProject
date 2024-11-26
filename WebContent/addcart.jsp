<%@ page import="java.sql.*" %>
<%
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("authenticatedUser") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String userId = session.getAttribute("authenticatedUser").toString();
String productId = request.getParameter("id");
String quantityStr = request.getParameter("quantity");
int quantity = (quantityStr == null) ? 1 : Integer.parseInt(quantityStr);

// 数据库连接
Connection conn = null;
PreparedStatement ps = null;
try {
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "username", "password");

    // 检查是否已有该产品的购物车记录
    String sqlCheck = "SELECT Quantity FROM Cart WHERE UserID = ? AND ProductID = ?";
    ps = conn.prepareStatement(sqlCheck);
    ps.setString(1, userId);
    ps.setString(2, productId);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        // 更新数量
        int existingQuantity = rs.getInt("Quantity");
        String sqlUpdate = "UPDATE Cart SET Quantity = ? WHERE UserID = ? AND ProductID = ?";
        ps = conn.prepareStatement(sqlUpdate);
        ps.setInt(1, existingQuantity + quantity);
        ps.setString(2, userId);
        ps.setString(3, productId);
        ps.executeUpdate();
    } else {
        // 新增记录
        String sqlInsert = "INSERT INTO Cart (UserID, ProductID, Quantity) VALUES (?, ?, ?)";
        ps = conn.prepareStatement(sqlInsert);
        ps.setString(1, userId);
        ps.setString(2, productId);
        ps.setInt(3, quantity);
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
