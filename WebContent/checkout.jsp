<html>
<head>
<title>Ray's Grocery</title>
</head>
<body>

<h1>Enter your details to complete the transaction:</h1>

<form method="post" action="processOrder.jsp">
    <table>
        <tr><td>Customer ID:</td><td><input type="text" name="customerId" size="20"></td></tr>
        <tr><td>Password:</td><td><input type="password" name="password" size="20"></td></tr>
        <tr><td>Credit Card Number:</td><td><input type="text" name="creditCard" size="20"></td></tr>
        <tr><td>Expiry Date:</td><td><input type="text" name="expiryDate" size="10"></td></tr>
        <tr><td>Ship to Address:</td><td><input type="text" name="shiptoAddress" size="50"></td></tr>
        <tr><td>Ship to City:</td><td><input type="text" name="shiptoCity" size="20"></td></tr>
        <tr><td>Ship to State:</td><td><input type="text" name="shiptoState" size="20"></td></tr>
        <tr><td>Ship to Postal Code:</td><td><input type="text" name="shiptoPostalCode" size="10"></td></tr>
        <tr><td>Ship to Country:</td><td><input type="text" name="shiptoCountry" size="20"></td></tr>
        <tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
    </table>
</form>

</body>
</html>
