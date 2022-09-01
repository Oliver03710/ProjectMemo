//
//  WalkThroughViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

class WalkThroughViewController: BaseViewController {

    // MARK: - Properties
    
    private let walkThroughView = WalkThroughView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = walkThroughView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc func confirmButtonTapped() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        walkThroughView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }

}
