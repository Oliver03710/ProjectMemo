//
//  EditingViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import RealmSwift

final class EditingViewController: BaseViewController {

    // MARK: - Properties
    
    private let editingView = EditingView()
    var list:[String.SubSequence] = []
    let repository = MemoRepository()
    
    var tasks: Results<Memo>!
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = editingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            guard let text = editingView.textView.text else { return }
            let lines = text.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
            list = lines
            print(list)
            let str = list.joined(separator: "\n")
            print(str)
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func shareButtonTapped() {
        
    }
    
    @objc func completionButtonTapped() {
        guard let text = editingView.textView.text else { return }
        let lines = text.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
        list = lines
        guard let firstElement = list.first else { return }
        print(firstElement)
        print(list[0])
        let str = list.joined(separator: "\n")
        print(str)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        configureNavi()
    }
    
    private func configureNavi() {
        showNaviBars(naviTitle: " ", naviBarTintColor: .orange)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.prompt = " "
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonTapped))
        
        navigationItem.rightBarButtonItems = [completionButton, shareButton]
    }

}
