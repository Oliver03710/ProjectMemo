//
//  MemoRepository.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/01.
//

import UIKit

import RealmSwift

protocol MemoRepositoryType {
    func addItem(item: Memo, objectId: ObjectId)
    func fetchMemo() -> Results<Memo>
    func updateStateOfPin(item: Memo)
    func deleteItem(item: Memo)
}

class MemoRepository: MemoRepositoryType {

    let localRealm = try! Realm()
    
    func addItem(item: Memo, objectId: ObjectId) {
        
        do {
            try localRealm.write { localRealm.add(item) }
        } catch let error { print(error) }
        
    }
    
    func fetchMemo() -> Results<Memo> {
        return localRealm.objects(Memo.self).sorted(byKeyPath: "dateRegistered", ascending: false)
    }
    
    func updateStateOfPin(item: Memo) {
        
        do {
            try localRealm.write {
                item.pinned.toggle()
            }
        } catch let error { print(error) }

    }
    
    func deleteItem(item: Memo) {
        
        do {
            try localRealm.write { localRealm.delete(item) }
        } catch let error { print(error) }
        
    }
    
}
