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
	// �ô�����Ʈ ����� ���� ������ (euc-kr)
	//
	///////////////////////////////////////////////////////////////////////////////////////////////////

	String tracking_id = request.getParameter("tracking_id");
	String transaction = request.getParameter("transaction");
	String store_id = request.getParameter("StoreId");
	String log_path = null;	
	// log���� ������ ������ ��θ� �����մϴ�.
	// ����� ���� null�� �Ǿ����� ��� "���� �۾� ���丮�� /lib/log/"�� ����˴ϴ�.
	
	AGSMobile mobile = new AGSMobile(store_id, tracking_id, transaction, log_path);
	
	mobile.setLogging(true);	//true : �αױ��, false : �αױ�Ͼ���.
	
	
	////////////////////////////////////////////////////////
	//
	// getTrackingInfo() �� ���� �ô�����Ʈ �������� ȣ���� �� ���� �ߴ� Form ������ JSON���� ����Ǿ� �ֽ��ϴ�. 
	//
	////////////////////////////////////////////////////////
	
	JSONObject info = new JSONObject();
	info = mobile.getTrackingInfo();	//	info ������ json �����Դϴ�.



	/////////////////////////////////////////////////////////////////////////////////
    //  -- tracking_info�� ����ִ� �÷� --
    //  
    //    ȸ�����̵� : UserId
    //    �������̸� : OrdNm  
    //    �����̸� : StoreNm
    //    ������� : Job 
    //    ��ǰ�� : ProdNm
    // 
    //    �޴�����ȣ : OrdPhone
    //    �����ڸ� : RcpNm
    //    �����ڿ���ó : RcpPhone
    //    �ֹ����ּ� : OrdAddr
    //    �ֹ���ȣ : OrdNo
    //    ������ּ� : DlvAddr
    //    ��ǰ�ڵ� : ProdCode
    //    �Աݿ����� : VIRTUAL_DEPODT
    //    ��ǰ���� : HP_UNITType
    //    ���� URL : RtnUrl
    //    �������̵� : StoreId
    //    ���� : Amt
    //    �̸��� : UserEmail
    //    ����URL : MallUrl
    //    ��� URL : CancelUrl
    //    �뺸������ : MallPage
    // 
    //    ��Ÿ�䱸���� : Remark
    //    �߰�����ʵ�1 : Column1
    //    �߰�����ʵ�1 : Column2
    //    �߰�����ʵ�1 : Column3
    //    CP���̵� : HP_ID
    //    CP��й�ȣ :  HP_PWD
    //    SUB-CP���̵� : HP_SUBID
    //    ��ǰ�ڵ� :  ProdCode
    //    �������� : DeviId ( 9000400001:�Ϲݰ���, 9000400002:�����ڰ���)
    //    ī��缱�� : CardSelect
    //    �ҺαⰣ :  QuotaInf
    //    ������ �ҺαⰣ: NointInf
    // 
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // tracking_info�� �������� �Ʒ��� ������� �������ø� �˴ϴ� 
	/* 	
		out.write("tracking_info :"+info+"<p/>");
		out.write("�ֹ���ȣ  :"+info.get("OrdNm")+"<br/>");
		out.write("�������  :"+info.get("Job")+"<br/>");
		out.write("ȸ�����̵�  :"+info.get("UserId")+"<br/>");
		out.write("�������̸�   :"+info.get("OrdNm")+"<p/>");
 	*/

   

	HashMap<String, Object> ret = new HashMap<String, Object>();
	ret = mobile.approve();
	JSONObject data = ((JSONObject)ret.get("data"));
 
 
 	 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //
     // ��������� ���� ����DB ���� �� ��Ÿ �ʿ��� ó���۾��� �����ϴ� �κ��Դϴ�.
     // �Ʒ��� ��������� ���Ͽ� �� �������ܺ� ����������� ����Ͻ� �� �ֽ��ϴ�.
     // 
     // $ret�� JSON() �������� ������ ���� ������ �����ϴ�.
     //
     // $ret = JSON (
     //        'status' : 'ok' | 'error' //���μ����� ��� ok , ���и� error
     //		  'message' : '������ ��� �����޽���'
     //		  'data': �������ܺ� ���� JSON() //���μ����� ��츸 ���õ˴ϴ�.
     //	) 
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	if(ret.get("status").equals("ok")){	// ���μ���
		
		out.write("�������� :"+ret.get("status")+"<br/>");	// ok�� ���� 
		out.write("����޼��� :"+ret.get("message")+"<br/>");
			
		// data ���Ͽ� ���� ���� �޽����� �ֽ��ϴ�.
		out.write("��üID :"+data.get("StoreId")+"<br/>");
		out.write("�ֹ���ȣ :"+data.get("OrdNo")+"<br/>");
		out.write("�ŷ��ݾ� :"+data.get("Amt")+"��<p/>");
		out.write("tracking_id :"+tracking_id+"<br/>");

	
		if(ret.get("paytype").equals("card")){	// ī�� ���� �� ���� ���� 
			out.write("��������-----------------------------------------------<br/>");
			out.write("��üID :"+data.get("StoreId")+"<br/>");
			out.write("�����ID :"+data.get("NetCancelId")+"<br/>");
			out.write("�ֹ���ȣ :"+data.get("OrdNo")+"<br/>");
			out.write("�ŷ��ݾ� :"+data.get("Amt")+"��<br/>");
			out.write("����ũ�ο��� :"+data.get("EscrowYn")+"<br/>");	// y�̸� escrow
			out.write("�����ڿ��� :"+data.get("NoInt")+"<br/>");			//y�̸� ������
			out.write("����ũ��������ȣ :"+data.get("EscrowSendNo")+"<br/>");
			
			out.write("�����ڵ� :"+data.get("BusiCd")+"<br/>");
			out.write("�ŷ���ȣ :"+data.get("DealNo")+"<br/>");
			out.write("���ι�ȣ :"+data.get("AdmNo")+"<br/>");
			out.write("���νð� :"+data.get("AdmTime")+"<br/>");
			out.write("ī����ڵ� :"+data.get("CardCd")+"<br/>");
			out.write("ī���� :"+data.get("CardNm")+"<br/>");
			out.write("�Һΰ����� :"+data.get("PartialMm")+"<p/>");
			
		

			/////////////////////////////////////////
			//
			// ī�� �ŷ��� ���,
			// ���� DB �� ��Ÿ ������ ���ܻ�Ȳ���� ������ �ٷ� ����ؾ� �Ѵٸ�
			// �Ʒ��� ���� ���� �Ʒ��� �Լ� ȣ��� ��Ұ� �����մϴ�.
			//
			/////////////////////////////////////////

            // �Ʒ� �κ��� �ּ����� �ϸ� �ٷ� ���� ��� �� �� �ֽ��ϴ�. (ī�� ���� ���� ���Ŀ��� ����) -->
       		
			/************************************************************************
			HashMap<String, Object> cancelRet = mobile.forceCancel();
			
			// ������ �Ʒ����� ó���ϼ���
 			
			if (cancelRet.get("status").equals("ok")) {
				out.write("�������-----------------------------------------------<br/>");
				out.write("��üID :"+((JSONObject)cancelRet.get("data")).get("StoreId")+"<br/>");
				out.write("���ι�ȣ :"+((JSONObject)cancelRet.get("data")).get("AdmNo")+"<br/>");
				out.write("���νð� :"+((JSONObject)cancelRet.get("data")).get("AdmTime")+"<br/>");
				out.write("�ڵ� :"+((JSONObject)cancelRet.get("data")).get("Code")+"<br/>");
			}else {
				// ��� ��� ����
				out.write("��� ���� :"+((JSONObject)cancelRet.get("data")).get("message")+"<br/>");
			}
			*************************************************************************/
	
			//////////////////////////////////////////////
			//
			// ������ ���� �Ʒ��� ��ũ�� ����Ͻø� �˴ϴ�.
			//
			//////////////////////////////////////////////
			
			String receipt_url = "";
			receipt_url = "http://www.allthegate.com/customer/receiptLast3.jsp";
			receipt_url += "?sRetailer_id="+data.get("StoreId");
			receipt_url += "&approve="+data.get("AdmNo");
			receipt_url += "&send_no="+data.get("DealNo");
			receipt_url += "&send_dt="+data.getString("AdmTime").substring(8);
	

		}else if(ret.get("paytype").equals("hp")){	// �ڵ��� ���� �� ���� ����
			
			out.write("��������-----------------------------------------------<br/>");
			out.write("��üID :"+data.get("StoreId")+"<br/>");
			out.write("�����ID :"+data.get("NetCancelId")+"<br/>");
			out.write("�ֹ���ȣ :"+data.get("OrdNo")+"<br/>");
			out.write("�ŷ��ݾ� :"+data.get("Amt")+"��<br/>");
			
			out.write("�ڵ�����Ż� :"+data.get("PhoneCompany")+"<br/>");	
			out.write("�ڵ�����ȣ :"+data.get("PhoneNumber")+"<br/>");			
			out.write("�ڵ������� TID :"+data.get("AdmTID")+"<p/>");
	

			/////////////////////////////////////////
            //
            // �޴��� �ŷ��� ���,
            // ���� DB �� ��Ÿ ������ ���ܻ�Ȳ���� ������ �ٷ� ����ؾ� �Ѵٸ�
            // �Ʒ��� ���� ���� �Ʒ��� �Լ� ȣ��� ��Ұ� �����մϴ�.
            //
            /////////////////////////////////////////

            // �Ʒ� �κ��� �ּ����� �ϸ� �ٷ� ���� ��� �� �� �ֽ��ϴ�. (�޴��� ���� ���� ���Ŀ��� ����)
     
			/************************************************************************		  			 
			HashMap<String, Object> cancelRet = mobile.forceCancel();
			
			// ������ �Ʒ����� ó���ϼ���
			
			if (cancelRet.get("status").equals("ok")) {
				out.write("�������-----------------------------------------------<br/>");
				out.write("��üID :"+((JSONObject)cancelRet.get("data")).get("StoreId")+"<br/>");
				out.write("�ڵ������� TID :"+((JSONObject)cancelRet.get("data")).get("AdmTID")+"<br/>");
			}else {
				// ��� ��� ����
				out.write("��� ���� :"+((JSONObject)cancelRet.get("data")).get("message")+"<br/>");
			}
			*************************************************************************/
			
		}else if(ret.get("paytype").equals("virtual")){	// ������� ó�� �� ���� ����


		////////////////////////////////////////////////////////
        // 
        //   ��������� ���������� ������¹߱��� �������� �ǹ��ϸ� �Աݴ����·� ���� ���� �Ա��� �Ϸ��� ���� �ƴմϴ�.
        //   ���� ������� �����Ϸ�� �����Ϸ�� ó���Ͽ� ��ǰ�� ����Ͻø� �ȵ˴ϴ�.
        //   ������ ���� �߱޹��� ���·� �Ա��� �Ϸ�Ǹ� MallPage(���� �Ա��뺸 ������(�������))�� �Աݰ���� ���۵Ǹ�
        //   �̶� ��μ� ������ �Ϸ�ǰ� �ǹǷ� �����Ϸῡ ���� ó��(��ۿ�û ��)��  MallPage�� �۾����ּž� �մϴ�.
        //   
        //   �������� : data.get("SuccessTime")
        //   ������¹�ȣ : data.get("VirtualNo")
        //   �Ա������ڵ� : data.get("BankCode") 
        // 
        ////////////////////////////////////////////////////////
			out.write("������� ��������-----------------------------------------------<br/>");
        	out.write("��üID :"+data.get("StoreId")+"<br/>");
			out.write("�����ID :"+data.get("NetCancelId")+"<br/>");
			out.write("�ֹ���ȣ :"+data.get("OrdNo")+"<br/>");
			out.write("�ŷ��ݾ� :"+data.get("Amt")+"��<br/>");
			out.write("����ũ�ο��� :"+data.get("EscrowYn")+"<br/>");	// y�̸� escrow
			out.write("����ũ��������ȣ :"+data.get("EscrowSendNo")+"<br/>");
			
			out.write("�������� :"+data.get("SuccessTime")+"<br/>");
			out.write("������¹�ȣ :"+data.get("VirtualNo")+"<br/>");
			out.write("�Ա������ڵ� :"+data.get("BankCode")+"<br/>");
			out.write("�Աݱ��� :"+data.get("DueDate")+"<br/>");

		}

	}else{	// ���ν���
		out.write("���ν��� :"+ret.get("message")+"<br/>");	//���� �޼���
	}
%>
 	
 

</html>