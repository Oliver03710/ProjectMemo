//
//  EditingView.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import SnapKit

final class EditingView: BaseView {

    // MARK: - Properties
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    let setImageButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 12
        btn.setImage(UIImage(systemName: "photo"), for: .normal)
        return btn
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
    }
    
    override func setConstraints() {
        self.addSubview(textView)
        textView.addSubview(setImageButton)
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        setImageButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(44)
        }
    }
}
