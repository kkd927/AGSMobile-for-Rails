<%@  codepage="949" language="VBScript" %>
<% OPTION EXPLICIT %>
<!--#include file="lib/aspJSON1.17.asp" -->
<!--#include file="lib/AGSMobile.asp" -->
<%
    
    Session.codepage="949"
    Response.CharSet  = "euc-kr"
    Response.CodePage="949"
    Response.AddHeader "Pragma","no-cache"
    Response.AddHeader "cache-control", "no-staff"
    Response.ContentType="text/html;charset=euc-kr"
    Response.Expires  = -1
	
	'///////////////////////////////////////////////////////////////////////////////////////////////////
	'//
	'// �ô�����Ʈ ����� ���� ���� ������
	'//
	'///////////////////////////////////////////////////////////////////////////////////////////////////
	
    Dim StoreId , ags
    StoreId : StoreId = Request("StoreId")

    Set ags = New AGSMobile
    ags.Init StoreId,Request("tracking_id"),Request("transaction")
    ags.setLogging True	'�α� ��� ����� True/False
    ags.setLogpath "e:/logs"	'�� ������ �α� Path�� �����ϸ� �˴ϴ�.
    ags.log "���� �ŷ� ���ڵ� ���� " & ags.cJsonTrackingInfo.JSONOutput()

    Response.Write "<pre> ���� Ʈ��ŷ : " & vbCrLf
    Response.Write ags.cJsonTrackingInfo.JSONOutput()
    Response.Write "</pre>"
	
	'/////////////////////////////////////////////////////////////////////////////////
    '//  -- tracking_info�� ����ִ� �÷� --
    '//  
    '//    
    '//	   >> AGSMobile_start.asp ���� form������ �Ѱ�� ������ �״�� ����� �� �ֽ��ϴ�.
    '//
    '//	   ����Ÿ�� : AuthTy (card,hp,virtual)
    '//	   ������� Ÿ�� : SubTy (ī��ŷ��� ��� ���� 2�� 1���� ������ ���� : isp,visa3d)
    '//    ȸ�����̵� : UserId
    '//    �������̸� : OrdNm  
    '//    �����̸� : StoreNm
    '//    ������� : Job 
    '//    ��ǰ�� : ProdNm
    '// 
    '//    �޴�����ȣ : OrdPhone
    '//    �����ڸ� : RcpNm
    '//    �����ڿ���ó : RcpPhone
    '//    �ֹ����ּ� : OrdAddr
    '//    �ֹ���ȣ : OrdNo
    '//    ������ּ� : DlvAddr
    '//    ��ǰ�ڵ� : ProdCode
    '//    �Աݿ����� : VIRTUAL_DEPODT
    '//    ��ǰ���� : HP_UNITType
    '//    ���� URL : RtnUrl
    '//    �������̵� : StoreId
    '//    ���� : Amt
    '//    �̸��� : UserEmail
    '//    ����URL : MallUrl
    '//    ��� URL : CancelUrl
    '//    �뺸������ : MallPage
    '// 
    '//    ��Ÿ�䱸���� : Remark
    '//    �߰�����ʵ�1 : Column1
    '//    �߰�����ʵ�1 : Column2
    '//    �߰�����ʵ�1 : Column3
    '//    CP���̵� : HP_ID
    '//    CP��й�ȣ :  HP_PWD
    '//    SUB-CP���̵� : HP_SUBID
    '//    ��ǰ�ڵ� :  ProdCode
    '//    �������� : DeviId ( 9000400001:�Ϲݰ���, 9000400002:�����ڰ���)
    '//    ī��缱�� : CardSelect
    '//    �ҺαⰣ :  QuotaInf
    '//    ������ �ҺαⰣ: NointInf
    '// 
    '/////////////////////////////////////////////////////////////////
    
    
    '// tracking_info�� �������� �Ʒ��� ������� �������ø� �˴ϴ� 
    '//
    '//    Response.Write "�ֹ���ȣ : " & ags.cJsonTrackingInfo.data.Item("OrdNo") & "<br>" & vbCrLf
	'//
	
	Response.Write "�ֹ���ȣ : " & ags.cJsonTrackingInfo.data.Item("OrdNo") & "<br>" & vbCrLf
	Response.Write "�޴�����ȣ : " & ags.cJsonTrackingInfo.data.Item("OrdPhone") & "<br>" & vbCrLf
	
	Response.Write "AuthTy : " & ags.cJsonTrackingInfo.data.Item("AuthTy") & "<br>" & vbCrLf
	Response.Write "SubTy : " & ags.cJsonTrackingInfo.data.Item("SubTy") & "<br>" & vbCrLf
	
	
	Dim url
    Dim json,retJson,cretJson
    Set retJson = ags.Approve()

    Response.Write "<pre> ���� ��� : " & vbCrLf
    Response.Write retJson.JSONOutput()
    Response.Write "</pre>"
    
    Set json = retJson.data

    If  json.Item("status") = "ok" Then
    	Response.Write "�������� : " & json.Item("status") & "<br>" & vbCrLf
    	Response.Write "����޽��� : " & json.Item("message") & "<br>" & vbCrLf
    	
    	Response.Write "��üID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
    	Response.Write "�ֹ���ȣ : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
    	Response.Write "�ŷ��ݾ� : " & json.Item("data").Item("Amt") & "��<br>" & vbCrLf
		Response.Write "tracking_id : " & Request("tracking_id") & vbCrLf
    	
    	Select Case json.Item("paytype")
        	Case "card"
        		
        		Response.Write "AuthTy : " & json.Item("data").Item("AuthTy") & "<br>" & vbCrLf
        		Response.Write "SubTy : " & json.Item("data").Item("SubTy") & "<br>" & vbCrLf
    			
    			
        		Response.Write "��üID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
        		Response.Write "����� : " & json.Item("data").Item("NetCancelId") & "<br>" & vbCrLf
    			Response.Write "�ֹ���ȣ : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
		    	Response.Write "�ŷ��ݾ� : " & json.Item("data").Item("Amt") & "��<br>" & vbCrLf
		    	Response.Write "����ũ�ο��� : " & json.Item("data").Item("EscrowYn") & "<br>" & vbCrLf
		    	Response.Write "�����ڿ��� : " & json.Item("data").Item("NoInt") & "<br>" & vbCrLf
		    	Response.Write "����ũ��������ȣ : " & json.Item("data").Item("EscrowSendNo") & "<br>" & vbCrLf
		    	
		    	
		    	Response.Write "�����ڵ� : " & json.Item("data").Item("BusiCd") & "<br>" & vbCrLf
		    	Response.Write "�ŷ���ȣ : " & json.Item("data").Item("DealNo") & "<br>" & vbCrLf
		    	Response.Write "���ι�ȣ : " & json.Item("data").Item("AdmNo") & "<br>" & vbCrLf
		    	Response.Write "���νð� : " & json.Item("data").Item("AdmTime") & "<br>" & vbCrLf
		    	Response.Write "ī����ڵ� : " & json.Item("data").Item("CardCd") & "<br>" & vbCrLf
		    	Response.Write "ī���� : " & json.Item("data").Item("CardNm") & "<br>" & vbCrLf
		    	Response.Write "�Һΰ����� : " & json.Item("data").Item("PartialMm") & "<br>" & vbCrLf
				
