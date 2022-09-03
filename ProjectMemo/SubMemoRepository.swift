//
//  SubMemoRepository.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/02.
//

import Foundation

import RealmSwift

protocol SubMemoRepositoryType {
    func addItem(item: SubMemo)
    func deleteItem(item: SubMemo)
    func pinnedCountIsIncreased(item: SubMemo)
    func pinnedCountIsDecreased(item: SubMemo)
    func fetchMemo() -> Results<SubMemo>
}

class SubMemoRepository: SubMemoRepositoryType {

    let localRealm = try! Realm()
    
    func addItem(item: SubMemo) {
        
        do {
            try localRealm.write { localRealm.add(item) }
        } catch let error { print(error) }
        
    }
    
    func deleteItem(item: SubMemo) {
        
        do {
            try localRealm.write { localRealm.delete(item) }
        } catch let error { print(error) }
        
    }
    
    func pinnedCountIsIncreased(item: SubMemo) {
        
        do {
            try localRealm.write { item.pinnedMemos += 1 }
        } catch let error { print(error) }

    }
    
    func pinnedCountIsDecreased(item: SubMemo) {
        
        do {
            try localRealm.write { item.pinnedMemos -= 1 }
        } catch let error { print(error) }

    }
    
    func fetchMemo() -> Results<SubMemo> {
        return localRealm.objects(SubMemo.self)
    }
    
}
