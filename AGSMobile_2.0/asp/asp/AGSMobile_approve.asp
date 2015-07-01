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
	'// 올더게이트 모바일 결제 승인 페이지
	'//
	'///////////////////////////////////////////////////////////////////////////////////////////////////
	
    Dim StoreId , ags
    StoreId : StoreId = Request("StoreId")

    Set ags = New AGSMobile
    ags.Init StoreId,Request("tracking_id"),Request("transaction")
    ags.setLogging True	'로그 기록 남기기 True/False
    ags.setLogpath "e:/logs"	'이 곳에서 로그 Path를 설정하면 됩니다.
    ags.log "현재 거래 인자들 내용 " & ags.cJsonTrackingInfo.JSONOutput()

    Response.Write "<pre> 결제 트래킹 : " & vbCrLf
    Response.Write ags.cJsonTrackingInfo.JSONOutput()
    Response.Write "</pre>"
	
	'/////////////////////////////////////////////////////////////////////////////////
    '//  -- tracking_info에 들어있는 컬럼 --
    '//  
    '//    
    '//	   >> AGSMobile_start.asp 에서 form값으로 넘겼던 값들을 그대로 사용할 수 있습니다.
    '//
    '//	   결제타입 : AuthTy (card,hp,virtual)
    '//	   서브결제 타입 : SubTy (카드거래일 경우 다음 2중 1개의 값으로 세팅 : isp,visa3d)
    '//    회원아이디 : UserId
    '//    구매자이름 : OrdNm  
    '//    상점이름 : StoreNm
    '//    결제방법 : Job 
    '//    상품명 : ProdNm
    '// 
    '//    휴대폰번호 : OrdPhone
    '//    수신자명 : RcpNm
    '//    수신자연락처 : RcpPhone
    '//    주문자주소 : OrdAddr
    '//    주문번호 : OrdNo
    '//    배송지주소 : DlvAddr
    '//    상품코드 : ProdCode
    '//    입금예정일 : VIRTUAL_DEPODT
    '//    상품종류 : HP_UNITType
    '//    성공 URL : RtnUrl
    '//    상점아이디 : StoreId
    '//    가격 : Amt
    '//    이메일 : UserEmail
    '//    상점URL : MallUrl
    '//    취소 URL : CancelUrl
    '//    통보페이지 : MallPage
    '// 
    '//    기타요구사항 : Remark
    '//    추가사용필드1 : Column1
    '//    추가사용필드1 : Column2
    '//    추가사용필드1 : Column3
    '//    CP아이디 : HP_ID
    '//    CP비밀번호 :  HP_PWD
    '//    SUB-CP아이디 : HP_SUBID
    '//    상품코드 :  ProdCode
    '//    결제정보 : DeviId ( 9000400001:일반결제, 9000400002:무이자결제)
    '//    카드사선택 : CardSelect
    '//    할부기간 :  QuotaInf
    '//    무이자 할부기간: NointInf
    '// 
    '/////////////////////////////////////////////////////////////////
    
    
    '// tracking_info의 정보들은 아래의 방법으로 가져오시면 됩니다 
    '//
    '//    Response.Write "주문번호 : " & ags.cJsonTrackingInfo.data.Item("OrdNo") & "<br>" & vbCrLf
	'//
	
	Response.Write "주문번호 : " & ags.cJsonTrackingInfo.data.Item("OrdNo") & "<br>" & vbCrLf
	Response.Write "휴대폰번호 : " & ags.cJsonTrackingInfo.data.Item("OrdPhone") & "<br>" & vbCrLf
	
	Response.Write "AuthTy : " & ags.cJsonTrackingInfo.data.Item("AuthTy") & "<br>" & vbCrLf
	Response.Write "SubTy : " & ags.cJsonTrackingInfo.data.Item("SubTy") & "<br>" & vbCrLf
	
	
	Dim url
    Dim json,retJson,cretJson
    Set retJson = ags.Approve()

    Response.Write "<pre> 승인 결과 : " & vbCrLf
    Response.Write retJson.JSONOutput()
    Response.Write "</pre>"
    
    Set json = retJson.data

    If  json.Item("status") = "ok" Then
    	Response.Write "성공여부 : " & json.Item("status") & "<br>" & vbCrLf
    	Response.Write "결과메시지 : " & json.Item("message") & "<br>" & vbCrLf
    	
    	Response.Write "업체ID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
    	Response.Write "주문번호 : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
    	Response.Write "거래금액 : " & json.Item("data").Item("Amt") & "원<br>" & vbCrLf
		Response.Write "tracking_id : " & Request("tracking_id") & vbCrLf
    	
    	Select Case json.Item("paytype")
        	Case "card"
        		
        		Response.Write "AuthTy : " & json.Item("data").Item("AuthTy") & "<br>" & vbCrLf
        		Response.Write "SubTy : " & json.Item("data").Item("SubTy") & "<br>" & vbCrLf
    			
    			
        		Response.Write "업체ID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
        		Response.Write "망취소 : " & json.Item("data").Item("NetCancelId") & "<br>" & vbCrLf
    			Response.Write "주문번호 : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
		    	Response.Write "거래금액 : " & json.Item("data").Item("Amt") & "원<br>" & vbCrLf
		    	Response.Write "에스크로여부 : " & json.Item("data").Item("EscrowYn") & "<br>" & vbCrLf
		    	Response.Write "무이자여부 : " & json.Item("data").Item("NoInt") & "<br>" & vbCrLf
		    	Response.Write "에스크로전문번호 : " & json.Item("data").Item("EscrowSendNo") & "<br>" & vbCrLf
		    	
		    	
		    	Response.Write "전문코드 : " & json.Item("data").Item("BusiCd") & "<br>" & vbCrLf
		    	Response.Write "거래번호 : " & json.Item("data").Item("DealNo") & "<br>" & vbCrLf
		    	Response.Write "승인번호 : " & json.Item("data").Item("AdmNo") & "<br>" & vbCrLf
		    	Response.Write "승인시각 : " & json.Item("data").Item("AdmTime") & "<br>" & vbCrLf
		    	Response.Write "카드사코드 : " & json.Item("data").Item("CardCd") & "<br>" & vbCrLf
		    	Response.Write "카드사명 : " & json.Item("data").Item("CardNm") & "<br>" & vbCrLf
		    	Response.Write "할부개월수 : " & json.Item("data").Item("PartialMm") & "<br>" & vbCrLf
				
