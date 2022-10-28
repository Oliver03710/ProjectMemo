//
//  CustomLabel.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/28.
//

import UIKit

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat) {
        self.init()
        self.font = .boldSystemFont(ofSize: fontSize)
        
    }
    
    func setUI() {
        self.numberOfLines = 1
    }

}
