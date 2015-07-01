<?
	///////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// �ô�����Ʈ ����� ���� ������ (EUC-KR)
	//
	///////////////////////////////////////////////////////////////////////////////////////////////////
	
	require_once ("./lib/AGSMobile.php");

	$tracking_id = $_REQUEST["tracking_id"];
	$transaction = $_REQUEST["transaction"];
	$StoreId = $_REQUEST["StoreId"];
	$log_path = null; 
	// log���� ������ ������ ��θ� �����մϴ�.
    // ����� ���� null�� �Ǿ����� ��� "���� �۾� ���丮�� /lib/log/"�� ����˴ϴ�.
    
	$agsMobile = new AGSMobile($store_id,$tracking_id,$transaction, $log_path);
	$agsMobile->setLogging(true); //true : �αױ��, false : �αױ�Ͼ���.
	
	////////////////////////////////////////////////////////
	//
	// getTrackingInfo() �� ���� �ô�����Ʈ �������� ȣ���� �� ���� �ߴ� Form ������ Array()�� ����Ǿ� �ֽ��ϴ�. 
	//
	////////////////////////////////////////////////////////
	
	$info = $agsMobile->getTrackingInfo(); //$info ������ array() �����Դϴ�.
   
    /////////////////////////////////////////////////////////////////////////////////
    //  -- tracking_info�� ����ִ� �÷� --
    // 
    //	  ������� : AuthTy (card,hp,virtual)
    //	  ���������� : SubTy (ī���� ��� ���� : isp,visa3d)
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
    //
    //    print_r($info); //tracking_info
    //    echo "�ֹ���ȣ : ".$info["OrdNo"]."</br>";
    //    echo "��ǰ�� : ".$info["ProdNm"]."</br>";
    //    echo "������� : ".$info["Job"]."</br>";
    //    echo "ȸ�����̵� : ".$info["UserId"]."</br>";
    //    echo "�������̸� : ".$info["OrdNm"]."</br>";  
	//
	
	echo "AuthTy : ".$info["AuthTy"]."</br>";
    echo "SubTy : ".$info["SubTy"]."</br>";  
    
	
	$ret = $agsMobile->approve();
	
	
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //
     // ��������� ���� ����DB ���� �� ��Ÿ �ʿ��� ó���۾��� �����ϴ� �κ��Դϴ�.
     // �Ʒ��� ��������� ���Ͽ� �� �������ܺ� ����������� ����Ͻ� �� �ֽ��ϴ�.
     // 
     // $ret�� array() �������� ������ ���� ������ �����ϴ�.
     //
     // $ret = array (
     //        'status' => 'ok' | 'error' //���μ����� ��� ok , ���и� error
     //		  'message' => '������ ��� �����޽���'
     //		  'data' => �������ܺ� ���� array() //���μ����� ��츸 ���õ˴ϴ�.
     //	) 
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
     
	if ($ret['status'] == "ok") {
		/// ���� ���� 
        
        echo "��������: ".$ret['status']."<br/>";   //ok�̸� ����..
        echo "����޽���: ".$ret["message"]."<br/>";   
        
        
        //data ���Ͽ� ���� ���� �޽����� �ֽ��ϴ�.
		echo "��üID : ".$ret["data"]["StoreId"]."<br/>";        
        echo "�ֹ���ȣ: ".$ret["data"]["OrdNo"]."<br/>";   
        echo "�ŷ��ݾ�: ".$ret["data"]["Amt"]."�� <br/>"; 
		echo "tracking_id: ".$tracking_id."<br/>";          
		
        
        
        if($ret["paytype"] == "card"){
            
            /// ī�� ���� �� ���� ���� 
            echo "AuthTy : ".$ret["data"]["AuthTy"]."<br/>";        
            echo "SubTy: ".$ret["data"]["SubTy"]."<br/>";
            
            echo "��üID : ".$ret["data"]["StoreId"]."<br/>";        
            echo "�����ID : ".$ret["data"]["NetCancelId"]."<br/>";
        	echo "�ֹ���ȣ: ".$ret["data"]["OrdNo"]."<br/>";   
	        echo "�ŷ��ݾ�: ".$ret["data"]["Amt"]."�� <br/>";
	        echo "����ũ�ο��� : ".$ret["data"]["EscrowYn"]."<br/>";  //y�̸� escrow
	        echo "�����ڿ���: ".$ret["data"]["NoInt"]."<br/>";  //y�̸� ������
	        echo "����ũ��������ȣ : ".$ret["data"]["EscrowSendNo"]."<br/>";  
	        
	                                         
            echo "�����ڵ� : ".$ret["data"]["BusiCd"]."<br/>";        
            echo "�ŷ���ȣ: ".$ret["data"]["DealNo"]."<br/>";     
            echo "���ι�ȣ: ".$ret["data"]["AdmNo"]."<br/>";     
            echo "���νð�: ".$ret["data"]['AdmTime']."<br/>";    
            echo "ī����ڵ�: ".$ret["data"]["CardCd"]."<br/>";     
            echo "ī����: ".$ret["data"]["CardNm"]."<br/>";     
            echo "�Һΰ�����: ".$ret["data"]["PartialMm"]."<br/>";     
            
            /////////////////////////////////////////
            //
            // ī�� �ŷ��� ���,
            // ���� DB �� ��Ÿ ������ ���ܻ�Ȳ���� ������ �ٷ� ����ؾ� �Ѵٸ�
            // �Ʒ��� ���� ���� �Ʒ��� �Լ� ȣ��� ��Ұ� �����մϴ�.
            //
            /////////////////////////////////////////
            
            // �Ʒ� �κ��� �ּ����� �ϸ� �ٷ� ���� ��� �� �� �ֽ��ϴ�. (ī�� ���� ���� ���Ŀ��� ����)
            
			
			/*
			$cancelRet = $agsMobile->forceCancel();
    
			// ������ �Ʒ����� ó���ϼ���
			if ($cancelRet['status'] == "ok") {
				echo "��� ����<br/>";
		        echo "��üID : ".$cancelRet["data"]["StoreId"]."<br/>";     
		        echo "���ι�ȣ: ".$cancelRet["data"]["AdmNo"]."<br/>";   
		        echo "���νð�: ".$cancelRet["data"]["AdmTime"]."<br/>";   
		        echo "�ڵ�: ".$cancelRet["data"]['Code']."<br/>";   
			
			}else {
				//��� ��� ����
				echo "��� ���� : ".$cancelRet['message']; // ���� �޽���
			}
*/



			//////////////////////////////////////////////
			//
			// ������ ���� �Ʒ��� ��ũ�� ����Ͻø� �˴ϴ�.
			//
			//////////////////////////////////////////////
			
			$url = "http://www.allthegate.com/customer/receiptLast3.jsp";
			$url .= "?sRetailer_id=".$ret["data"]["StoreId"];
			$url .= "?approve=".$ret["data"]["AdmNo"];
			$url .= "?send_no=".$ret["data"]["DealNo"];
			$url .= "?send_dt=".substr($ret["data"]["AdmTime"],0,8);
			
			
            
            
        }else if($ret["paytype"] == "hp"){
            /// �ڵ��� ���� �� ���� ����
            echo "AuthTy : ".$ret["data"]["AuthTy"]."<br/>";        
            echo "SubTy: ".$ret["data"]["SubTy"]."<br/>";
            
            echo "��üID : ".$ret["data"]["StoreId"]."<br/>";        
            echo "�����ID : ".$ret["data"]["NetCancelId"]."<br/>";
        	echo "�ֹ���ȣ: ".$ret["data"]["OrdNo"]."<br/>";   
	        echo "�ŷ��ݾ�: ".$ret["data"]["Amt"]."�� <br/>";
	        
            echo "�ڵ�����Ż� : ".$ret["data"]["PhoneCompany"]."<br/>";      
            echo "�ڵ�����ȣ : ".$ret["data"]["Phone"]."<br/>";      
            echo "�ڵ������� TID : ".$ret["data"]["AdmTID"]."<br/>";    
            
            /////////////////////////////////////////
            //
            // �޴��� �ŷ��� ���,
            // ���� DB �� ��Ÿ ������ ���ܻ�Ȳ���� ������ �ٷ� ����ؾ� �Ѵٸ�
            // �Ʒ��� ���� ���� �Ʒ��� �Լ� ȣ��� ��Ұ� �����մϴ�.
            //
            /////////////////////////////////////////
            
            // �Ʒ� �κ��� �ּ����� �ϸ� �ٷ� ���� ��� �� �� �ֽ��ϴ�. (�޴��� ���� ���� ���Ŀ��� ����)
            
//            $cancelRet = $agsMobile->forceCancel();
//    
//			// ������ �Ʒ����� ó���ϼ���
//			if ($cancelRet['status'] == "ok") {
//				
//		        echo "��üID : ".$cancelRet["data"]["StoreId"]."<br/>";     
//		   		echo "�ڵ������� TID : ".$cancelRet["data"]["AdmTID"]."<br/>";    
//				
//			}else {
//				//��� ��� ����
//				echo "��� ���� : ".$cancelRet['message']; // ���� �޽���
//			}
            
        }else if($ret["paytype"] == "virtual"){
            /// ������� ó�� �� ���� ���� ///
            
            ////////////////////////////////////////////////////////
            // 
            //   ��������� ���������� ������¹߱��� �������� �ǹ��ϸ� �Աݴ����·� ���� ���� �Ա��� �Ϸ��� ���� �ƴմϴ�.
            //   ���� ������� �����Ϸ�� �����Ϸ�� ó���Ͽ� ��ǰ�� ����Ͻø� �ȵ˴ϴ�.
            //   ������ ���� �߱޹��� ���·� �Ա��� �Ϸ�Ǹ� MallPage(���� �Ա��뺸 ������(�������))�� �Աݰ���� ���۵Ǹ�
            //   �̶� ��μ� ������ �Ϸ�ǰ� �ǹǷ� �����Ϸῡ ���� ó��(��ۿ�û ��)��  MallPage�� �۾����ּž� �մϴ�.
            //   
            //   �������� : $ret["data"]["SuccessTime"]
            //   ������¹�ȣ : $ret["data"]["VirtualNo"]
            //   �Ա������ڵ� : $ret["data"]["BankCode"]
            // 
            ////////////////////////////////////////////////////////
            
            echo "AuthTy : ".$ret["data"]["AuthTy"]."<br/>";        
            echo "SubTy: ".$ret["data"]["SubTy"]."<br/>";
            
            
      		echo "��üID : ".$ret["data"]["StoreId"]."<br/>";        
            echo "�����ID : ".$ret["data"]["NetCancelId"]."<br/>";
        	echo "�ֹ���ȣ: ".$ret["data"]["OrdNo"]."<br/>";   
	        echo "�ŷ��ݾ�: ".$ret["data"]["Amt"]."�� <br/>";
	        echo "����ũ�ο��� : ".$ret["data"]["EscrowYn"]."<br/>";  //y�̸� escrow
	        echo "����ũ��������ȣ : ".$ret["data"]["EscrowSendNo"]."<br/>";
	        
            echo "�������� : ".$ret["data"]["SuccessTime"]."<br/>";        
            echo "������¹�ȣ : ".$ret["data"]["VirtualNo"]."<br/>";         
            echo "�Ա������ڵ� : ".$ret["data"]["BankCode"]."<br/>";         
            echo "�Աݱ��� : ".$ret["data"]["DueDate"]."<br/>";
        }
        
		
	
	}else {
		/// ���� ���� 
		echo "���ν��� : ".$ret['message']."<br/>"; // ���� �޽���
	}
	
?>