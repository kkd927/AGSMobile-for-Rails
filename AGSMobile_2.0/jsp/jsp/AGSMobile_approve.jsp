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
	// 올더게이트 모바일 승인 페이지 (euc-kr)
	//
	///////////////////////////////////////////////////////////////////////////////////////////////////

	String tracking_id = request.getParameter("tracking_id");
	String transaction = request.getParameter("transaction");
	String store_id = request.getParameter("StoreId");
	String log_path = null;	
	// log파일 저장할 폴더의 경로를 지정합니다.
	// 경로의 값이 null로 되어있을 경우 "현재 작업 디렉토리의 /lib/log/"에 저장됩니다.
	
	AGSMobile mobile = new AGSMobile(store_id, tracking_id, transaction, log_path);
	
	mobile.setLogging(true);	//true : 로그기록, false : 로그기록안함.
	
	
	////////////////////////////////////////////////////////
	//
	// getTrackingInfo() 는 최초 올더게이트 페이지를 호출할 때 전달 했던 Form 값들이 JSON으로 저장되어 있습니다. 
	//
	////////////////////////////////////////////////////////
	
	JSONObject info = new JSONObject();
	info = mobile.getTrackingInfo();	//	info 변수는 json 형식입니다.



	/////////////////////////////////////////////////////////////////////////////////
    //  -- tracking_info에 들어있는 컬럼 --
    //  
    //    회원아이디 : UserId
    //    구매자이름 : OrdNm  
    //    상점이름 : StoreNm
    //    결제방법 : Job 
    //    상품명 : ProdNm
    // 
    //    휴대폰번호 : OrdPhone
    //    수신자명 : RcpNm
    //    수신자연락처 : RcpPhone
    //    주문자주소 : OrdAddr
    //    주문번호 : OrdNo
    //    배송지주소 : DlvAddr
    //    상품코드 : ProdCode
    //    입금예정일 : VIRTUAL_DEPODT
    //    상품종류 : HP_UNITType
    //    성공 URL : RtnUrl
    //    상점아이디 : StoreId
    //    가격 : Amt
    //    이메일 : UserEmail
    //    상점URL : MallUrl
    //    취소 URL : CancelUrl
    //    통보페이지 : MallPage
    // 
    //    기타요구사항 : Remark
    //    추가사용필드1 : Column1
    //    추가사용필드1 : Column2
    //    추가사용필드1 : Column3
    //    CP아이디 : HP_ID
    //    CP비밀번호 :  HP_PWD
    //    SUB-CP아이디 : HP_SUBID
    //    상품코드 :  ProdCode
    //    결제정보 : DeviId ( 9000400001:일반결제, 9000400002:무이자결제)
    //    카드사선택 : CardSelect
    //    할부기간 :  QuotaInf
    //    무이자 할부기간: NointInf
    // 
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // tracking_info의 정보들은 아래의 방법으로 가져오시면 됩니다 
	/* 	
		out.write("tracking_info :"+info+"<p/>");
		out.write("주문번호  :"+info.get("OrdNm")+"<br/>");
		out.write("결제방법  :"+info.get("Job")+"<br/>");
		out.write("회원아이디  :"+info.get("UserId")+"<br/>");
		out.write("구매자이름   :"+info.get("OrdNm")+"<p/>");
 	*/

   

	HashMap<String, Object> ret = new HashMap<String, Object>();
	ret = mobile.approve();
	JSONObject data = ((JSONObject)ret.get("data"));
 
 
 	 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //
     // 결제결과에 따른 상점DB 저장 및 기타 필요한 처리작업을 수행하는 부분입니다.
     // 아래의 결과값들을 통하여 각 결제수단별 결제결과값을 사용하실 수 있습니다.
     // 
     // $ret는 JSON() 형식으로 다음과 같은 구조를 가집니다.
     //
     // $ret = JSON (
     //        'status' : 'ok' | 'error' //승인성공일 경우 ok , 실패면 error
     //		  'message' : '에러일 경우 에러메시지'
     //		  'data': 결제수단별 정보 JSON() //승인성공일 경우만 세팅됩니다.
     //	) 
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	if(ret.get("status").equals("ok")){	// 승인성공
		
		out.write("성공여부 :"+ret.get("status")+"<br/>");	// ok면 성공 
		out.write("결과메세지 :"+ret.get("message")+"<br/>");
			
		// data 이하에 서버 응답 메시지가 있습니다.
		out.write("업체ID :"+data.get("StoreId")+"<br/>");
		out.write("주문번호 :"+data.get("OrdNo")+"<br/>");
		out.write("거래금액 :"+data.get("Amt")+"원<p/>");
		out.write("tracking_id :"+tracking_id+"<br/>");

	
		if(ret.get("paytype").equals("card")){	// 카드 결제 후 받은 정보 
			out.write("결제성공-----------------------------------------------<br/>");
			out.write("업체ID :"+data.get("StoreId")+"<br/>");
			out.write("망취소ID :"+data.get("NetCancelId")+"<br/>");
			out.write("주문번호 :"+data.get("OrdNo")+"<br/>");
			out.write("거래금액 :"+data.get("Amt")+"원<br/>");
			out.write("에스크로여부 :"+data.get("EscrowYn")+"<br/>");	// y이면 escrow
			out.write("무이자여부 :"+data.get("NoInt")+"<br/>");			//y이면 무이자
			out.write("에스크로전문번호 :"+data.get("EscrowSendNo")+"<br/>");
			
			out.write("전문코드 :"+data.get("BusiCd")+"<br/>");
			out.write("거래번호 :"+data.get("DealNo")+"<br/>");
			out.write("승인번호 :"+data.get("AdmNo")+"<br/>");
			out.write("승인시각 :"+data.get("AdmTime")+"<br/>");
			out.write("카드사코드 :"+data.get("CardCd")+"<br/>");
			out.write("카드사명 :"+data.get("CardNm")+"<br/>");
			out.write("할부개월수 :"+data.get("PartialMm")+"<p/>");
			
		

			/////////////////////////////////////////
			//
			// 카드 거래의 경우,
			// 상점 DB 및 기타 상점측 예외상황으로 결제를 바로 취소해야 한다면
			// 아래의 승인 이후 아래의 함수 호출로 취소가 가능합니다.
			//
			/////////////////////////////////////////

            // 아래 부분을 주석해제 하면 바로 강제 취소 할 수 있습니다. (카드 정상 승인 이후에만 가능) -->
       		
			/************************************************************************
			HashMap<String, Object> cancelRet = mobile.forceCancel();
			
			// 상점은 아래에서 처리하세요
 			
			if (cancelRet.get("status").equals("ok")) {
				out.write("결제취소-----------------------------------------------<br/>");
				out.write("업체ID :"+((JSONObject)cancelRet.get("data")).get("StoreId")+"<br/>");
				out.write("승인번호 :"+((JSONObject)cancelRet.get("data")).get("AdmNo")+"<br/>");
				out.write("승인시각 :"+((JSONObject)cancelRet.get("data")).get("AdmTime")+"<br/>");
				out.write("코드 :"+((JSONObject)cancelRet.get("data")).get("Code")+"<br/>");
			}else {
				// 취소 통신 실패
				out.write("취소 실패 :"+((JSONObject)cancelRet.get("data")).get("message")+"<br/>");
			}
			*************************************************************************/
	
			//////////////////////////////////////////////
			//
			// 영수증 사용시 아래의 링크를 사용하시면 됩니다.
			//
			//////////////////////////////////////////////
			
			String receipt_url = "";
			receipt_url = "http://www.allthegate.com/customer/receiptLast3.jsp";
			receipt_url += "?sRetailer_id="+data.get("StoreId");
			receipt_url += "&approve="+data.get("AdmNo");
			receipt_url += "&send_no="+data.get("DealNo");
			receipt_url += "&send_dt="+data.getString("AdmTime").substring(8);
	

		}else if(ret.get("paytype").equals("hp")){	// 핸드폰 결제 후 받은 정보
			
			out.write("결제성공-----------------------------------------------<br/>");
			out.write("업체ID :"+data.get("StoreId")+"<br/>");
			out.write("망취소ID :"+data.get("NetCancelId")+"<br/>");
			out.write("주문번호 :"+data.get("OrdNo")+"<br/>");
			out.write("거래금액 :"+data.get("Amt")+"원<br/>");
			
			out.write("핸드폰통신사 :"+data.get("PhoneCompany")+"<br/>");	
			out.write("핸드폰번호 :"+data.get("PhoneNumber")+"<br/>");			
			out.write("핸드폰결제 TID :"+data.get("AdmTID")+"<p/>");
	

			/////////////////////////////////////////
            //
            // 휴대폰 거래의 경우,
            // 상점 DB 및 기타 상점측 예외상황으로 결제를 바로 취소해야 한다면
            // 아래의 승인 이후 아래의 함수 호출로 취소가 가능합니다.
            //
            /////////////////////////////////////////

            // 아래 부분을 주석해제 하면 바로 강제 취소 할 수 있습니다. (휴대폰 정상 승인 이후에만 가능)
     
			/************************************************************************		  			 
			HashMap<String, Object> cancelRet = mobile.forceCancel();
			
			// 상점은 아래에서 처리하세요
			
			if (cancelRet.get("status").equals("ok")) {
				out.write("결제취소-----------------------------------------------<br/>");
				out.write("업체ID :"+((JSONObject)cancelRet.get("data")).get("StoreId")+"<br/>");
				out.write("핸드폰결제 TID :"+((JSONObject)cancelRet.get("data")).get("AdmTID")+"<br/>");
			}else {
				// 취소 통신 실패
				out.write("취소 실패 :"+((JSONObject)cancelRet.get("data")).get("message")+"<br/>");
			}
			*************************************************************************/
			
		}else if(ret.get("paytype").equals("virtual")){	// 가상계좌 처리 후 받은 정보


		////////////////////////////////////////////////////////
        // 
        //   가상계좌의 결제성공은 가상계좌발급의 성공만을 의미하며 입금대기상태로 실제 고객이 입금을 완료한 것은 아닙니다.
        //   따라서 가상계좌 결제완료시 결제완료로 처리하여 상품을 배송하시면 안됩니다.
        //   결제후 고객이 발급받은 계좌로 입금이 완료되면 MallPage(상점 입금통보 페이지(가상계좌))로 입금결과가 전송되며
        //   이때 비로소 결제가 완료되게 되므로 결제완료에 대한 처리(배송요청 등)은  MallPage에 작업해주셔야 합니다.
        //   
        //   승인일자 : data.get("SuccessTime")
        //   가상계좌번호 : data.get("VirtualNo")
        //   입금은행코드 : data.get("BankCode") 
        // 
        ////////////////////////////////////////////////////////
			out.write("가상계좌 생성성공-----------------------------------------------<br/>");
        	out.write("업체ID :"+data.get("StoreId")+"<br/>");
			out.write("망취소ID :"+data.get("NetCancelId")+"<br/>");
			out.write("주문번호 :"+data.get("OrdNo")+"<br/>");
			out.write("거래금액 :"+data.get("Amt")+"원<br/>");
			out.write("에스크로여부 :"+data.get("EscrowYn")+"<br/>");	// y이면 escrow
			out.write("에스크로전문번호 :"+data.get("EscrowSendNo")+"<br/>");
			
			out.write("승인일자 :"+data.get("SuccessTime")+"<br/>");
			out.write("가상계좌번호 :"+data.get("VirtualNo")+"<br/>");
			out.write("입금은행코드 :"+data.get("BankCode")+"<br/>");
			out.write("입금기한 :"+data.get("DueDate")+"<br/>");

		}

	}else{	// 승인실패
		out.write("승인실패 :"+ret.get("message")+"<br/>");	//에러 메세지
	}
%>
 	
 

</html>