<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="kr.co.allthegate.mobile.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi"/>
<META content=telephone=no name=format-detection>
<title>���� ������ ����</title>
<script type="text/javascript" charset="euc-kr">
	function doPay(form) {
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// �ô�����Ʈ �÷����� �������� �������� �����ϱ� JavaScript �ڵ带 ����ϰ� �ֽ��ϴ�.
		// ���������� �°� JavaScript �ڵ带 �����Ͽ� ����Ͻʽÿ�.
		//
		// [1] �Ϲ�/������ ��������
		// [2] �Ϲݰ����� �Һΰ�����
		// [3] �����ڰ����� �Һΰ����� ����
		// [4] ��������
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// [1] �Ϲ�/������ �������θ� �����մϴ�.
		//
		// �Һ��Ǹ��� ��� �����ڰ� ���ڼ����Ḧ �δ��ϴ� ���� �⺻�Դϴ�. 
		// �׷���, ������ �ô�����Ʈ���� ���� ����� ���ؼ� �Һ����ڸ� ���������� �δ��� �� �ֽ��ϴ�.
		// �� ��� �����ڴ� ������ �Һΰŷ��� �����մϴ�.
		//
		// ����)
		// 	(1) �Ϲݰ����� ����� ���
		// 	form.DeviId.value = "9000400001";
		//
		// 	(2) �����ڰ����� ����� ���
		// 	form.DeviId.value = "9000400002";
		//
		// 	(3) ���� ���� �ݾ��� 100,000�� �̸��� ��� �Ϲ��Һη�, 100,000�� �̻��� ��� �������Һη� ����� ���
		// 	if(parseInt(form.Amt.value) < 100000)
		//		form.DeviId.value = "9000400001";
		// 	else
		//		form.DeviId.value = "9000400002";
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// [2] �Ϲ� �ҺαⰣ�� �����մϴ�.
		// 
		// �Ϲ� �ҺαⰣ�� 2 ~ 12�������� �����մϴ�.
		// 0:�Ͻú�, 2:2����, 3:3����, ... , 12:12����
		// 
		// ����)
		// 	(1) �ҺαⰣ�� �ϽúҸ� �����ϵ��� ����� ���
		// 		form.QuotaInf.value = "0";
		//
		// 	(2) �ҺαⰣ�� �Ͻú� ~ 12�������� ����� ���
		//		form.QuotaInf.value = "0:2:3:4:5:6:7:8:9:10:11:12";
		//
		// 	(3) �����ݾ��� ���������ȿ� ���� ��쿡�� �Һΰ� �����ϰ� �� ���
		// 	if((parseInt(form.Amt.value) >= 100000) || (parseInt(form.Amt.value) <= 200000))
		// 		form.QuotaInf.value = "0:2:3:4:5:6:7:8:9:10:11:12";
		// 	else
		// 		form.QuotaInf.value = "0";
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//�����ݾ��� 5���� �̸����� �Һΰ����� ��û�Ұ�� �Ͻúҷ� ����
		if(parseInt(form.Amt.value) < 50000)
			form.QuotaInf.value = "0";
		else
			form.QuotaInf.value = "0:2:3:4:5:6:7:8:9:10:11:12";
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// [3] ������ �ҺαⰣ�� �����մϴ�.
		// (�Ϲݰ����� ��쿡�� �� ������ ������� �ʽ��ϴ�.)
		// 
		// ������ �ҺαⰣ�� 2 ~ 12�������� �����ϸ�, 
		// �ô�����Ʈ���� ������ �Һ� ������������ �����ؾ� �մϴ�.
		// 
		// 100:BC
		// 200:����
		// 300:��ȯ
		// 400:�Ｚ
		// 500:����
		// 800:����
		// 900:�Ե�
		// 
		// ����)
		// 	(1) ��� �Һΰŷ��� �����ڷ� �ϰ� ���������� ALL�� ����
		//	 	form.NointInf.value = "ALL";
		//
		// 	(2) ����ī�� Ư���������� �����ڸ� �ϰ� ������� ����(2:3:4:5:6����)
		// 		form.NointInf.value = "200-2:3:4:5:6";
		//
		// 	(3) ��ȯī�� Ư���������� �����ڸ� �ϰ� ������� ����(2:3:4:5:6����)
		// 		form.NointInf.value = "300-2:3:4:5:6";
		//
		// 	(4) ����,��ȯī�� Ư���������� �����ڸ� �ϰ� ������� ����(2:3:4:5:6����)
		// 		form.NointInf.value = "200-2:3:4:5:6,300-2:3:4:5:6";
		//	
		//	(5) ������ �ҺαⰣ ������ ���� ���� ��쿡�� NONE�� ����
		//		form.NointInf.value = "NONE";
		//
		//	(6) ��ī��� Ư���������� �����ڸ� �ϰ� �������(2:3:6����)
		//		form.NointInf.value = "100-2:3:6,200-2:3:6,300-2:3:6,400-2:3:6,500-2:3:6";
		//
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		 
		//	��� �Һΰŷ��� ������
		if(form.DeviId.value == "9000400002") {
			form.NointInf.value = "ALL";
		} 
		
		
			
		AllTheGate.pay(document.form);
		return false;
	}

