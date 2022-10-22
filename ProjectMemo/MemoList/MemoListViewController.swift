//
//  MemoListViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import RealmSwift

final class MemoListViewController: BaseViewController {

    // MARK: - Properties
    
    private let memoListView = MemoListView()
    
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    let viewModel = MemoListViewModel()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = memoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc func createNewMemo() {
        let vc = EditingViewController()
        vc.viewModel.backButtonTitle.value = navigationItem.title!
        vc.editingView.textView.becomeFirstResponder()
        transitionViewController(vc, transitionStyle: .push)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        showWalkThrough()
        configureNavi(memoListView.numberFormatter)
        setTableViewDelegates(memoListView.tableView)
        configureToolBars()
        configureSearchBars()
        viewModel.aboutRealm()
        bindData()
    }
    
    private func bindData() {
        viewModel.memo.bind { _ in
            self.memoListView.tableView.reloadData()
        }
        
        viewModel.searchResults.bind { _ in
            self.memoListView.tableView.reloadData()
        }
    }
    
    private func setTableViewDelegates(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func showWalkThrough() {
        guard !UserdefaultsHelper.standard.isExecuted else { return }
        let vc = WalkThroughViewController()
        transitionViewController(vc, transitionStyle: .presentOverFullScreen)
    }
    
    private func configureNavi(_ nf: NumberFormatter) {
        guard let numbers = nf.string(for: viewModel.memo.value) else { return }
        showNaviBars(naviTitle: "\(numbers)개의 메모", naviBarTintColor: .orange)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBars() {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        let placeholder = "검색창입니다"
        searchController.searchBar.placeholder = placeholder
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
    }
    
    private func configureToolBars() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .orange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let createMemoButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNewMemo))
        
        let arr: [Any] = [flexibleSpace, createMemoButton]
        
        setToolbarItems(arr as? [UIBarButtonItem] ?? [UIBarButtonItem](), animated: true)
    }
}


