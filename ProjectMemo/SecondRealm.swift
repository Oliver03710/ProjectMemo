//
//  SecondRealm.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/02.
//

import Foundation

import RealmSwift

class SubMemo: Object {
    @Persisted var executed: Bool
    @Persisted var pinnedMemos: Int
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(executed: Bool) {
        self.init()
        self.executed = executed
        self.pinnedMemos = 0
    }
    
}
