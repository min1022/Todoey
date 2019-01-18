//
//  AppDelegate.swift
//  Todoey
//
//  Created by GlobalHumanism on 2018. 12. 12..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit
import CoreData
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
            let realm = try Realm()
        } catch {
            print("error initializing new realm, \(error)")
        }
        
        //        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String) //데이터 저장 디렉토리 경로 출력
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        print("dideenterBackground")
    }//앱이 스크린에서 사라질때 실행되는 메소드(홈버튼 이동 또는 다른 앱 열었을때)
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    
    //*lazy var : 필요할때 쓰기위해 메모리만 선점해두는 것
    //*NSPersistentContainer : 데이터 저장하는 곳
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext //일시적으로 데이터를 지우고 생성할 수 있는 곳
        if context.hasChanges {
            do {
                try context.save() //일시적 데이터 공간
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}




