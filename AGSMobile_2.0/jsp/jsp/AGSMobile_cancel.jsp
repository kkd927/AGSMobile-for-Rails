<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="kr.co.allthegate.mobile.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Insert title here</title>
</head>
<%

	///////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// �ô�����Ʈ ����� ī�� ������� ������
	//
	///////////////////////////////////////////////////////////////////////////////////////////////////

	String tracking_id = request.getParameter("tracking_id");
	String transaction = request.getParameter("transaction");
	String SendNo = request.getParameter("SendNo");
	String AdmNo = request.getParameter("AdmNo");
	String AdmDt = request.getParameter("AdmDt");
	String store_id = request.getParameter("StoreId");
	String Store_OrdNo = request.getParameter("Store_OrdNo");
	String log_path = "e:/logs";			// �� ������ �α� Path�� �����ϸ� �˴ϴ�.

	if( Cancel_Check(Store_OrdNo) == true ){
	
		AGSMobile mobile = new AGSMobile(store_id, tracking_id, transaction, log_path);
		HashMap<String, Object> ret = new HashMap<String, Object>();
		mobile.setLogging(true);	//true : �αױ��, false : �αױ�Ͼ���.
		
		ret = mobile.cancel(AdmNo, AdmDt, SendNo, "");
		JSONObject data = ((JSONObject)ret.get("data"));
	%>
	<body>
		
	<%
		if(ret.get("status").equals("ok")){	// ���μ���
	%> 	
		
		<!-- ������ �Ʒ����� ó���ϼ��� -->
		��üID : <%= data.get("StoreId") %><br/>
		���ι�ȣ : <%= data.get("AdmNo") %><br/>
		���νð� : <%= data.get("AdmTime") %>��<br/>
		�ڵ� : <%= data.get("Code") %><br/>


	<%
		}else{	// ���ν���
	%>

		���ν��� : <%=ret.get("message") %>	<!-- ���� �޼��� -->
		
	<%
		}
	}else{
	%>
		���ν��� : ��� ���ŷ����� ã�� ���߽��ϴ�. 	<!-- ��ҿ�û���� ���� �������� �ƴ� ��� ó�� -->
	<%
	}
%>
 
 </body>	
</html>

<%!
	public String Cancel_Check(String Store_OrdNo)
	{
		boolean flag = false;

		/***********************************************************************************
		*���⼭ ������ ���ŷ� ������ �����ɴϴ�.
		*��ҿ�û ���� ���ŷ��� ������ ���ŷ� ������ �����ϰ�
		*��Ұ� ������ �����̸� True, �ƴϸ� False 
		*���ŷ� üũ������ ������ �˸°� �߰�/�����ϼ���     
		************************************************************************************/

	/*	Dim Order			//ex. ���� ���ŷ�����
		
		if( Store_OrdNo == Order ) {
		   flag = true;
		}else{
		   flag = false;
		}
	*/

		return flag;
	}
%>