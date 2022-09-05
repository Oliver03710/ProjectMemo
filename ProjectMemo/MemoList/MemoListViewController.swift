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
    
    let repository = MemoRepository()
    let subRepository = SubMemoRepository()
    
    var tasks: Results<Memo>! {
        didSet {
            memoListView.tableView.reloadData()
        }
    }
    var subTasks: Results<SubMemo>!
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    var textSearched = ""
    var textViewText = ""
    var searchBarIsActive = false
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    
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
        vc.backButtonTitle = navigationItem.title!
        vc.editingView.textView.becomeFirstResponder()
        transitionViewController(vc, transitionStyle: .push)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        showWalkThrough()
        configureNavi()
        configureTableView()
        configureToolBars()
        configureSearchBars()
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
    }
    
    private func configureNavi() {
        guard let numbers = numberFormatter.string(for: tasks.count) else { return }
        showNaviBars(naviTitle: "\(numbers)개의 메모", naviBarTintColor: .orange)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
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

        let createMemoButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNewMemo))

        let arr: [Any] = [flexibleSpace, createMemoButton]

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
    
    func configureSearchBars() {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        let placeholder = "검색창입니다"
        searchController.searchBar.placeholder = placeholder
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
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
        
        if isFiltering {
            switch MemoStatus.searchResults.where({ $0.pinned == true }).count {
            case 0: label.text = MemoStatus.searchResults.isEmpty ? "" : "메모"
            case let x where x > 0 && x < 6:
                if MemoStatus.searchResults.where({ $0.pinned == false }).isEmpty {
                    label.text = section == 0 ? "고정된 메모" : ""
                } else {
                    label.text = section == 0 ? "고정된 메모" : "메모"
                }
            default: break
            }
        } else {
            switch subTasks[0].pinnedMemos {
            case 0: label.text = "메모"
            case let x where x > 0 && x < 6:
                if MemoStatus.unPinned.isEmpty {
                    label.text = section == 0 ? "고정된 메모" : ""
                } else {
                    label.text = section == 0 ? "고정된 메모" : "메모"
                }
            default: break
            }
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditingViewController()
        let index = indexPath
        if isFiltering {
            switch index.section {
            case 0:
                if !MemoStatus.searchResults.where({ $0.pinned == true }).isEmpty {
                    vc.editingView.textView.text = [MemoStatus.searchResults.where({ $0.pinned == true })[index.row].titleMemo, MemoStatus.searchResults.where({ $0.pinned == true })[index.row].mainMemo ?? ""].joined(separator: "\n")
                    vc.objectId = MemoStatus.searchResults.where({ $0.pinned == true })[index.row].objectId
                } else {
                    vc.editingView.textView.text = [MemoStatus.searchResults.where({ $0.pinned == false })[index.row].titleMemo, MemoStatus.searchResults.where({ $0.pinned == false })[index.row].mainMemo ?? ""].joined(separator: "\n")
                    vc.objectId = MemoStatus.searchResults.where({ $0.pinned == false })[index.row].objectId
                }
            case 1:
                vc.editingView.textView.text = [MemoStatus.searchResults.where({ $0.pinned == false })[index.row].titleMemo, MemoStatus.searchResults.where({ $0.pinned == false })[index.row].mainMemo ?? ""].joined(separator: "\n")
                vc.objectId = MemoStatus.searchResults.where({ $0.pinned == false })[index.row].objectId
            default: break
            }
        } else {
            switch index.section {
            case 0:
                if !tasks.where({ $0.pinned == true }).isEmpty {
                    vc.editingView.textView.text = [MemoStatus.pinned[index.row].titleMemo, MemoStatus.pinned[index.row].mainMemo ?? ""].joined(separator: "\n")
                    vc.objectId = MemoStatus.pinned[index.row].objectId
                } else {
                    vc.editingView.textView.text = [MemoStatus.unPinned[index.row].titleMemo, MemoStatus.unPinned[index.row].mainMemo ?? ""].joined(separator: "\n")
                    vc.objectId = MemoStatus.unPinned[index.row].objectId
                }
            case 1:
                vc.editingView.textView.text = [MemoStatus.unPinned[index.row].titleMemo, MemoStatus.unPinned[index.row].mainMemo ?? ""].joined(separator: "\n")
                vc.objectId = MemoStatus.unPinned[index.row].objectId
            default: break
            }
        }
        vc.tasks = tasks
        vc.indexPath = index
        vc.backButtonTitle = searchBarIsActive ? navigationItem.title! : "메모"
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
            
            self.showAlertMessage(title: "정말 삭제하시겠습니까?") {
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
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
        
    }

}


// MARK: - Extension: UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            switch MemoStatus.searchResults.where({ $0.pinned == true }).count {
            case let x where x > 0 && x < 6: return 2
            default: return 1
            }
        } else {
            if tasks.isEmpty {
                return 0
            } else {
                switch subTasks[0].pinnedMemos {
                case let x where x > 0 && x < 6: return 2
                default: return 1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            switch MemoStatus.searchResults.where({ $0.pinned == true }).count {
            case let x where x > 0 && x < 6: return section == 0 ? x : MemoStatus.searchResults.count - x
            default: return MemoStatus.searchResults.count
            }
        } else {
            switch subTasks[0].pinnedMemos {
            case let x where x > 0 && x < 6: return section == 0 ? x : tasks.count - x
            default: return tasks.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        if isFiltering {
            switch indexPath.section {
            case 0:
                if !MemoStatus.searchResults.where({ $0.pinned == true }).isEmpty {
                    isFiltering ? cell.isFilteringSetComponents(item: MemoStatus.searchResults.where({ $0.pinned == true })[indexPath.row], textSearched: self.textSearched) : cell.setComponents(item: MemoStatus.searchResults.where({ $0.pinned == true })[indexPath.row])
                } else {
                    isFiltering ? cell.isFilteringSetComponents(item: MemoStatus.searchResults.where({ $0.pinned == false })[indexPath.row], textSearched: self.textSearched) : cell.setComponents(item: MemoStatus.searchResults.where({ $0.pinned == false })[indexPath.row])
                }
            case 1:
                isFiltering ? cell.isFilteringSetComponents(item: MemoStatus.searchResults.where({ $0.pinned == false })[indexPath.row], textSearched: self.textSearched) : cell.setComponents(item: MemoStatus.searchResults.where({ $0.pinned == false })[indexPath.row])
            default: break
            }
            
            return cell
            
        } else {
            
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


// MARK: - Extension: UISearchResultsUpdating

extension MemoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
            MemoStatus.searchResults = tasks.where { $0.titleMemo.contains(text, options: .caseInsensitive) || $0.mainMemo.contains(text, options: .caseInsensitive) }
        
        textSearched = text
        guard let numbers = numberFormatter.string(for: tasks.count) else { return }
        self.navigationItem.title = searchController.isActive ? "검색" : "\(numbers)개의 메모"
        searchBarIsActive = searchController.isActive
        self.memoListView.tableView.reloadData()
        
    }

}