'				/////////////////////////////////////////
'	            //
'	            // 카드 거래의 경우,
'	            // 상점 DB 및 기타 상점측 예외상황으로 결제를 바로 취소해야 한다면
'	            // 아래의 승인 이후 아래의 함수 호출로 취소가 가능합니다.
'	            //
'	            /////////////////////////////////////////
'
				'아래 부분을 주석 해제 하시면 강제 취소 됩니다. (단 , 정상승인 이후 직전 취소할 경우만 가능)
	            
'				Set cretJson = ags.ForceCancel()
'
'			    Response.Write "<pre> 취소 결과 : " & vbCrLf
'			    Response.Write cretJson.JSONOutput()
'			    Response.Write "</pre>"
'			
'			    Set json = cretJson.data
'			    
'			    If json.Item("status") = "ok" Then
'			    	Response.Write "성공여부 : " & json.Item("status") & "<br>" & vbCrLf
'			    	Response.Write "결과메시지 : " & json.Item("message") & "<br>" & vbCrLf
'			    	
'			    	Response.Write "업체ID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
'			    	
'			    	
'			    	Response.Write "승인번호 : " & json.Item("data").Item("AdmNo") & "<br>" & vbCrLf
'			    	Response.Write "승인시각 : " & json.Item("data").Item("AdmTime") & "<br>" & vbCrLf
'			    	Response.Write "코드 : " & json.Item("data").Item("Code") & "<br>" & vbCrLf
'			     	
'			    Else
'			    	Response.Write "승인실패 : " & json.Item("message") & "<br>" & vbCrLf
'			    End If
			    
			    
'			    //////////////////////////////////////////////
'				//
'				// 영수증 사용시 아래의 링크를 사용하시면 됩니다.
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
	            '//   가상계좌의 결제성공은 가상계좌발급의 성공만을 의미하며 입금대기상태로 실제 고객이 입금을 완료한 것은 아닙니다.
	            '//   따라서 가상계좌 결제완료시 결제완료로 처리하여 상품을 배송하시면 안됩니다.
	            '//   결제후 고객이 발급받은 계좌로 입금이 완료되면 MallPage(상점 입금통보 페이지(가상계좌))로 입금결과가 전송되며
	            '//   이때 비로소 결제가 완료되게 되므로 결제완료에 대한 처리(배송요청 등)은  MallPage에 작업해주셔야 합니다.
	            '////////////////////////////////////////////////////////
				
				Response.Write "AuthTy : " & json.Item("data").Item("AuthTy") & "<br>" & vbCrLf
        		Response.Write "SubTy : " & json.Item("data").Item("SubTy") & "<br>" & vbCrLf
        		
		    	Response.Write "업체ID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
        		Response.Write "망취소 : " & json.Item("data").Item("NetCancelId") & "<br>" & vbCrLf
    			Response.Write "주문번호 : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
		    	Response.Write "거래금액 : " & json.Item("data").Item("Amt") & "원<br>" & vbCrLf
		    	Response.Write "에스크로여부 : " & json.Item("data").Item("EscrowYn") & "<br>" & vbCrLf
		    	Response.Write "에스크로전문번호 : " & json.Item("data").Item("EscrowSendNo") & "<br>" & vbCrLf
		    	Response.Write "승인일자 : " & json.Item("data").Item("SuccessTime") & "<br>" & vbCrLf
		    	Response.Write "가상계좌번호 : " & json.Item("data").Item("VirtualNo") & "<br>" & vbCrLf
		    	Response.Write "입금은행코드 : " & json.Item("data").Item("BankCode") & "<br>" & vbCrLf
		    	Response.Write "입금기한 : " & json.Item("data").Item("DueDate") & "<br>" & vbCrLf
		    
		    Case "hp"
		    
		    	Response.Write "AuthTy : " & json.Item("data").Item("AuthTy") & "<br>" & vbCrLf
        		Response.Write "SubTy : " & json.Item("data").Item("SubTy") & "<br>" & vbCrLf
        		
		    	Response.Write "업체ID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
        		Response.Write "망취소 : " & json.Item("data").Item("NetCancelId") & "<br>" & vbCrLf
    			Response.Write "주문번호 : " & json.Item("data").Item("OrdNo") & "<br>" & vbCrLf
		    	Response.Write "거래금액 : " & json.Item("data").Item("Amt") & "원<br>" & vbCrLf
		    	
		    	
		    	
		    	Response.Write "핸드폰통신사 : " & json.Item("data").Item("PhoneCompany") & "<br>" & vbCrLf
		    	Response.Write "핸드폰번호 : " & json.Item("data").Item("Phone") & "<br>" & vbCrLf
		    	Response.Write "핸드폰결제 TID : " & json.Item("data").Item("AdmTID") & "<br>" & vbCrLf
    	
    	

