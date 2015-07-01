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
	'// �ô�����Ʈ ����� ī�� ������� ������
	'//
	'///////////////////////////////////////////////////////////////////////////////////////////////////

    Dim ags
	Dim Store_OrdNo : Store_OrdNo = Request("Store_OrdNo")		' ��� ���ŷ��� Ȯ���� ���� ������ ����
	Dim store_id : store_id = Request("StoreId")

    Set ags = New AGSMobile
    ags.Init store_id,Request("tracking_id"),Request("transaction")
	ags.setLogging True	'�α� ��� ����� True/False
	ags.setLogpath "e:/logs"	'�� ������ �α� Path�� �����ϸ� �˴ϴ�.

	'****************************************************************************
	'	��ҿ�û �ϴ� ���� ���� ������ �ŷ������� Ȯ���ϴ� �κ��Դϴ�. ����Ͻǰ��
	'	�Ʒ� Cancel_Check �Լ� �ּ��� �����ϰ� ���ŷ�Ȯ�� ������ �߰��ϼ���.
	'***************************************************************************/
	If Cancel_Check(Store_OrdNo) = True Then	

		Dim json,retJson
		Set retJson = ags.Cancel(Request("AdmNo"),Request("AdmDt"),Request("SendNo"))

				

		Response.Write "<pre> ���� ��� : " & vbCrLf
		Response.Write retJson.JSONOutput()
		Response.Write "</pre>"

		Set json = retJson.data
		
		If json.Item("status") = "ok" Then
			Response.Write "�������� : " & json.Item("status") & "<br>" & vbCrLf
			Response.Write "����޽��� : " & json.Item("message") & "<br>" & vbCrLf
			
			Response.Write "��üID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
			
			
			Response.Write "���ι�ȣ : " & json.Item("data").Item("AdmNo") & "<br>" & vbCrLf
			Response.Write "���νð� : " & json.Item("data").Item("AdmTime") & "<br>" & vbCrLf
			Response.Write "�ڵ� : " & json.Item("data").Item("Code") & "<br>" & vbCrLf
			
		Else
			Response.Write "���ν��� : " & json.Item("message") & "<br>" & vbCrLf
		End If

	Else
		Response.Write "���ν��� : ��� ���ŷ����� ã�� ���߽��ϴ�."	' ��ҿ�û���� ���� �������� �ƴ� ��� ó��

	End If


    
    
    Set ags = Nothing
%>
<%

Function Cancel_Check(Store_OrdNo)

    Dim flag
	flag = False
	'***********************************************************************************
	'���⼭ ������ ���ŷ� ������ �����ɴϴ�.
	'��ҿ�û ���� ���ŷ��� ������ ���ŷ� ������ �����ϰ�
	'��Ұ� ������ �����̸� True, �ƴϸ� False 
	'���ŷ� üũ������ ������ �˸°� �߰�/�����ϼ���     
	'***********************************************************************************/
	
	' Dim Order			' ex. ���� ���ŷ�����
	'
	' If Store_OrdNo = Order then
	'   flag = True
	' Else
    '	flag = False
    ' End If

    Cancel_Check = flag

End Function

%>
