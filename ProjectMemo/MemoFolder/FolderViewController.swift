//
//  FolderViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

class FolderViewController: BaseViewController {

    // MARK: - Properties
    
    private let folderView = FolderView()
    private let viewModel = TotalListViewModel()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = folderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setCollectionViewDelegate()
    }
    
    private func setCollectionViewDelegate() {
        folderView.collectionView.delegate = self
        folderView.collectionView.dataSource = self
    }
}


// MARK: - Extension: UICollectionViewDelegate

extension FolderViewController: UICollectionViewDelegate {
    
}


// MARK: - Extension: UICollectionViewDataSource

extension FolderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.memo.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.memo.value[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: folderView.cellRegistration, for: indexPath, item: item)
        
        return cell
    }
    
}
