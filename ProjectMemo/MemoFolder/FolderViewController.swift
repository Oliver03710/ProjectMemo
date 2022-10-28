//
//  FolderViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

import RealmSwift

final class FolderViewController: BaseViewController {

    // MARK: - Properties
    
    private let folderView = FolderView()
    private let viewModel = FolderViewModel()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = folderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.memo.value = MemoRepository.shared.fetchMemo(.none)
    }
    
    
    // MARK: - Selectors
    
    @objc func toMemos() {
        let vc = MemoListViewController()
        transitionViewController(vc, transitionStyle: .push)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        bindData()
        configureNavi()
    }
    
    private func bindData() {
        viewModel.memo.bind { [weak self] memo in
            let pinned = memo.where { $0.pinned == true }.toArray()
            let unPinned = memo.where { $0.pinned == false }.toArray()
            
            var snapshot = NSDiffableDataSourceSnapshot<FolderView.Sections, FolderView.Item>()
            let sections = FolderView.Sections.allCases
            snapshot.appendSections(sections)
            self?.folderView.dataSource.apply(snapshot, animatingDifferences: false)
            for section in sections {
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<FolderView.Item>()
                let headerItem = FolderView.Item(title: "\(section.rawValue)")
                sectionSnapshot.append([headerItem])
                let items = section == .pinned ? pinned.map { FolderView.Item(title: "\($0.titleMemo)") } : unPinned.map { FolderView.Item(title: "\($0.titleMemo)") }
                sectionSnapshot.append(items, to: headerItem)
                sectionSnapshot.expand([headerItem])
                self?.folderView.dataSource.apply(sectionSnapshot, to: section)
            }
        }
    }
    
    private func configureNavi() {
        
        showNaviBars(naviTitle: "메모 폴더", naviBarTintColor: .orange)
        
        let transitionButton = UIBarButtonItem(title: "메모보기", style: .plain, target: self, action: #selector(toMemos))
        
        navigationItem.rightBarButtonItem = transitionButton
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.prompt = " "
    }
}
