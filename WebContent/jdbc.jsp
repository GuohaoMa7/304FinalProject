<%@ page import="java.sql.*"%>

<%!
    // User id, password, and server information
    private String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    private String uid = "sa";
    private String pw = "304#sa#pw";

    // Do not modify this url
    private String urlForLoadData = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";

    /**
     * Method to get a new database connection.
     * @return A new SQL Server Connection.
     * @throws SQLException If there is an error getting the connection.
     */
    public Connection getConnection() throws SQLException {
        try {
            // Load driver class
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("ClassNotFoundException: " + e.getMessage(), e);
        }

        // Return a new connection
        return DriverManager.getConnection(url, uid, pw);
    }

    /**
     * Method to close a given connection.
     * @param con The Connection object to close.
     */
    public void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            // Log the exception if needed, but ignore the error in JSP context
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
%>
