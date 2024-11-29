<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
</head>
<body>

<%
// 检查用户是否已登录
String authenticatedUser = (String) session.getAttribute("authenticatedUser");
if (authenticatedUser == null) {
    // 如果用户未登录，则重定向到登录页面
    response.sendRedirect("login.jsp");
    return;
}

// 获取当前购物车中的商品列表
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null) {
    out.println("<h1>Your shopping cart is empty!</h1>");
    productList = new HashMap<String, ArrayList<Object>>();
} else {
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h1>Your Shopping Cart</h1>");
    out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
    out.println("<th>Price</th><th>Subtotal</th></tr>");

    double total = 0;
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        if (product.size() < 4) {
            out.println("<p>Expected product with four entries. Got: " + product + "</p>");
            continue;
        }

        out.print("<tr><td>" + product.get(0) + "</td>");
        out.print("<td>" + product.get(1) + "</td>");

        out.print("<td align=\"center\">" + product.get(3) + "</td>");
        Object price = product.get(2);
        Object itemQty = product.get(3);
        double pr = 0;
        int qty = 0;

        try {
            pr = Double.parseDouble(price.toString());
        } catch (Exception e) {
            out.println("<p>Invalid price for product: " + product.get(0) + " price: " + price + "</p>");
            continue;
        }
        try {
            qty = Integer.parseInt(itemQty.toString());
        } catch (Exception e) {
            out.println("<p>Invalid quantity for product: " + product.get(0) + " quantity: " + itemQty + "</p>");
            continue;
        }

        out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
        out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td></tr>");
        total += pr * qty;
    }
    out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
            + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
    out.println("</table>");

    out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html>
