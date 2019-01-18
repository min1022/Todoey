//
//  Category.swift
//  Todoey
//
//  Created by GlobalHumanism on 2019. 1. 16..
//  Copyright © 2019년 GlobalHumanism. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealm: Object {
    
    @objc dynamic var name: String = ""
    
    //List라는 컬렉션 타입(어레이나 딕셔너리같은 컨테이너 타입)에 셋
    let items = List<ItemRealm>()
//    let array = Array<Int>()//빈 배열로 선언 (리스트 아이템 오브젝트를 가리킴)
    //let array : Array<Int> = [1, 2, 3] -> 인티저를 담은 어레이 타입 선언 방법
}

