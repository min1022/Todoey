//
//  AppDelegate.swift
//  Todoey
//
//  Created by GlobalHumanism on 2018. 12. 12..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: CategoryViewController())
        
        do {
            _ = try Realm()
        } catch {
            print("error initializing new realm, \(error)")
        }
        
        //        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String) //데이터 저장 디렉토리 경로 출력
        
        return true
    }
}
