<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
    String authenticatedUser = null;

    try {
        // Use the session object directly as it is already available in JSP.
        out.println("Starting login validation...<br/>");
        authenticatedUser = validateLogin(out, request);
    } catch (IOException e) {
        System.err.println(e);
    }

    if (authenticatedUser != null) {
        out.println("Login successful, redirecting to home.jsp...<br/>");
        response.sendRedirect("home.jsp"); // Successful login - redirect to home page
    } else {
        out.println("Login failed, redirecting to login.jsp...<br/>");
        response.sendRedirect("login.jsp"); // Failed login - redirect back to login page
    }
%>

<%!
    // Method to validate login credentials
    String validateLogin(JspWriter out, HttpServletRequest request) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        // Validate the provided credentials
        if (username == null || password == null) {
            out.println("Username or password is null.<br/>");
            return null;
        }
        if (username.length() == 0 || password.length() == 0) {
            out.println("Username or password is empty.<br/>");
            return null;
        }

        Connection con = null; // Declare connection here

        try {
            out.println("Attempting to connect to the database...<br/>");
            con = getConnection(); // Get the connection from jdbc.jsp
            out.println("Database connection established.<br/>");

            // SQL query to validate user credentials
            String SQL = "SELECT customerId FROM customer WHERE userid=? AND password=?";
            PreparedStatement pstmt = con.prepareStatement(SQL);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            out.println("Executing SQL query...<br/>"); // Log output
            ResultSet rs = pstmt.executeQuery();

            // Check if a matching user exists
            if (rs.next()) {
                retStr = rs.getString("customerId"); // If user exists, set retStr to customerId
                out.println("User found: " + retStr + "<br/>");
            } else {
                out.println("No matching user found.<br/>");
            }
            rs.close();
            pstmt.close();
        } catch (SQLException ex) {
            out.println("<h4>Error: " + ex.getMessage() + "</h4>");
        } finally {
            if (con != null) {
                closeConnection(con); // Close the connection
                out.println("Database connection closed.<br/>");
            }
        }

        // Update session with appropriate messages
        HttpSession session = request.getSession(); // Get the session
        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", retStr); // Store customerId instead of username
        } else {
            session.setAttribute("loginMessage", "Could not connect to the system using that username/password.");
        }

        return retStr;
    }
%>
