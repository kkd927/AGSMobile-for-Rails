<%@  codepage="949" language="VBScript" %>
<%
    
    Session.codepage="949"
    Response.CharSet  = "euc-kr"
    Response.CodePage="949"
    Response.AddHeader "Pragma","no-cache"
    Response.AddHeader "cache-control", "no-staff"
    Response.ContentType="text/html;charset=euc-kr"
    Response.Expires  = -1
%>

<% 
	'승인 도중 유저가 취소했을 경우 보여줄 페이지입니다. (결제를 취소하셨습니다)
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
결제 도중 취소 하셨습니다.
</body> 
</html>