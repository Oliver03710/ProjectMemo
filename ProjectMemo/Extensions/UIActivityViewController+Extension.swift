//
//  UIActivityViewController+Extension.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/19.
//

import UIKit

extension UIViewController {
    
    func showActivityViewController(_ rawText: String?) {
        guard let text = rawText else { return }
        var shareObject = [Any]()
        
        shareObject.append(text)
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            
            self.showToast(message: completed ? "share success" : "share cancel", font: .systemFont(ofSize: 12))
            
            if let shareError = error {
                self.showToast(message: "Error: \(shareError.localizedDescription)", font: .systemFont(ofSize: 12))
            }
        }
    }
    
}
