//
//  FolderView.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

import SnapKit

class FolderView: BaseView {
    
    // MARK: - Enums
    
    enum Sections: String, CaseIterable {
        case pinned = "고정된 메모"
        case unPinned = "메모"
    }
    
    struct Item: Hashable {
        let title: String?
        private let identifier = UUID()
    }
    

    // MARK: - Properties
    
    let collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Sections, Item>!
    

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        configureHierarchy()
        configureDataSource()
    }
    
    override func setConstraints() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}


// MARK: - Compisitional Layout

extension FolderView {
    
    func configureHierarchy() {
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.textProperties.font = .preferredFont(forTextStyle: .body)
            cell.contentConfiguration = content
            
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            
        }
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.textProperties.font = .preferredFont(forTextStyle: .title3)
            cell.contentConfiguration = content

            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.item == 0 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
    }
    
}
