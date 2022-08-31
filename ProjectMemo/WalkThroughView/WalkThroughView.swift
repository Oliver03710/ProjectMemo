//
//  WalkThroughView.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import SnapKit

class WalkThroughView: BaseView {
    
    // MARK: - Properties
    
    let basicView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .orange
        return view
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "처음 오셨군요!\n환영합니다:)\n\n당신만의 메모를 작성하고 관리해보세요!"
        return label
    }()
    
    let confirmButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 16
        btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("확인", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
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
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.isOpaque = false
        [basicView].forEach { self.addSubview($0) }
        [confirmButton, introLabel].forEach { basicView.addSubview($0) }
    }
    
    override func setConstraints() {
        basicView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.width / 1.5)
            make.height.equalTo(basicView.snp.width)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(basicView.snp.bottom).offset(-20)
            make.leading.equalTo(basicView.snp.leading).offset(20)
            make.trailing.equalTo(basicView.snp.trailing).offset(-20)
            make.height.equalTo(44)
        }
        
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(basicView.snp.top).offset(20)
            make.leading.equalTo(basicView.snp.leading).offset(20)
            make.trailing.equalTo(basicView.snp.trailing).offset(-20)
            make.bottom.equalTo(confirmButton.snp.top).offset(10)
        }
        
    }

}
