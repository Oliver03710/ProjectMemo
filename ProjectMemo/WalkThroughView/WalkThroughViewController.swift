//
//  WalkThroughViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import RealmSwift

class WalkThroughViewController: BaseViewController {

    // MARK: - Properties
    
    private let walkThroughView = WalkThroughView()
    
    let subRepository = SubMemoRepository()
    var subTasks: Results<SubMemo>!
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = walkThroughView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc func confirmButtonTapped() {
        let task = SubMemo(executed: true)
        subRepository.addItem(item: task)
        dismiss(animated: true)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        walkThroughView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }

}