'				/////////////////////////////////////////
'	            //
'	            // ī�� �ŷ��� ���,
'	            // ���� DB �� ��Ÿ ������ ���ܻ�Ȳ���� ������ �ٷ� ����ؾ� �Ѵٸ�
'	            // �Ʒ��� ���� ���� �Ʒ��� �Լ� ȣ��� ��Ұ� �����մϴ�.
'	            //
'	            /////////////////////////////////////////
'
				'�Ʒ� �κ��� �ּ� ���� �Ͻø� ���� ��� �˴ϴ�. (�� , ������� ���� ���� ����� ��츸 ����)
	            
'				Set cretJson = ags.ForceCancel()
'
'			    Response.Write "<pre> ��� ��� : " & vbCrLf
'			    Response.Write cretJson.JSONOutput()
'			    Response.Write "</pre>"
'			
'			    Set json = cretJson.data
'			    
'			    If json.Item("status") = "ok" Then
'			    	Response.Write "�������� : " & json.Item("status") & "<br>" & vbCrLf
'			    	Response.Write "����޽��� : " & json.Item("message") & "<br>" & vbCrLf
'			    	
'			    	Response.Write "��üID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
'			    	
'			    	
'			    	Response.Write "���ι�ȣ : " & json.Item("data").Item("AdmNo") & "<br>" & vbCrLf
'			    	Response.Write "���νð� : " & json.Item("data").Item("AdmTime") & "<br>" & vbCrLf
'			    	Response.Write "�ڵ� : " & json.Item("data").Item("Code") & "<br>" & vbCrLf
'			     	
'			    Else
'			    	Response.Write "���ν��� : " & json.Item("message") & "<br>" & vbCrLf
'			    End If
			    
			    
'			    //////////////////////////////////////////////
'				//
'				// ������ ���� �Ʒ��� ��ũ�� ����Ͻø� �˴ϴ�.
'				//
'				//////////////////////////////////////////////
				
				
				url = "http://www.allthegate.com/customer/receiptLast3.jsp"
				url = url & "?sRetailer_id=" & json.Item("data").Item("StoreId")
				url = url & "?approve=" & json.Item("data").Item("AdmNo")
				url = url & "?send_no=" & json.Item("data").Item("DealNo")
				url = url & "?send_dt=" & Left(json.Item("data").Item("AdmTime"),8)
			    
			    
		    Case "virtual"
		    	'////////////////////////////////////////////////////////
	            '// 
	            '//   ��������� ���������� ������¹߱��� �������� �ǹ��ϸ� �Աݴ����·� ���� ���� �Ա��� �Ϸ��� ���� �ƴմϴ�.
	            '//   ���� ������� �����Ϸ�� �����Ϸ�� ó���Ͽ� ��ǰ�� ����Ͻø� �ȵ˴ϴ�.
	            '//   ������ ���� �߱޹��� ���·� �Ա��� �Ϸ�Ǹ� MallPage(���� �Ա��뺸 ������(�������))�� �Աݰ���� ���۵Ǹ�
	            '//   �̶� ��μ� ������ �Ϸ�ǰ� �ǹǷ� �����Ϸῡ ���� ó��(��ۿ�û ��)��  MallPage�� �۾����ּž� �մϴ�.
	            '////////////////////////////////////////////////////////
				
				Response.Write "AuthTy : " & json.Item("data").Item("AuthTy") & "<br>" & vbCrLf
        		Response.Write "SubTy : " & json.Item("data").Item("SubTy") & "<br>" & vbCrLf
        		
		    	Response.Write "��üID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
        		Response.Write "����� : " & json.Item("data").Item("NetCancelId") & "<br>" & vbCrLf
    			Response.Write "�ֹ���ȣ : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
		    	Response.Write "�ŷ��ݾ� : " & json.Item("data").Item("Amt") & "��<br>" & vbCrLf
		    	Response.Write "����ũ�ο��� : " & json.Item("data").Item("EscrowYn") & "<br>" & vbCrLf
		    	Response.Write "����ũ��������ȣ : " & json.Item("data").Item("EscrowSendNo") & "<br>" & vbCrLf
		    	Response.Write "�������� : " & json.Item("data").Item("SuccessTime") & "<br>" & vbCrLf
		    	Response.Write "������¹�ȣ : " & json.Item("data").Item("VirtualNo") & "<br>" & vbCrLf
		    	Response.Write "�Ա������ڵ� : " & json.Item("data").Item("BankCode") & "<br>" & vbCrLf
		    	Response.Write "�Աݱ��� : " & json.Item("data").Item("DueDate") & "<br>" & vbCrLf
		    
		    Case "hp"
		    
		    	Response.Write "AuthTy : " & json.Item("data").Item("AuthTy") & "<br>" & vbCrLf
        		Response.Write "SubTy : " & json.Item("data").Item("SubTy") & "<br>" & vbCrLf
        		
		    	Response.Write "��üID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
        		Response.Write "����� : " & json.Item("data").Item("NetCancelId") & "<br>" & vbCrLf
    			Response.Write "�ֹ���ȣ : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
		    	Response.Write "�ŷ��ݾ� : " & json.Item("data").Item("Amt") & "��<br>" & vbCrLf
		    	
		    	
		    	
		    	Response.Write "�ڵ�����Ż� : " & json.Item("data").Item("PhoneCompany") & "<br>" & vbCrLf
		    	Response.Write "�ڵ�����ȣ : " & json.Item("data").Item("Phone") & "<br>" & vbCrLf
		    	Response.Write "�ڵ������� TID : " & json.Item("data").Item("AdmTID") & "<br>" & vbCrLf
    	
    	

