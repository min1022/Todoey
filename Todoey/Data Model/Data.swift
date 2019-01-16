//
//  Data.swift
//  Todoey
//
//  Created by GlobalHumanism on 2019. 1. 16..
//  Copyright © 2019년 GlobalHumanism. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    //dynamic은 선언 모디파이어 다이내믹 디스패치를 스테틱 디스패치 기준을 넘는 것을 허용
    //모니터링되는 프로퍼티를 실행 시간에 바뀔 수 있도록 허용
    //앱이 실행 중일시 사용자가 name의 값을 바꿀때
    @objc dynamic var name : String = ""
    var age : Int = 0
}
