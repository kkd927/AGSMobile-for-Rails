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
	'���� ���� ������ ������� ��� ������ �������Դϴ�. (������ ����ϼ̽��ϴ�)
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
���� ���� ��� �ϼ̽��ϴ�.
</body> 
</html>