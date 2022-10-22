//
//  TotalListView.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

class TotalListView: BaseView {
    
    // MARK: - Properties
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        cv.collectionViewLayout = layout
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
    
    override func configureUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.titleMemo
            content.secondaryText = itemIdentifier.mainMemo
            content.prefersSideBySideTextAndSecondaryText = false
            cell.contentConfiguration = content
        })
    }

    
}
