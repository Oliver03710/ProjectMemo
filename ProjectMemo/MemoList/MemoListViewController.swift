//
//  MemoListViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

final class MemoListViewController: BaseViewController {

    // MARK: - Properties
    
    private let memoListView = MemoListView()
    private let searchController = SearchViewController(searchResultsController: nil)
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = memoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Seleectors
    
    @objc func testing() {
        let vc = WalkThroughViewController()
        transitionViewController(vc, transitionStyle: .presentOverFullScreen)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        configureNavi()
        configureTableView()
    }
    
    private func configureNavi() {
        
        showNaviBars(naviTitle: "메모", naviBarTintColor: .systemBackground)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        let button = UIBarButtonItem(image: UIImage(systemName: "applelogo"), style: .plain, target: self, action: #selector(testing))
        navigationItem.rightBarButtonItems = [button]
    }
    
    private func configureTableView() {
        memoListView.tableView.dataSource = self
        memoListView.tableView.delegate = self
    }

}


// MARK: - Extension: UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = UILabel()
        label.text = section == 0 ? "고정된 메모" : "메모"
        label.textColor = .orange
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }
}


// MARK: - Extension: UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
