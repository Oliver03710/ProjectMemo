//
//  FolderView.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

class FolderView: BaseView {

    // MARK: - Properties
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return cv
    }()
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Memo>!
    

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    
}