'				/////////////////////////////////////////
'	            //
'	            // �ڵ��� �ŷ��� ���,
'	            // ���� DB �� ��Ÿ ������ ���ܻ�Ȳ���� ������ �ٷ� ����ؾ� �Ѵٸ�
'	            // �Ʒ��� ���� ���� �Ʒ��� �Լ� ȣ��� ��Ұ� �����մϴ�.
'	            //
'	            /////////////////////////////////////////
'
				'�Ʒ� �κ��� �ּ� ���� �Ͻø� ���� ��� �˴ϴ�. (�� , ������� ���� ���� ����� ��츸 ����)
	            
'				Set cretJson = ags.ForceCancel()
'
'			    Response.Write "<pre> ��� ��� : " & vbCrLf
'			    Response.Write cretJson.JSONOutput()
'			    Response.Write "</pre>"
'			
'			    Set json = cretJson.data
'			    
'			    If json.Item("status") = "ok" Then
'			    	Response.Write "�������� : " & json.Item("status") & "<br>" & vbCrLf
'			    	Response.Write "����޽��� : " & json.Item("message") & "<br>" & vbCrLf
'			    	
'			    	Response.Write "��üID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
'			    	Response.Write "�ڵ������� TID : " & json.Item("data").Item("AdmTID") & "<br>" & vbCrLf
'			     	
'			    Else
'			    	Response.Write "���ν��� : " & json.Item("message") & "<br>" & vbCrLf
'			    End If
			    
			    
			    
        	Case Else
        	
        End Select
     	
    Else
    	Response.Write "���ν��� : " & json.Item("message") & "<br>" & vbCrLf
    End If
    
    
    Set ags = Nothing
%>
