//
//  TotalListViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

final class TotalListViewController: BaseViewController {

    // MARK: - Properties
    
    private let totalListView = TotalListView()
    private let viewModel = TotalListViewModel()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = totalListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setCollectionViewDelegate()
    }
    
    private func setCollectionViewDelegate() {
        totalListView.collectionView.delegate = self
        totalListView.collectionView.dataSource = self
    }

}


// MARK: - Extension: UICollectionViewDelegate

extension TotalListViewController: UICollectionViewDelegate {
    
}


// MARK: - Extension: UICollectionViewDataSource

extension TotalListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.memo.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.memo.value[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: totalListView.cellRegistration, for: indexPath, item: item)
        
        return cell
    }
}

