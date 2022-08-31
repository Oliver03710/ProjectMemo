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
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {

    }

}
