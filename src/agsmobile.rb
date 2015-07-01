require 'open-uri'
require 'json'
$AGSHOST = 'https://www.allthegate.com'

class AGSMobile
	@@tracking_id = ""
	@@transaction = ""
	@@store_id = ""
	@@tracking_info = ""
	@@logging = false
	@@logfile = nil
	@@log_path = nil
	@@ispCardNm = ""
	@@netCancelId = ""

	def initialize(*args)
		@@store_id = args[0]
		@@tracking_id = args[1]
		@@transaction = args[2]
		@@log_path = args[3]
		@@tracking_info = callApi("#{$AGSHOST}/payment/mobilev2/transaction/tracking.jsp",
			{'storeID' => @@store_id, 'trackingID' => @@tracking_id})
		log(@@tracking_info)
		@@tracking_info = JSON.parse(@@tracking_info)
	end

	def setLogging(b)
		@@logging = b
	end

	def log(str)
		if @@logging
			logfile = "log/agsmobile_#{Time.now.strftime("%Y%m%d")}.log"
			@@logfile = File.open(logfile, "a+")
			str = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}==>#{str}"
			@@logfile.puts(str)
		else
			@@logfile.close if @@logfile
		end
	end

	def getTrackingInfo
		@@tracking_info
	end

	def callApi(url, params)
		query = ""
		params.each { |key, value| query += "#{key}=#{value}&" }
		nurl = "#{url}?#{query}"
		log(nurl)
		open(nurl).read
	end

	def approve
		ret = {"status" => "error", "message" => "알 수 없는 에러"}
		data = Array.new

		case @@transaction
		when "virtual"
			# TODO
		when "hp"
			# TODO
		when "kmpi", "ansim", "xansim"
			ret['paytype'] = 'card'
			html = callApi("#{$AGSHOST}/payment/mobilev2/transaction/ansim.jsp",
				{"storeID" => @@store_id, "trackingID" => @@tracking_id, "type" => "approve"})
			log(html)
			if html
				json = JSON.parse(html)
			end

			if json['code'] == '400'
				ret['message'] = json['message']
				ret['status'] = 'error'
				return ret
			end

			json = json['data']

			if json['Success'] == 'y'
				ret['status'] = 'ok'
				ret['message'] = 'ok'
				@@netCancelId = json['NetCancelId']
				ret['data'] = {
					# 아래는 전 승인 공통..
					"AuthTy" => json['AuthTy'],
                    "SubTy" => json['SubTy'],               
                    
                    "NetCancelId" => json['NetCancelId'],
                    "StoreId" => json['StoreId'],               
                    "OrdNo" => json['OrdNo'],
                    "Amt" => json['Amt'],
                    "EscrowYn" => json['EscrowYn'],
                    "NoInt" => json['DeviId'] == "9000400002" ? "y" : "n",
                    "EscrowSendNo" => json['EscrowSendNo'],
                    
                    "BusiCd" => json['Code'],     	# 전문코드
                    "AdmNo" => json['AdmNo'],     	# 승인번호
                    "AdmTime" => json['AdmTime'], 	# 승인시각
                    "CardCd" => json['CardType'], 	# 카드사코드
                    "CardNm" => json['CardName'], 	# 카드사명
                    "DealNo" => json['SendNo'],   	# 거래번호
                    "PartialMm" => json["CardPartialMm"]  
				}
			else
				ret['status'] = 'error'
				ret['message'] = json['FailReason']
				ret['data'] = nil
			end
		when "isp"
			ret['paytype'] = 'card'
			html = callApi("#{$AGSHOST}/payment/mobilev2/transaction/isp.jsp",
				{"storeID" => @@store_id, "trackingID" => @@tracking_id, "type" => "approve"})
			log(html)

			if html
				json = JSON.parse(html)

				return ret if json['code'].nil?

				if json['code'] == '400'
					ret['message'] = json['message']
					ret['status'] = 'error'
					return ret
				end

				json = json['data']

				if json['Success'] == 'y'
					ret['status'] = 'ok'
					ret['message'] = 'ok'
					@@netCancelId = json['NetCancelId']
					ret['data'] = {
						# 아래는 전 승인 공통..
						"AuthTy" => json['AuthTy'],
                        "SubTy" => json['SubTy'],               
                        
                        "NetCancelId" => json['NetCancelId'],
                        "StoreId" => json['StoreId'],               
                        "OrdNo" => json['OrdNo'],
                        "Amt" => json['Amt'],
                        "EscrowYn" => json['EscrowYn'],
                        "NoInt" => json['DeviId'] == "9000400002" ? "y" : "n",
                        "EscrowSendNo" => json['EscrowSendNo'],
                        
                        "BusiCd" => json['Code'],     	# 전문코드
                        "AdmNo" => json['AdmNo'],     	# 승인번호
                        "AdmTime" => json['AdmTime'], 	# 승인시각
                        "CardCd" => json['CardType'], 	# 카드사코드
                        "CardNm" => json['CardName'], 	# 카드사명
                        "DealNo" => json['SendNo'],   	# 거래번호
                        "PartialMm" => json["CardPartialMm"]  
					}
				else
					ret['status'] = 'error'
					ret['message'] = json['FailReason']
					ret['data'] = nil
				end

			end
		else
			# type default
			log("결제 타입이 잘 못 되었습니다.#{@@transaction}")
			ret["message"] = "결제 타입 에러"
			ret["status"] = "error"
		end

		@@logfile.close if @@logfile
		ret
	end

	def forceCancel
		cancel("", "", "", @@netCancelId)
	end

	def cancel(admNo, admDt, sendNo, netCancelID = "")
		ret = {"status" => "error", "message" => "알 수 없는 에러"}
		data = Array.new

		case @@transaction
		when "kmpi", "ansim", "xansim"
			# TODO
		when "isp"
			# TODO
		when "hp"
			# TODO
		else
			# type default
			log("취소 타입이 잘 못 되었습니다.")
            ret["message"] = "취소 타입 에러"
            ret["status"] = "error"
		end

		ret
	end
end