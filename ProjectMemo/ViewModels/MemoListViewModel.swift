//
//  MemoListViewModel.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import Foundation

import RealmSwift

final class MemoListViewModel {
    
    // MARK: - Properties
    
    var memo: Observable<Results<Memo>> = Observable(MemoRepository.shared.fetchMemo(.none))
    var searchResults: Observable<Results<Memo>> = Observable(MemoRepository.shared.fetchMemo(.none))
    
    var textSearched: Observable<String> = Observable("")
    var textViewText: Observable<String> = Observable("")
    var searchBarIsActive: Observable<Bool> = Observable(false)
    

    // MARK: - Helper Functions
    
    func aboutRealm() {
        print("Realm is located at:", MemoRepository.shared.localRealm.configuration.fileURL!)
        
        do {
            let version = try schemaVersionAtURL(MemoRepository.shared.localRealm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
}