'				/////////////////////////////////////////
'	            //
'	            // 핸드폰 거래의 경우,
'	            // 상점 DB 및 기타 상점측 예외상황으로 결제를 바로 취소해야 한다면
'	            // 아래의 승인 이후 아래의 함수 호출로 취소가 가능합니다.
'	            //
'	            /////////////////////////////////////////
'
				'아래 부분을 주석 해제 하시면 강제 취소 됩니다. (단 , 정상승인 이후 직전 취소할 경우만 가능)
	            
'				Set cretJson = ags.ForceCancel()
'
'			    Response.Write "<pre> 취소 결과 : " & vbCrLf
'			    Response.Write cretJson.JSONOutput()
'			    Response.Write "</pre>"
'			
'			    Set json = cretJson.data
'			    
'			    If json.Item("status") = "ok" Then
'			    	Response.Write "성공여부 : " & json.Item("status") & "<br>" & vbCrLf
'			    	Response.Write "결과메시지 : " & json.Item("message") & "<br>" & vbCrLf
'			    	
'			    	Response.Write "업체ID : " & json.Item("data").Item("StoreId") & "<br>" & vbCrLf
'			    	Response.Write "핸드폰결제 TID : " & json.Item("data").Item("AdmTID") & "<br>" & vbCrLf
'			     	
'			    Else
'			    	Response.Write "승인실패 : " & json.Item("message") & "<br>" & vbCrLf
'			    End If
			    
			    
			    
        	Case Else
        	
        End Select
     	
    Else
    	Response.Write "승인실패 : " & json.Item("message") & "<br>" & vbCrLf
    End If
    
    
    Set ags = Nothing
%>
