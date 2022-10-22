//
//  UserDefaultsHelper.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import Foundation

final class UserdefaultsHelper {
    
    // MARK: - Enum
    
    private enum Key: String {
        case isExecuted
    }
    
    
    // MARK: - Properties
    
    static let standard = UserdefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    var isExecuted: Bool {
        get {
            return userDefaults.bool(forKey: Key.isExecuted.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.isExecuted.rawValue)
        }
    }
    
    
    // MARK: - Init
    
    private init() { }
    
    
    // MARK: - Helper Functions
    
    func removeAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: appDomain)
        }
    }
    
}
