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
	'// 올더게이트 모바일 카드 결제취소 페이지
	'//
	'///////////////////////////////////////////////////////////////////////////////////////////////////

    Dim ags
	Dim Store_OrdNo : Store_OrdNo = Request("Store_OrdNo")		' 취소 원거래건 확인을 위한 상점측 정보
	Dim store_id : store_id = Request("StoreId")

    Set ags = New AGSMobile
    ags.Init store_id,Request("tracking_id"),Request("transaction")
	ags.setLogging True	'로그 기록 남기기 True/False
	ags.setLogpath "e:/logs"	'이 곳에서 로그 Path를 설정하면 됩니다.

	'****************************************************************************
	'	취소요청 하는 건이 실제 상점의 거래건인지 확인하는 부분입니다. 사용하실경우
	'	아래 Cancel_Check 함수 주석을 해제하고 원거래확인 로직을 추가하세요.
	'***************************************************************************/
	If Cancel_Check(Store_OrdNo) = True Then	

		Dim json,retJson
		Set retJson = ags.Cancel(Request("AdmNo"),Request("AdmDt"),Request("SendNo"))

				

		Response.Write "<pre> 승인 결과 : " & vbCrLf
		Response.Write retJson.JSONOutput()
		Response.Write "</pre>"

		Set json = retJson.data
		
		If json.Item("status") = "ok" Then
			Response.Write "성공여부 : " & json.Item("status") & "<br>" & vbCrLf
			Response.Write "결과메시지 : " & json.Item("message") & "<br>" & vbCrLf
			
			Response.Write "업체ID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
			
			
			Response.Write "승인번호 : " & json.Item("data").Item("AdmNo") & "<br>" & vbCrLf
			Response.Write "승인시각 : " & json.Item("data").Item("AdmTime") & "<br>" & vbCrLf
			Response.Write "코드 : " & json.Item("data").Item("Code") & "<br>" & vbCrLf
			
		Else
			Response.Write "승인실패 : " & json.Item("message") & "<br>" & vbCrLf
		End If

	Else
		Response.Write "승인실패 : 취소 원거래건을 찾지 못했습니다."	' 취소요청건이 상점 결제건이 아닌 경우 처리

	End If


    
    
    Set ags = Nothing
%>
<%

Function Cancel_Check(Store_OrdNo)

    Dim flag
	flag = False
	'***********************************************************************************
	'여기서 상점측 원거래 정보를 가져옵니다.
	'취소요청 건의 원거래가 상점측 원거래 정보와 동일하고
	'취소가 가능한 상태이면 True, 아니면 False 
	'원거래 체크로직은 상점에 알맞게 추가/변경하세요     
	'***********************************************************************************/
	
	' Dim Order			' ex. 상점 원거래정보
	'
	' If Store_OrdNo = Order then
	'   flag = True
	' Else
    '	flag = False
    ' End If

    Cancel_Check = flag

End Function

%>
