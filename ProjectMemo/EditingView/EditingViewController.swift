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
    
    let editingView = EditingView()
    let repository = MemoRepository()
    var tasks: Results<Memo>!
    var indexPath: IndexPath!
    var objectId: ObjectId!
    var backButtonTitle = ""
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = editingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc func shareButtonTapped() {
        
    }
    
    @objc func saveData() {
        let title = splitText(editingView.textView.text).0
        let mainText = splitText(editingView.textView.text).1
        print(mainText)
        guard let id = objectId else {
            if !editingView.textView.text.isEmpty {
                let task = Memo(titleMemo: title, mainMemo: mainText, dateRegistered: Date())
                repository.addItem(item: task, objectId: task.objectId)
                navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.popViewController(animated: true)
            } else {
                navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        if indexPath.section == 0 && tasks[indexPath.row].objectId == id && (tasks[indexPath.row].titleMemo != title || tasks[indexPath.row].mainMemo != mainText) {
            print(indexPath.section, id)
            repository.updateMemo(item: tasks[indexPath.row], title: title, mainText: mainText)
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.popViewController(animated: true)
        } else if indexPath.section == 1 && tasks[indexPath.row].objectId == id && (tasks[indexPath.row].titleMemo != title || tasks[indexPath.row].mainMemo != mainText) {
            repository.updateMemo(item: tasks[indexPath.row], title: title, mainText: mainText)
            print(indexPath.section, id)
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.popViewController(animated: true)
        } else {
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func leftSwipeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.edges == .left && recognizer.state == .began {
            let title = splitText(editingView.textView.text).0
            let mainText = splitText(editingView.textView.text).1
            guard let id = objectId else {
                if !editingView.textView.text.isEmpty {
                    let task = Memo(titleMemo: title, mainMemo: mainText, dateRegistered: Date())
                    repository.addItem(item: task, objectId: task.objectId)
                    navigationController?.navigationBar.prefersLargeTitles = true
                    self.navigationController?.popViewController(animated: true)
                    return
                } else {
                    navigationController?.navigationBar.prefersLargeTitles = true
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            if indexPath.section == 0 && tasks[indexPath.row].objectId == id && (tasks[indexPath.row].titleMemo != title || tasks[indexPath.row].mainMemo != mainText) {
                print(indexPath.section, id)
                repository.updateMemo(item: tasks[indexPath.row], title: title, mainText: mainText)
                navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.popViewController(animated: true)
            } else if indexPath.section == 1 && tasks[indexPath.row].objectId == id && (tasks[indexPath.row].titleMemo != title || tasks[indexPath.row].mainMemo != mainText) {
                repository.updateMemo(item: tasks[indexPath.row], title: title, mainText: mainText)
                print(indexPath.section, id)
                navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.popViewController(animated: true)
            } else {
                navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        configureNavi()
        configueEdgeGesture()
    }
    
    private func configureNavi() {
        showNaviBars(naviTitle: " ", naviBarTintColor: .orange)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.prompt = " "
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveData))
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("\(backButtonTitle)", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: button)
        
        
        navigationItem.rightBarButtonItems = [completionButton, shareButton]
        navigationItem.leftBarButtonItems = [leftBarButton]
    }
    
    private func configueEdgeGesture() {
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftSwipeGesture(_:)))
        edgeGesture.edges = .left
        self.view.addGestureRecognizer(edgeGesture)
    }
    
}
