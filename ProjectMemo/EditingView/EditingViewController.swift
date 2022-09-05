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
        let title = splitText(editingView.textView.text).0
        let mainText = splitText(editingView.textView.text).1
        
        guard let id = objectId else {
            if !editingView.textView.text.isEmpty {
                let task = Memo(titleMemo: title, mainMemo: mainText, dateRegistered: Date())
                repository.addItem(item: task, objectId: task.objectId)
                showActivityViewController()
                return
            }
            return
        }
        
        if indexPath.section == 0 && tasks[indexPath.row].objectId == id && (tasks[indexPath.row].titleMemo != title || tasks[indexPath.row].mainMemo != mainText) {
            print(indexPath.section, id)
            repository.updateMemo(item: tasks[indexPath.row], title: title, mainText: mainText)
        } else if indexPath.section == 1 && tasks[indexPath.row].objectId == id && (tasks[indexPath.row].titleMemo != title || tasks[indexPath.row].mainMemo != mainText) {
            repository.updateMemo(item: tasks[indexPath.row], title: title, mainText: mainText)
            print(indexPath.section, id)
        }
        showActivityViewController()
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
    
    private func savingData() {
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
    
    private func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    private func showActivityViewController() {
        guard let text = editingView.textView.text else { return }
        var shareObject = [Any]()
        
        shareObject.append(text)
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.showToast(message: "share success", font: .systemFont(ofSize: 12))
            } else {
                self.showToast(message: "share cancel", font: .systemFont(ofSize: 12))
            }
            if let shareError = error {
                self.showToast(message: "\(shareError.localizedDescription)", font: .systemFont(ofSize: 12))
            }
        }
    }
    
}
