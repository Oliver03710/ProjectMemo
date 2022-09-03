//
//  Realm.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/01.
//

import Foundation

import RealmSwift

class Memo: Object {
    @Persisted var titleMemo: String
    @Persisted var mainMemo: String?
    @Persisted var dateRegistered = Date()
    @Persisted var pinned: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(titleMemo: String, mainMemo: String?, dateRegistered: Date) {
        self.init()
        self.titleMemo = titleMemo
        self.mainMemo = mainMemo
        self.dateRegistered = dateRegistered
        self.pinned = false
    }
    
}
