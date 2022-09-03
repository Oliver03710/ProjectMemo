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
    let repository = MemoRepository()
    
    
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
            let title = splitText(editingView.textView.text).0
            let mainText = splitText(editingView.textView.text).1
            
            let task = Memo(titleMemo: title, mainMemo: mainText, dateRegistered: Date())
            repository.addItem(item: task, objectId: task.objectId)
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func shareButtonTapped() {
        
    }
    
    @objc func completionButtonTapped() {
        let title = splitText(editingView.textView.text).0
        let mainText = splitText(editingView.textView.text).1
        
        let task = Memo(titleMemo: title, mainMemo: mainText, dateRegistered: Date())
        repository.addItem(item: task, objectId: task.objectId)
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
