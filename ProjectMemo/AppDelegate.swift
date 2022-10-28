//
//  AppDelegate.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        aboutRealmMigration()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


// MARK: - Extension: Realm Migration

extension AppDelegate {
    func aboutRealmMigration() {
        
        let config = Realm.Configuration(schemaVersion: 4) { migration, oldSchemaVersion in
            
            // Memo Realm의 intro: String? 추가
            if oldSchemaVersion < 1 { }
            
            // SubMemo Realm Table 삭제
            if oldSchemaVersion < 2 { }
            
            // Memo Realm의 intro: String? 삭제 및 photo: String? 추가
            if oldSchemaVersion < 3 { }
            
            // photo 타입 변경: String -> Data
            if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: Memo.className()) { oldObject, newObject in
                    
                    guard let new = newObject, let old = oldObject else { return }
                    
                    new["photo"] = old["photo"]
                    
                    if old["photo"] as? String == "https://images.unsplash.com/photo-1666367167963-7026e9fa8f5d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNTczNjh8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NjY5NTM2ODg&ixlib=rb-4.0.3&q=80&w=200" {
                        new["photo"] = nil
                    }
                    
                }
            }
            
        }
        
        Realm.Configuration.defaultConfiguration = config
    }
}
