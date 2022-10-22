//
//  TotalListViewModel.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import Foundation

import RealmSwift

final class TotalListViewModel {
    
    // MARK: - Properties
    
    var memo: Observable<Results<Memo>> = Observable(MemoRepository.shared.fetchMemo(.none))
    
    
    // MARK: - Helper Functions
    
}

