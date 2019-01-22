//
//  ItemRealm.swift
//  Todoey
//
//  Created by GlobalHumanism on 2019. 1. 16..
//  Copyright © 2019년 GlobalHumanism. All rights reserved.
//

import Foundation
import RealmSwift

class ItemRealm: Object {
    //realmㅇ로 프로퍼티를 생성하려면 objective-c modifier(@objc) dynamic을 앞에 추가
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //LinkingObjects : 자동 업데이팅 컨테이너
    var parentCategory = LinkingObjects(fromType: CategoryRealm.self, property: "items") //relates with let items = List<ItemRealm>()
    //각 아이템은 카테고리 타입의 패런트 카테고리가 있고 그것은 items라는 프로퍼티로부터 온다
    
}
