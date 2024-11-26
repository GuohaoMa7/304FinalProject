<%
    HttpSession session = request.getSession(false); // Get the current session, if it exists
    if (session != null) {
        out.println("Invalidating session...<br/>"); // 日志输出
        session.invalidate(); // Properly invalidate the session
        out.println("Session invalidated successfully.<br/>"); // 日志输出
    }
    response.sendRedirect("index.jsp"); // Redirect to main page
%>
