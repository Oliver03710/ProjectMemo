//
//  EditingViewController.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import RealmSwift
import Toast

final class EditingViewController: BaseViewController {

    // MARK: - Properties
    
    let editingView = EditingView()
    let viewModel = EditViewModel()
    var indexPath: IndexPath?
    var objectId: ObjectId?
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = editingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc func shareButtonTapped() {
        let title = splitText(editingView.textView.text).0
        let mainText = splitText(editingView.textView.text).1
        
        guard let id = objectId, let indexPath = indexPath else {
            if viewModel.isEditing.value {
                let task = Memo(titleMemo: title, mainMemo: mainText, dateRegistered: Date(), photo: nil)
                MemoRepository.shared.addItem(item: task, objectId: task.objectId)
                showActivityViewController(editingView.textView.text)
                return
            }
            return
        }
        
        if indexPath.section == 0 && viewModel.memo.value[indexPath.row].objectId == id && (viewModel.memo.value[indexPath.row].titleMemo != title || viewModel.memo.value[indexPath.row].mainMemo != mainText) {
            
            MemoRepository.shared.updateMemo(item: viewModel.memo.value[indexPath.row], title: title, mainText: mainText)
            
        } else if indexPath.section == 1 && viewModel.memo.value[indexPath.row].objectId == id && (viewModel.memo.value[indexPath.row].titleMemo != title || viewModel.memo.value[indexPath.row].mainMemo != mainText) {
            
            MemoRepository.shared.updateMemo(item: viewModel.memo.value[indexPath.row], title: title, mainText: mainText)
        }
        showActivityViewController(editingView.textView.text)
    }
    
    @objc func saveData() {
        savingData()
    }
    
    @objc func leftSwipeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.edges == .left && recognizer.state == .began {
            savingData()
        }
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        configureNavi()
        configueEdgeGesture()
        bindData()
    }
    
    func bindData() {
        viewModel.isEditing.bind { _ in
            guard let text = self.editingView.textView.text else { return }
            self.viewModel.isEditing.value = text.isEmpty ? false : true
            print(self.viewModel.isEditing.value)
        }
    }
    
    private func configureNavi() {
        showNaviBars(naviTitle: " ", naviBarTintColor: .orange)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.prompt = " "
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveData))
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("\(viewModel.backButtonTitle.value)", for: .normal)
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
    
    private func savingData() {
        let title = splitText(editingView.textView.text).0
        let mainText = splitText(editingView.textView.text).1
        
        guard let id = objectId, let indexPath = indexPath else {
            if !editingView.textView.text.isEmpty {
                let task = Memo(titleMemo: title, mainMemo: mainText, dateRegistered: Date(), photo: nil)
                MemoRepository.shared.addItem(item: task, objectId: task.objectId)
            }
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if indexPath.section == 0 && viewModel.memo.value[indexPath.row].objectId == id && (viewModel.memo.value[indexPath.row].titleMemo != title || viewModel.memo.value[indexPath.row].mainMemo != mainText) {
            
            MemoRepository.shared.updateMemo(item: viewModel.memo.value[indexPath.row], title: title, mainText: mainText)
            
        } else if indexPath.section == 1 && viewModel.memo.value[indexPath.row].objectId == id && (viewModel.memo.value[indexPath.row].titleMemo != title || viewModel.memo.value[indexPath.row].mainMemo != mainText) {
            
            MemoRepository.shared.updateMemo(item: viewModel.memo.value[indexPath.row], title: title, mainText: mainText)
            
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
    }
}
