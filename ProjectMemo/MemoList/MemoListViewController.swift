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
    private var searchResults: [String] = []
    
    let repository = MemoRepository()
    let subRepository = SubMemoRepository()
    
    var tasks: Results<Memo>! {
        didSet {
            memoListView.tableView.reloadData()
        }
    }
    var subTasks: Results<SubMemo>!
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = memoListView
    }
    
    override func viewDidLoad() {
        fetchMemo()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMemo()
    }
    
    
    // MARK: - Selectors
    
    @objc func createNewMemo() {
        let vc = EditingViewController()
        transitionViewController(vc, transitionStyle: .push)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        fetchMemo()
        showWalkThrough()
        configureNavi()
        configureTableView()
        configureToolBars()
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
    }
    
    private func configureNavi() {
        
        showNaviBars(naviTitle: "\(0000)개의 메모", naviBarTintColor: .orange)
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
        guard subTasks.isEmpty else { return }
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
        subTasks = subRepository.fetchMemo()
        if !tasks.where({ $0.pinned == true }).isEmpty {
            MemoStatus.pinned = tasks.where({ $0.pinned == true })
        }
        MemoStatus.unPinned = tasks.where({ $0.pinned == false })
    }

}


// MARK: - Extension: UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = UILabel()
        switch subTasks[0].pinnedMemos {
        case 0:
            label.text = "메모"
            label.font = .boldSystemFont(ofSize: 24)
            return label
        case let x where x > 0 && x < 6:
            label.font = .boldSystemFont(ofSize: 24)
            if MemoStatus.unPinned.isEmpty {
                label.text = section == 0 ? "고정된 메모" : ""
            } else {
                label.text = section == 0 ? "고정된 메모" : "메모"
            }
            return label
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditingViewController()
        transitionViewController(vc, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = indexPath
        let pinned = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            switch index.section {
            case 0:
                if !self.tasks.where({ $0.pinned == true }).isEmpty {
                    self.subRepository.pinnedCountIsDecreased(item: self.subTasks[0])
                    self.repository.updateStateOfPin(item: MemoStatus.pinned[index.row])
                } else {
                    self.subRepository.pinnedCountIsIncreased(item: self.subTasks[0])
                    self.repository.updateStateOfPin(item: MemoStatus.unPinned[index.row])
                }
            case 1:
                if MemoStatus.pinned.count >= 5 {
                    self.showAlertMessageWithOnlyConfirm(title: "더 이상 메모를 고정할 수 없습니다! 기존 메모를 삭제 후 고정해주세요.")
                } else {
                    self.subRepository.pinnedCountIsIncreased(item: self.subTasks[0])
                    self.repository.updateStateOfPin(item: MemoStatus.unPinned[index.row])
                }
            default: break
            }
            self.fetchMemo()
            print(self.tasks[index.row].pinned, MemoStatus.pinned.count, MemoStatus.unPinned.count)
            
        }
        
        switch index.section {
        case 0:
            if !tasks.where({ $0.pinned == true }).isEmpty {
                let image = MemoStatus.pinned[index.row].pinned ? "pin.slash.fill" : "pin.fill"
                pinned.image = UIImage(systemName: image)
            } else {
                let image = MemoStatus.unPinned[index.row].pinned ? "pin.slash.fill" : "pin.fill"
                pinned.image = UIImage(systemName: image)
            }
            pinned.backgroundColor = .orange
            return UISwipeActionsConfiguration(actions: [pinned])
        case 1:
            if MemoStatus.pinned.count >= 5 {
                pinned.image = UIImage(systemName: "pin.fill")
            } else {
                let image = MemoStatus.unPinned[index.row].pinned ? "pin.slash.fill" : "pin.fill"
                pinned.image = UIImage(systemName: image)
            }
            pinned.backgroundColor = .orange
            return UISwipeActionsConfiguration(actions: [pinned])
        default:
            let image = self.tasks[index.row].pinned ? "pin.slash.fill" : "pin.fill"
            pinned.image = UIImage(systemName: image)
            pinned.backgroundColor = .orange
            return UISwipeActionsConfiguration(actions: [pinned])
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = indexPath
        let delete = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            switch index.section {
            case 0:
                if !self.tasks.where({ $0.pinned == true }).isEmpty {
                    self.subRepository.pinnedCountIsDecreased(item: self.subTasks[0])
                    self.repository.deleteItem(item: MemoStatus.pinned[index.row])
                } else {
                    self.repository.deleteItem(item: MemoStatus.unPinned[index.row])
                }
            case 1:
                self.repository.deleteItem(item: MemoStatus.unPinned[index.row])
            default: break
            }
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
        if tasks.isEmpty {
            return 0
        } else {
            switch subTasks[0].pinnedMemos {
            case let x where x > 0 && x < 6: return 2
            default: return 1
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch subTasks[0].pinnedMemos {
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
        
        switch indexPath.section {
        case 0:
            if !tasks.where({ $0.pinned == true }).isEmpty {
                cell.setComponents(item: MemoStatus.pinned[indexPath.row])
            } else {
                cell.setComponents(item: MemoStatus.unPinned[indexPath.row])
            }
        case 1:
            cell.setComponents(item: MemoStatus.unPinned[indexPath.row])
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
        searchResults = ["label", "ab", "bc"].filter { $0.lowercased().contains(text) }
    }

}
