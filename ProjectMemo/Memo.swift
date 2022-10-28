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
    @Persisted var photo: String?
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(titleMemo: String, mainMemo: String?, dateRegistered: Date, photo: String?) {
        self.init()
        self.titleMemo = titleMemo
        self.mainMemo = mainMemo
        self.dateRegistered = dateRegistered
        self.photo = photo
        self.pinned = false
    }
    
}
