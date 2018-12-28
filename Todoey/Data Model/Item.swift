//
//  Item.swift
//  Todoey
//
//  Created by GlobalHumanism on 2018. 12. 13..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import Foundation

//Encodable : 아이템 타입이 plist나 json 등으로 인코딩 가능하게 함
//Codable : Encode&Decode 프로토콜 합쳐져있음
class Item : Codable/*Encodable, Decodable*/ { //propertyListEncoder() 엔코더블 프로토콜 채택
    
    var title: String = ""
    var done : Bool = false
    //클래스 내 모든 프로퍼티 인코딩 가능하게 하려면 표준 데이터 타입을 꼭 가져야함.
}

