#AGSMobile-for-Rails
이지스엔터프라이즈(주)에서 제공하는 __AllTheGate 모바일 결제모듈__(AGSMobile V2.0)은 asp, jsp, php 라이브러리만 제공합니다.
Rails 프레임워크에서 사용할 수 있게 라이브러리를 Ruby 언어로 제작하였습니다.

__AGSMobile_2.0 디렉터리__에는 이즈스엔터프라이즈(주)에서 제공하는 모바일 결제 연동 설명서 및 샘플들이 들어가 있습니다.
기본적인 흐름은 문서를 통해 참고하세요.


##Current status
현재 __카드결제(ISP 안전결제, 안심클릭) 기능만 구현__되어 있습니다. 휴대폰 결제, 가상계좌(무통장입금), 결제취소 기능은 미구현 상태입니다. Contribution 환영합니다.


##Getting started
이 문서는 Rails 4.0 기준으로 작성되었습니다.

1. __agsmobile.rb__ 파일을 작업 중인 Rails 프로젝트의 __lib 디렉터리__ 아래에 둡니다.

2. 해당 Controller 에서 agsmobile.rb 를 require 한 후 아래 create action의 예제처럼 작업을 진행하면 됩니다.


```ruby
class OrdersController < ApplicationController
  require 'agsmobile.rb'
  
  def create
    tracking_id = params[:tracking_id]
    transaction = params[:transaction]
    store_id = params[:StoreId] || "aegis"
    
    agsMobile = AGSMobile.new(store_id, tracking_id, transaction)
    agsMobile.setLogging(true)
    
    original = agsMobile.getTrackingInfo
    ret = agsMobile.approve
    
    if ret['status'] == "ok"
      if ret['paytype'] == "card"
        # price = ret['data']['Amt']
        # dealno = ret['data']['DealNo']
        # ...
      end
    end
    
  end
end
```

`store_id = params[:StoreId] || "aegis"` 에서의 "aegis"에 해당 상점의 ID를 입력하시면 됩니다. 테스트 시에는 그대로 "aegis"를 입력하고 진행하면 됩니다.

`original = agsMobile.getTrackingInfo`에서의 `gettrackingInfo()`는 최초 올더게이트 페이지를 호출할 때 전달 했던 Form 값들이 Hash로 반환합니다.

`ret = agsMobile.approve` 에서의 `approve()`는 결제통신 작업 후 응답 정보들이 Hash로 반환됩니다. 응답 필드 정보는 AllTheGate 모바일 결제 연동 설명서 20페이지를 참고하세요.


##How to contribute
[CONTRIBUTING](/CONTRIBUTING.md) 파일을 참고해주시기 바랍니다.

##License
MIT License. Copyright 2015 D20K.
