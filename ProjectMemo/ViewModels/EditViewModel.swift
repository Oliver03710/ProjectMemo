//
//  EditViewModel.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import Foundation

import RealmSwift

final class EditViewModel {
    
    // MARK: - Properties
    
    var memo: Observable<Results<Memo>> = Observable(MemoRepository.shared.fetchMemo(.none))
    var backButtonTitle: Observable<String> = Observable("")
    var isEditing: Observable<Bool> = Observable(false)
    
    
    // MARK: - Helper Functions
    


}
