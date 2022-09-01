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
    func updateFavourite(item: Memo)
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
    
    func updateFavourite(item: Memo) {

        do {
            try localRealm.write {
                
                // 하나의 레코드에서 특정 컬럼 하나만 변경
                
//                item.favourite.toggle()
                
                // 하나의 테이블에 특정 컬럼 전체를 변경
//                self.tasks.setValue(true, forKey: "favourite")
                
                // 하나의 레코드에서 여러 컬럼들이 변경
//                self.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "contents": "변경 테스트", "diaryTitle": "제목 변경"], update: .modified)
                
                print("Realm Update Succeed, reloadRows 필요")
                
                // 1. 스와이프한 셀 하나만 ReloadRows 코드 구현 -> 상대적 효율성
                // 2. 데이터가 변경되었으니 다시 Realm에서 데이터 가지고 오기 -> didSet으로 일관적 형태로 갱신
            }
        } catch let error { print(error) }

    }
    
    func deleteItem(item: Memo) {
        
        do {
            try localRealm.write { localRealm.delete(item) }
        } catch let error { print(error) }
        
    }
    
}
