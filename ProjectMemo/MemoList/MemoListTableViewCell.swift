//
//  MemoListTableViewCell.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

import SnapKit

class MemoListTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.text = "Title Label"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.text = "9999 99 99 일요일 99:99"
        return label
    }()
    
    let mainTextlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.text = "Additional Label"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateLabel, mainTextlLabel])
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.spacing = 8
        return sv
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func setUI() {
        [titleLabel, stackView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.height.equalTo(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(200).priority(999)
        }
        
        mainTextlLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
    }
    
}
