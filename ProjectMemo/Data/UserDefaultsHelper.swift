//
//  UserDefaultsHelper.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import Foundation

final class UserdefaultsHelper {
    
    private init() { }
    
    static let standard = UserdefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    private enum Key: String {
        case isExecuted
    }
    
    var isExecuted: Bool {
        get {
            return userDefaults.bool(forKey: Key.isExecuted.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.isExecuted.rawValue)
        }
    }
    
    func removeAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: appDomain)
        }
    }
    
}