// MARK: - Extension: UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        
        let tasks = isFiltering ? viewModel.searchResults.value : viewModel.memo.value
        
        switch tasks.where({ $0.pinned == true }).count {
        case 0:
            label.text = isFiltering ? (tasks.isEmpty ? "" : "메모") : "메모"
            
        case let x where x > 0 && x < 6:
            if tasks.where({ $0.pinned == false }).isEmpty {
                label.text = section == 0 ? "고정된 메모" : ""
            } else {
                label.text = section == 0 ? "고정된 메모" : "메모"
            }
            
        default: break
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditingViewController()
        
        let tasks = isFiltering ? viewModel.searchResults.value : viewModel.memo.value
        
        switch indexPath.section {
        case 0:
            if tasks.where({ $0.pinned == true }).isEmpty {
                vc.editingView.textView.text =
                [tasks.where({ $0.pinned == false })[indexPath.row].titleMemo, tasks.where({ $0.pinned == false })[indexPath.row].mainMemo ?? ""].joined(separator: "\n")
                vc.objectId = tasks.where({ $0.pinned == false })[indexPath.row].objectId
                
            } else {
                vc.editingView.textView.text =
                [tasks.where({ $0.pinned == true })[indexPath.row].titleMemo, tasks.where({ $0.pinned == true })[indexPath.row].mainMemo ?? ""].joined(separator: "\n")
                vc.objectId = tasks.where({ $0.pinned == true })[indexPath.row].objectId
            }
            
        case 1:
            vc.editingView.textView.text =
            [tasks.where({ $0.pinned == false })[indexPath.row].titleMemo, tasks.where({ $0.pinned == false })[indexPath.row].mainMemo ?? ""].joined(separator: "\n")
            vc.objectId = tasks.where({ $0.pinned == false })[indexPath.row].objectId
            
        default: break
        }
        
        vc.indexPath = indexPath
        vc.viewModel.backButtonTitle.value = viewModel.searchBarIsActive.value ? navigationItem.title! : "메모"
        transitionViewController(vc, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let tasks = isFiltering ? viewModel.searchResults.value : viewModel.memo.value
        
        let pinned = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            switch indexPath.section {
            case 0:
                MemoRepository.shared.updateStateOfPin(item: tasks.where({ $0.pinned == true }).isEmpty ? tasks.where({ $0.pinned == false })[indexPath.row] : tasks.where({ $0.pinned == true })[indexPath.row])
                
            case 1:
                tasks.where({ $0.pinned == true }).count >= 5 ? self.showAlertMessageWithOnlyConfirm(title: "더 이상 메모를 고정할 수 없습니다! 기존 메모를 삭제 후 고정해주세요.") : MemoRepository.shared.updateStateOfPin(item: tasks.where({ $0.pinned == false })[indexPath.row])
                
            default: break
            }
            self.viewModel.memo.value = MemoRepository.shared.fetchMemo(.none)
        }
        
        switch indexPath.section {
        case 0:
            
            if tasks.where({ $0.pinned == true }).isEmpty {
                let image = tasks.where({ $0.pinned == false })[indexPath.row].pinned ? "pin.slash.fill" : "pin.fill"
                pinned.image = UIImage(systemName: image)
            } else {
                let image = tasks.where({ $0.pinned == true })[indexPath.row].pinned ? "pin.slash.fill" : "pin.fill"
                pinned.image = UIImage(systemName: image)
            }
            
        case 1:
            
            if tasks.where({ $0.pinned == true }).count >= 5 {
                pinned.image = UIImage(systemName: "pin.fill")
            } else {
                let image = tasks.where({ $0.pinned == false })[indexPath.row].pinned ? "pin.slash.fill" : "pin.fill"
                pinned.image = UIImage(systemName: image)
            }
            
        default: break
            
        }
        
        pinned.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [pinned])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let tasks = isFiltering ? viewModel.searchResults.value : viewModel.memo.value
        
        let delete = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            self.showAlertMessage(title: "정말 삭제하시겠습니까?") {
                switch indexPath.section {
                case 0:
                    MemoRepository.shared.deleteItem(item: tasks.where({ $0.pinned == true }).isEmpty ? tasks.where({ $0.pinned == false })[indexPath.row] : tasks.where({ $0.pinned == true })[indexPath.row])
                    
                case 1:
                    MemoRepository.shared.deleteItem(item: tasks.where({ $0.pinned == false })[indexPath.row])
                    
                default: break
                }
                self.viewModel.memo.value = MemoRepository.shared.fetchMemo(.none)
            }
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
        
    }

}


// MARK: - Extension: UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let tasks = isFiltering ? viewModel.searchResults.value : viewModel.memo.value
        
        if viewModel.memo.value.isEmpty {
            return 0
            
        } else {
            switch tasks.where({ $0.pinned == true }).count {
            case let x where x > 0 && x < 6: return 2
            default: return 1
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tasks = isFiltering ? viewModel.searchResults.value : viewModel.memo.value
        
        switch tasks.where({ $0.pinned == true }).count {
        case let x where x > 0 && x < 6: return section == 0 ? x : tasks.count - x
        default: return tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        let tasks = isFiltering ? viewModel.searchResults.value : viewModel.memo.value
        
        switch indexPath.section {
        case 0:
            cell.setComponents(item: tasks.where({ tasks.where({ $0.pinned == true }).isEmpty ? ($0.pinned == false) : ($0.pinned == true) })[indexPath.row], textSearched: viewModel.textSearched.value, isFlitering: isFiltering)
        case 1:
            cell.setComponents(item: tasks.where({ $0.pinned == false })[indexPath.row], textSearched: viewModel.textSearched.value, isFlitering: isFiltering)
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


// MARK: - Extension: UISearchResultsUpdating

extension MemoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        viewModel.searchResults.value = viewModel.memo.value.where {
            $0.titleMemo.contains(text, options: .caseInsensitive) || $0.mainMemo.contains(text, options: .caseInsensitive)
        }
        
        viewModel.textSearched.value = text
        guard let numbers = memoListView.numberFormatter.string(for: viewModel.memo.value.count) else { return }
        navigationItem.title = searchController.isActive ? "검색" : "\(numbers)개의 메모"
        viewModel.searchBarIsActive.value = searchController.isActive
    }

}