</script>  
<%
	///////////////////////////////////////////////////////
	//
	// �ݾ� �������� ���� ����, 
	// ���� ���� (Amt) �� ��� JavaScript�� ������ �� �����ϴ�.
	// �ݵ�� ServerScript(asp,php,jsp)���� ���������� ������ �� Form�� �Է��Ͽ� �ּ���.
	//
	///////////////////////////////////////////////////////
	
	String amt = "1004";
	String dutyfree = "0"; //�ſ�ī�� ������ �鼼 �ݾ� (amt �� �鼼 �ݾ� ����)
	String store_id = "aegis";
	
	//�ô�����Ʈ 
	String strAegis = "https://www.allthegate.com";
	String strCsrf = "csrf.real.js";
	
	String http_host = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort(); 
%>
<script type="text/javascript" charset="euc-kr" src="<%= strAegis %>/payment/mobilev2/csrf/<%= strCsrf %>"></script> 
</head>  

<body>
<div class="top_div">
	<table>
		<tr>
			<td width="90%">�ô�����Ʈ ������û</td>
			<td>AlltheGate</td>
		</tr>
	</table>
</div>

<form method="post" action="<%= strAegis %>/payment/mobilev2/intro.jsp" name="form" >
<div class="content_div" id="agree_div">
	<table>
		
		<tr>
			<td>�ֹ���ȣ</td>
			<td><input type="text" name="OrdNo" value="1000000001"/></td>
		</tr>
		<tr>
			<td>��ǰ��</td>
			<td><input type="text" name="ProdNm"  value="�౸��"/></td>
		</tr>
		<tr>
			<td>����</td>
			<td><input type="text" name="Amt" value="<%=amt %>"/></td>
		</tr>
		<tr>
			<td>�鼼�ݾ�</td>
			<td><input type="text" name="DutyFree" value="<%=dutyfree%>"/></td>
		</tr>
		<tr>
			<td>�������̸�</td>
			<td><input type="text" name="OrdNm"  value="ȫ�浿"/></td>
		</tr>
		<tr>
			<td>�����̸�</td>
			<td><input type="text" name="StoreNm"  value="�౸����Ʈ"/></td>
		</tr>
		<tr>
			<td>�޴�����ȣ</td>
			<td><input type="text" name="OrdPhone"  value="01011111234"/></td>
		</tr>
		<tr>
			<td>�̸���</td>
			<td><input type="text" name="UserEmail"  value="test@test.com"/></td>
		</tr>
		<tr>
			<td>�������</td>
			<td>
				<select name="Job">
					<option value="">����</option>
					<option value="card">�ſ�ī��</option>
					<option value="cardnormal">�ſ�ī�常</option>
					<option value="cardescrow">�ſ�ī��(����ũ��)</option>
					<option value="virtual">�������</option>
					<option value="virtualnormal">������¸�</option>
					<option value="virtualescrow">�������(����ũ��)</option>
					<option value="hp">�޴���</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>�������̵�</td>
			<td><input type="text" name="StoreId" maxlength=20 value="<%=store_id%>"/></td>
		</tr>
		<tr>
			<td>����URL</td>
			<td><input type="text"  name="MallUrl" value="<%=http_host%>"/></td>
		</tr>
		<tr>
			<td>ȸ�����̵�</td>
			<td><input type="text"  name="UserId" maxlength=20 value="test"></td>
		</tr>
		<tr>
			<td>�ֹ����ּ�</td>
			<td><input type="text"  name="OrdAddr" value="����� ������ û�㵿"></td>
		</tr>
		<tr>
			<td>�����ڸ�</td>
			<td><input type="text"  name="RcpNm" value="��浿"></td>
		</tr>
		<tr>
			<td>�����ڿ���ó</td>
			<td><input type="text"  name="RcpPhone" value="02-111-2222"></td>
		</tr>
		<tr>
			<td>������ּ�</td>
			<td><input type="text"  name="DlvAddr" value="����� ������ û�㵿"></td>
		</tr>
		<tr>
			<td>��Ÿ�䱸����</td>
			<td><input type="text"  name="Remark" value="���Ŀ� ��ۿ��"></td>
		</tr>
		<tr>
			<td>ī��缱��</td>
			<td><input type="text"  name="CardSelect"  value=""></td>
		</tr>
		<tr>
			<td>���� URL</td>
			<td><input type="text"  name="RtnUrl" value="<%=http_host%>/samples/jsp/AGSMobile_approve.jsp"></td>
		</tr>
		
		<tr>
			<td>�� URL Scheme (���ھ��� ���)</td>
			<td>
				<input type="text"  name="AppRtnScheme" value="">
				<!--  ���̹� ���� :  naversearchapp://inappbrowser?url= -->
				<br/>
				AppRtnScheme + RtnUrl�� ��ģ ������ �ٽ� ���� ȣ���մϴ�.<br/>
				���ھ��� �ƴѰ�� ������ ����
			</td>
		</tr>
		
		<tr>
			<td>��� URL</td>
			<td><input type="text"  name="CancelUrl" value="<%=http_host%>/samples/jsp/AGSMobile_user_cancel.jsp"></td>
		</tr>
		<tr>
			<td>�߰�����ʵ�1</td>
			<td><input type="text"  name="Column1" maxlength="200" value="���������Է�1"></td>
		</tr>
		<tr>
			<td>�߰�����ʵ�2</td>
			<td><input type="text"  name="Column2" maxlength="200" value="���������Է�2"></td>
		</tr>
		<tr>
			<td>�߰�����ʵ�3</td>
			<td><input type="text"  name="Column3" maxlength="200" value="���������Է�3"></td>
		</tr>
		<tr>
			<td colspan="2">������� ���� ��� ����</td>
		</tr>
		<tr>
			<td>�뺸������</td>
			<td><input type="text" name="MallPage" maxlength="100" value="/samples/jsp/AGSMobile_virtual_result.jsp"></td>
		</tr>
		<tr>
			<td>�Աݿ����� (YYYYMMDD)</td>
			<td><input type=text name="VIRTUAL_DEPODT" maxlength=8 value=""></td>
		<tr>
			<td colspan="2">�ڵ��� ���� ��� ����</td>
		</tr>
		<tr>
			<td>CP���̵�</td>
			<td><input type="text" name="HP_ID" maxlength="10" value=""></td>
		</tr>
		<tr>
			<td>CP��й�ȣ</td>
			<td><input type="text" name="HP_PWD" maxlength="10" value=""></td>
		</tr>
		<tr>
			<td>SUB-CP���̵�</td>
			<td><input type="text" name="HP_SUBID" maxlength="10" value=""></td>
		</tr>
		<tr>
			<td>��ǰ�ڵ�</td>
			<td><input type="text" name="ProdCode" maxlength="10" value=""></td>
		</tr>
		<tr>
			<td>��ǰ����</td>
			<td>
				<select name="HP_UNITType">
					<option value="1">������:1
					<option value="2">�ǹ�:2
				</select>
			</td>
		</tr>
		<tr>
            <td>��ǰ�����Ⱓ</td>
            <td><input type="text" name="SubjectData" value="�ݾ�;ǰ��;2014.09.21~28"></td>
        </tr>
		 
	</table>		
	
	<input type="hidden" name=DeviId value="9000400001">			
	<input type="hidden" name=QuotaInf value="0">			
	<input type="hidden" name=NointInf value="NONE">
	
	<div class="text-center width-100">
		<input type="button" value="Ȯ��" class="ok_btn" onclick="doPay(document.form)"/>
	</div>
</div>

</form>

</body>
</html>