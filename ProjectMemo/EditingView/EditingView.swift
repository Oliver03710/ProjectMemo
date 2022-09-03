//
//  EditingView.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import SnapKit

class EditingView: BaseView {

    // MARK: - Properties
    
    let textView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        textView.becomeFirstResponder()
        [textView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        textView.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
    }
}
