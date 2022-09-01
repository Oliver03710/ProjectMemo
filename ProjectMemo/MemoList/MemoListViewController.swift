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
    private let searchController = SearchViewController(searchResultsController: nil)
    private var searchResults:[String] = []
    let repository = MemoRepository()
    var tasks: Results<Memo>! {
        didSet {
            memoListView.tableView.reloadData()
        }
    }
    
    
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
        transitionViewController(vc, transitionStyle: .push)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        configureNavi()
        configureTableView()
        configureToolBars()
        fetchMemo()
        countPinnedItems()
    }
    
    private func configureNavi() {
        
        showNaviBars(naviTitle: "메모", naviBarTintColor: .orange)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        memoListView.tableView.dataSource = self
        memoListView.tableView.delegate = self
    }
    
    func showWalkThrough() {
        let vc = WalkThroughViewController()
        transitionViewController(vc, transitionStyle: .presentOverFullScreen)
    }
    
    func configureToolBars() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .orange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

        let loveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNewMemo))

        let arr: [Any] = [flexibleSpace, loveButton]

        setToolbarItems(arr as? [UIBarButtonItem] ?? [UIBarButtonItem](), animated: true)
    }
    
    func fetchMemo() {
        tasks = repository.fetchMemo()
    }
    
    func countPinnedItems() {
        tasks.forEach { if $0.pinned { repository.PinnedItemCount += 1 } }
    }

}


// MARK: - Extension: UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = UILabel()
        switch repository.PinnedItemCount {
        case 0:
            label.text = "메모"
            label.font = .boldSystemFont(ofSize: 24)
            return label
        case let x where x > 0 && x < 6:
            label.text = section == 0 ? "고정된 메모" : "메모"
            label.font = .boldSystemFont(ofSize: 24)
            return label
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditingViewController()
        transitionViewController(vc, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pinned = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            if self.repository.PinnedItemCount > 5 {
                self.showAlertMessageWithOnlyConfirm(title: "더 이상 메모를 고정할 수 없습니다! 기존 메모를 삭제 후 고정해주세요.")
            } else {
                self.repository.updateStateOfPin(item: self.tasks[indexPath.row])
                self.repository.PinnedItemCount += self.tasks[indexPath.row].pinned ? 1 : -1
                self.fetchMemo()
            }
        }
        
        let image = indexPath.row % 2 == 0 ? "pin.slash.fill" : "pin.fill"
        pinned.image = UIImage(systemName: image)
        pinned.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [pinned])
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            self.repository.deleteItem(item: self.tasks[indexPath.row])
            self.repository.PinnedItemCount += self.tasks[indexPath.row].pinned ? 0 : -1
            self.fetchMemo()
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
        
    }

}


// MARK: - Extension: UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch repository.PinnedItemCount {
        case let x where x > 0 && x < 6: return 2
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch repository.PinnedItemCount {
        case let x where x > 0 && x < 6:
            if section == 0 {
                return x
            } else {
                return tasks.count - x
            }
        default: return tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        cell.setComponents(item: tasks[indexPath.row])
        
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
        searchResults = ["label", "ab", "bc"].filter { $0.lowercased().contains(text) }
    }

}
