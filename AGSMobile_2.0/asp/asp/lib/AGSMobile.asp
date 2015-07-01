<%

Const C_AGSHOST = "https://www.allthegate.com"

Function GetApplicationPath()
       GetApplicationPath = Mid(Request.ServerVariables("APPL_MD_PATH"), Len(Request.ServerVariables("INSTANCE_META_PATH")) + 6) & "/"
End Function

Class AGSMobile
    Private cStrTrackingId
    Private cStrTransaction
    Private cStrStoreId
    Private cBLogging
    Private cHFileName
    Private cNetCancelId
    
    Public cJsonTrackingInfo


    Private Sub Class_Initialize()
        Set cJsonTrackingInfo = Nothing
        Set cHFileName = Nothing
        cBLogging = True
        cStrTrackingId = ""
        cStrTransaction = ""
        cStrStoreId = ""

        On Error Resume Next

        Dim fs
        Set fs=Server.CreateObject("Scripting.FileSystemObject")
       
        If fs.FolderExists(Server.MapPath("./lib/log"))=True Then
          
        Else
           fs.CreateFolder(Server.MapPath("./lib/log"))

        End If

        If Err.Number = 0 Then
            Set cHFileName = fs.OpenTextFile(Server.MapPath("./lib/log") & "/" & Date() & ".log", 8, True)
            Err.Clear
        End IF

        
        Set fs=nothing
        

    End Sub

    Public Function Init (StoreId , TrackingId , Transaction) 
        cStrTrackingId = TrackingId
        cStrStoreId = StoreId
        cStrTransaction = Transaction
        Set cJsonTrackingInfo = New aspJSON 
        cJsonTrackingInfo.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/tracking.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId)
        Set Init = cJsonTrackingInfo
    End Function


    Public Sub setLogging(log) 
        cBLogging = log
        
        If Not cBLogging Then
        	Set cHFileName =  Nothing
        End If
        
    End Sub

    
    Public Sub setLogpath(logfolder) 
        On Error Resume Next
        Set cHFileName = Nothing
        
        If cBLogging Then
	        
	        Dim fs
	        Set fs=Server.CreateObject("Scripting.FileSystemObject")
	       
	        If fs.FolderExists(logfolder)=True Then
	          
	        Else
	           fs.CreateFolder(logfolder)
	
	        End If
	
	        If Err.Number = 0 Then
	            Set cHFileName = fs.OpenTextFile(logfolder & "/" & Date() & ".log", 8, True)
	            Err.Clear
	        End IF
	
	        
	        Set fs=nothing
        End If
        
    End Sub


    Public Sub log(str)
        
        On Error Resume Next

        If cBLogging And Not cHFileName Is Nothing Then
            cHFileName.Write Now() & " ==> " & str & vbCrLf
        End If

    End Sub

    Public Function Approve()
        
        'On Error Resume Next

        Dim oJSON 
        Dim rJson 
        Dim code , message ,data , noInt
        Set oJSON = new aspJSON

        With oJSON.data
            .Add "status", "error"                     
            .Add "message", "서버 에러"
        End With

        Select Case cStrTransaction
        	Case "virtual"
        		
        		With oJSON.data
		            .Add "paytype", "virtual"                     
		        End With
		        
        		' Virtual Part Begin
                
                Set rJson = new aspJSON
                rJson.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/virtual.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId & "&type=approve")
                
                me.log rJSon.JSONOutput()

                If rJson.data.Count > 0 Then
                    

                    code = rJson.data.Item("code")
                    If IsEmpty(code) Then
                    	Set Approve = oJSON
                        Exit Function
                    End If
                    
                    If Cint(code) = Cint(400) Then
                        
                        message = rJson.data.Item("message")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
  					
  					Set data = rJson.data.Item("data")
  					
  					If StrComp(data.Item("Success"), "y", vbTextCompare) <> 0 Then
  					
  						message = data.Item("ResMsg")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
                        
                    Else
                    
                    	
  						
  						With oJSON.data
                            .Item("status") = "ok"                     
                            .Item("message") = "ok"
                            .Add "data", oJSON.Collection()
                            With .Item("data")
                            	
                            	noInt = "n"
                            	If StrComp(data.Item("DeviId"),"y",vbTextCompare) = 0 Then
                            		noInt = "y"
                            	End If
                            	
                            	.Add "StoreId" , data.Item("StoreId")
                            	.Add "NetCancelId" , data.Item("NetCancelId")
                            	
                            	.Add "AuthTy" , data.Item("AuthTy")
                            	.Add "SubTy" , data.Item("SubTy")
                            	
                            	.Add "OrdNo" , data.Item("OrdNo")
                            	.Add "Amt" , data.Item("Amt")
                            	.Add "EscrowYn" , data.Item("EscrowYn")
                            	.Add "NoInt" , noInt
                            	.Add "EscrowSendNo" , data.Item("EscrowSendNo")
                            	
                            	.Add "VirtualNo" , data.Item("VirtualNum")
                            	.Add "BankCode" , data.Item("BankCode")
                            	.Add "SuccessTime" , data.Item("SuccessTime")
                            	.Add "DueDate" , data.Item("DueDate")
                            End With
                            
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
                    
                     
                End If
                ' Virtual Part end if
                
			
			
			Case "hp"
        		
        		With oJSON.data
		            .Add "paytype", "hp"                     
		        End With
		        
        		' HP Part Begin
                
                Set rJson = new aspJSON
                rJson.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/phone.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId & "&type=approve")
                
                me.log rJSon.JSONOutput()

                If rJson.data.Count > 0 Then
                    

                    code = rJson.data.Item("code")
                    If IsEmpty(code) Then
                    	Set Approve = oJSON
                        Exit Function
                    End If
                    
                    If Cint(code) = Cint(400) Then
                        
                        message = rJson.data.Item("message")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
  					
  					Set data = rJson.data.Item("data")
  					
  					If StrComp(data.Item("Success"), "y", vbTextCompare) <> 0 Then
  					
  						message = data.Item("ResMsg")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
                        
                    Else
                    
                    	
  						
  						With oJSON.data
                            .Item("status") = "ok"                     
                            .Item("message") = "ok"
                            .Add "data", oJSON.Collection()
                            With .Item("data")
                            	
                            	noInt = "n"
                            	If StrComp(data.Item("DeviId"),"y",vbTextCompare) = 0 Then
                            		noInt = "y"
                            	End If
                            	
                            	cNetCancelId = data.Item("NetCancelId")
                            	
                            	.Add "StoreId" , data.Item("StoreId")
                            	.Add "NetCancelId" , data.Item("NetCancelId")
                            	
                            	.Add "AuthTy" , data.Item("AuthTy")
                            	.Add "SubTy" , data.Item("SubTy")
                            	
                            	.Add "OrdNo" , data.Item("OrdNo")
                            	.Add "Amt" , data.Item("Amt")
                            	'.Add "EscrowYn" , data.Item("EscrowYn")
                            	'.Add "NoInt" , noInt
                            	'.Add "EscrowSendNo" , data.Item("EscrowSendNo")
                            	
                            	.Add "AdmTID" , data.Item("HpTid")
                            	.Add "PhoneCompany" , data.Item("HpCompany")
                            	.Add "Phone" , data.Item("IsDstAddr")
                            End With
                            
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
                    
                     
                End If
                ' HP Part end if
			
			Case "ansim","xansim","kmpi"
        	    
               
        		With oJSON.data
		            .Add "paytype", "card"                     
		        End With
		        
        		' ANSim Card Part Begin
                 
                Set rJson = new aspJSON
                rJson.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/ansim.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId & "&type=approve")
                
                me.log rJSon.JSONOutput()

                If rJson.data.Count > 0 Then
                    

                    code = rJson.data.Item("code")
                    If IsEmpty(code) Then
                    	Set Approve = oJSON
                        Exit Function
                    End If
                    
                    If Cint(code) = Cint(400) Then
                        
                        message = rJson.data.Item("message")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
  					
  					Set data = rJson.data.Item("data")
  					
  					If StrComp(data.Item("Success"), "y", vbTextCompare) <> 0 Then
  					
  						message = data.Item("FailReason")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
                        
                    Else
                    
                    	
  						
  						With oJSON.data
                            .Item("status") = "ok"                     
                            .Item("message") = "ok"
                            .Add "data", oJSON.Collection()
                            With .Item("data")
                            	
                            	noInt = "n"
                            	If StrComp(data.Item("DeviId"),"y",vbTextCompare) = 0 Then
                            		noInt = "y"
                            	End If
                            	
                            	cNetCancelId = data.Item("NetCancelId")
                            	
                            	.Add "StoreId" , data.Item("StoreId")
                            	.Add "NetCancelId" , data.Item("NetCancelId")
                            	
                            	.Add "AuthTy" , data.Item("AuthTy")
                            	.Add "SubTy" , data.Item("SubTy")
                            	
                            	.Add "OrdNo" , data.Item("OrdNo")
                            	.Add "Amt" , data.Item("Amt")
                            	.Add "EscrowYn" , data.Item("EscrowYn")
                            	.Add "NoInt" , noInt
                            	.Add "EscrowSendNo" , data.Item("EscrowSendNo")
                            	
                            	.Add "BusiCd" , data.Item("Code")
                            	.Add "AdmNo" , data.Item("AdmNo")
                            	.Add "AdmTime" , data.Item("AdmTime")
                            	.Add "CardCd" , data.Item("CardType")
                            	.Add "CardNm" , data.Item("CardName")
                            	.Add "DealNo" , data.Item("DealNo")
                            	.Add "PartialMm" , data.Item("CardPartialMm")
                            	
                            End With
                            
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
                    
                     
                End If
                ' HP Part end if
            
            
            Case "isp"
        		
        		With oJSON.data
		            .Add "paytype", "card"                     
		        End With
		        
        		' ANSim Card Part Begin
                 
                Set rJson = new aspJSON
                rJson.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/isp.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId & "&type=approve")
                
                me.log rJSon.JSONOutput()

                If rJson.data.Count > 0 Then
                    

                    code = rJson.data.Item("code")
                    If IsEmpty(code) Then
                    	Set Approve = oJSON
                        Exit Function
                    End If
                    
                    If Cint(code) = Cint(400) Then
                        
                        message = rJson.data.Item("message")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
  					
  					Set data = rJson.data.Item("data")
  					
  					If StrComp(data.Item("Success"), "y", vbTextCompare) <> 0 Then
  					
  						message = data.Item("FailReason")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Approve = oJSON
                        Exit Function
                        
                    Else
                    
                    	
  						
  						With oJSON.data
                            .Item("status") = "ok"                     
                            .Item("message") = "ok"
                            .Add "data", oJSON.Collection()
                            With .Item("data")
                            	
                            	noInt = "n"
                            	If StrComp(data.Item("DeviId"),"y",vbTextCompare) = 0 Then
                            		noInt = "y"
                            	End If
                            	
                            	cNetCancelId = data.Item("NetCancelId")
                            	
                            	.Add "StoreId" , data.Item("StoreId")
                            	.Add "NetCancelId" , data.Item("NetCancelId")
                            	
                            	.Add "AuthTy" , data.Item("AuthTy")
                            	.Add "SubTy" , data.Item("SubTy")
                            	
                            	.Add "OrdNo" , data.Item("OrdNo")
                            	.Add "Amt" , data.Item("Amt")
                            	.Add "EscrowYn" , data.Item("EscrowYn")
                            	.Add "NoInt" , noInt
                            	.Add "EscrowSendNo" , data.Item("EscrowSendNo")
                            	
                            	.Add "BusiCd" , data.Item("Code")
                            	.Add "AdmNo" , data.Item("AdmNo")
                            	.Add "AdmTime" , data.Item("AdmTime")
                            	.Add "CardCd" , data.Item("CardType")
                            	.Add "CardNm" , data.Item("CardName")
                            	.Add "DealNo" , data.Item("SendNo")
                            	.Add "PartialMm" , data.Item("CardPartialMm")
                            	
                            End With
                            
                        End With
                        Set Approve = oJSON
                        Exit Function
  					End If
                    
                     
                End If
                ' ISP Part end if 
                
			Case else
				me.log "올바르지 않은 결제 타입입니다"
				With oJSON.data
                    .Item("status") = "error"                     
                    .Item("message") = "올바르지 않은 결제 타입입니다"
                End With
		End Select


        Set Approve = oJSON
    End Function
    
    Public Function ForceCancel() 
    	Set ForceCancel = me.Cancel("","","")
    End Function
	
	Public Function Cancel(AdmNo,AdmDt,SendNo)
        
        'On Error Resume Next

        Dim oJSON 
        Dim rJson
        Dim code , message ,data 
        Set oJSON = new aspJSON

        With oJSON.data
            .Add "status", "error"                     
            .Add "message", "서버 에러"
        End With
        
        
        Select Case cStrTransaction
        	
			Case "ansim","xansim","kmpi"
        		
        		With oJSON.data
		            .Add "paytype", "card"                     
		        End With
		        
        		' ANSim Card Part Begin
                 
                Set rJson = new aspJSON
                rJson.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/ansim.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId & "&type=cancel" & "&admNo=" & AdmNo & "&sendNo=" & SendNo & "&admDt=" & AdmDt & "&NetCancelId=" & cNetCancelId )
                
                me.log rJSon.JSONOutput()

                If rJson.data.Count > 0 Then
                    

                    code = rJson.data.Item("code")
                    If IsEmpty(code) Then
                    	Set Approve = oJSON
                        Exit Function
                    End If
                    
                    If Cint(code) = Cint(400) Then
                        
                        message = rJson.data.Item("message")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Cancel = oJSON
                        Exit Function
  					End If
  					
  					Set data = rJson.data.Item("data")
  					
  					If StrComp(data.Item("Success"), "y", vbTextCompare) <> 0 Then
  					
  						message = data.Item("FailReason")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Cancel = oJSON
                        Exit Function
                        
                    Else
                    
                    	
  						
  						With oJSON.data
                            .Item("status") = "ok"                     
                            .Item("message") = "ok"
                            .Add "data", oJSON.Collection()
                            With .Item("data")
                            	
                            	.Add "StoreId" , data.Item("StoreId")
                            	.Add "AdmNo" , data.Item("AdmNo")
                            	.Add "AdmTime" , data.Item("DealTime")
                            	.Add "Code" , data.Item("Code")
                            	.Add "AuthTy" , data.Item("AuthTy")
                            	.Add "SubTy" , data.Item("SubTy")
                            	
                            End With
                            
                        End With
                        Set Cancel = oJSON
                        Exit Function
  					End If
                    
                     
                End If
                ' HP Part end if
            
            
            Case "isp"
        		
        		With oJSON.data
		            .Add "paytype", "card"                     
		        End With
		        
        		' ANSim Card Part Begin
                 
                Set rJson = new aspJSON
                rJson.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/isp.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId & "&type=cancel" & "&admNo=" & AdmNo & "&sendNo=" & SendNo & "&admDt=" & AdmDt & "&NetCancelId=" & cNetCancelId)
                
                me.log rJSon.JSONOutput()

                If rJson.data.Count > 0 Then
                    

                    code = rJson.data.Item("code")
                    If IsEmpty(code) Then
                    	Set Approve = oJSON
                        Exit Function
                    End If
                    
                    If Cint(code) = Cint(400) Then
                        
                        message = rJson.data.Item("message")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Cancel = oJSON
                        Exit Function
  					End If
  					
  					Set data = rJson.data.Item("data")
  					
  					If StrComp(data.Item("Success"), "y", vbTextCompare) <> 0 Then
  					
  						message = data.Item("FailReason")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Cancel = oJSON
                        Exit Function
                        
                    Else
                    
                    	
  						
  						With oJSON.data
                            .Item("status") = "ok"                     
                            .Item("message") = "ok"
                            .Add "data", oJSON.Collection()
                            With .Item("data")
                            	.Add "StoreId" , data.Item("StoreId")
                            	.Add "AdmNo" , data.Item("AdmNo")
                            	.Add "AdmTime" , data.Item("DealTime")
                            	.Add "Code" , data.Item("Code")
                            	.Add "AuthTy" , data.Item("AuthTy")
                            	.Add "SubTy" , data.Item("SubTy")
                            	
                            End With
                            
                        End With
                        Set Cancel = oJSON
                        Exit Function
  					End If
                    
                     
                End If
                ' ISP Part end if 
                
            
            Case "hp"
        		
        		With oJSON.data
		            .Add "paytype", "hp"                     
		        End With
		        
        		' hp Card Part Begin
                 
                Set rJson = new aspJSON
                rJson.loadJSON(C_AGSHOST & "/payment/mobilev2/transaction/phone.jsp?storeID=" & cStrStoreId & "&trackingID=" & cStrTrackingId & "&type=cancel" & "&NetCancelId=" & cNetCancelId)
                
                me.log rJSon.JSONOutput()

                If rJson.data.Count > 0 Then
                    

                    code = rJson.data.Item("code")
                    If IsEmpty(code) Then
                    	Set Approve = oJSON
                        Exit Function
                    End If
                    
                    If Cint(code) = Cint(400) Then
                        
                        message = rJson.data.Item("message")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Cancel = oJSON
                        Exit Function
  					End If
  					
  					Set data = rJson.data.Item("data")
  					
  					If StrComp(data.Item("Success"), "y", vbTextCompare) <> 0 Then
  					
  						message = data.Item("ResMsg")
                        With oJSON.data
                            .Item("status") = "error"                     
                            .Item("message") = message
                        End With
                        Set Cancel = oJSON
                        Exit Function
                        
                    Else
                    
                    	
  						
  						With oJSON.data
                            .Item("status") = "ok"                     
                            .Item("message") = "ok"
                            .Add "data", oJSON.Collection()
                            With .Item("data")
                            	.Add "StoreId" , data.Item("StoreId")
                            	.Add "AdmTID" , data.Item("HpTid")
                            	.Add "AdmTime" , data.Item("AdmTime")
                            	.Add "AuthTy" , data.Item("AuthTy")
                            	.Add "SubTy" , data.Item("SubTy")
                            	
                            End With
                            
                        End With
                        Set Cancel = oJSON
                        Exit Function
  					End If
                    
                     
                End If
                ' hp Part end if 
                
			Case else
				me.log "올바르지 않은 결제 타입입니다"
				With oJSON.data
                    .Item("status") = "error"                     
                    .Item("message") = "올바르지 않은 결제 타입입니다"
                End With
		End Select
		
    End Function
    
    
    Private Sub Class_Terminate()
        If Not cHFileName Is Nothing Then
            cHFileName.Close
            Set cHFileName = Nothing
        End IF
    End Sub

End Class


%>