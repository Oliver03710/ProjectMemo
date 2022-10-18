//
//  UINavigationBar+Extension.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

extension UIViewController {
    
    func showNaviBars(naviTitle: String?, naviBarTintColor: UIColor) {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.scrollEdgeAppearance = barAppearance
        
        navigationItem.title = naviTitle
        self.navigationController?.navigationBar.tintColor = naviBarTintColor
        
    }
    
}
