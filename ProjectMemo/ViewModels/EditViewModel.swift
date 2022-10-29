//
//  EditViewModel.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class EditViewModel {
    
    // MARK: - Properties
    
    var memo: Observable<Results<Memo>> = Observable(MemoRepository.shared.fetchMemo(.none))
    var backButtonTitle: Observable<String> = Observable("")
    var isEditing: Observable<Bool> = Observable(false)
    var randomPhoto = PublishSubject<Data>()
    
    
    // MARK: - Helper Functions
    
    func decodeImage() {
        
        guard let request = PhotoManager.shared.setRequest() else { return }
        
        URLSession.request(RandomPhoto.self, endpoint: request) { [weak self] photo, error in
            guard let photo = photo?.urls.thumb, let url = URL(string: photo) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            self?.randomPhoto.onNext(data)
        }
    }
}
