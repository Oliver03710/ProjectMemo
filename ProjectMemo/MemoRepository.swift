//
//  MemoRepository.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/01.
//

import UIKit

import RealmSwift

enum IsPinned {
    case pinned, unpinned, none
}

private protocol MemoRepositoryType: AnyObject {
    func addItem(item: Memo, objectId: ObjectId)
    func fetchMemo(_ isPinned: IsPinned) -> Results<Memo>
    func updateStateOfPin(item: Memo)
    func updateMemo(item: Memo, title: String, mainText: String?)
    func deleteItem(item: Memo)
}

final class MemoRepository: MemoRepositoryType {

    // MARK: - Properties
    
    static let shared = MemoRepository()
    let localRealm = try! Realm()
    private var tasks: Results<Memo>!
    
    
    // MARK: - Init
    
    private init() { }
    
    
    // MARK: - Helper Functions
    
    func addItem(item: Memo, objectId: ObjectId) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchMemo(_ isPinned: IsPinned) -> Results<Memo> {
        tasks = localRealm.objects(Memo.self).sorted(byKeyPath: "dateRegistered", ascending: false)
        
        switch isPinned {
        case .pinned:
            let pinned = tasks.where { $0.pinned == true }
            return pinned
        case .unpinned:
            let unpinned = tasks.where { $0.pinned == false }
            return unpinned
        case .none:
            return tasks
        }
    }
    
    func updateStateOfPin(item: Memo) {
        do {
            try localRealm.write {
                item.pinned.toggle()
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateMemo(item: Memo, title: String, mainText: String?) {
        do {
            try localRealm.write {
                item.titleMemo = title
                item.mainMemo = mainText
                item.dateRegistered = Date()
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteItem(item: Memo) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
}
