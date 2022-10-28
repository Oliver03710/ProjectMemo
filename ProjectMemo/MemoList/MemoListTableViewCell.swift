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
    
    let titleLabel: CustomLabel = {
        let label = CustomLabel(fontSize: 16)
        return label
    }()
    
    let dateLabel: CustomLabel = {
        let label = CustomLabel(fontSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    let mainTextlLabel: CustomLabel = {
        let label = CustomLabel(fontSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    let memoImageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "photo")
        iv.tintColor = .systemGray5
        return iv
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
        [memoImageView, titleLabel, dateLabel, mainTextlLabel].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        memoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(memoImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(memoImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.height.equalTo(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(memoImageView.snp.trailing).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(self.snp.width).dividedBy(2)
        }
        
        mainTextlLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(dateLabel.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
        }
        
    }
    
    func setComponents(item: Memo, textSearched: String, isFlitering: Bool) {
        
        titleLabel.text = item.titleMemo
        mainTextlLabel.text = item.mainMemo == nil ? "추가 텍스트 없음" : item.mainMemo
        if let data = item.photo {
            memoImageView.image = UIImage(data: data)
        }

        if isFlitering {
            let titleAttString = NSMutableAttributedString(string: titleLabel.text!)
            let range: NSRange = (titleLabel.text! as NSString).range(of: textSearched, options: .caseInsensitive)
            titleAttString.addAttribute(.foregroundColor, value: UIColor.orange, range: range)
            titleLabel.attributedText = titleAttString
            
            let mainTextAttString = NSMutableAttributedString(string: mainTextlLabel.text!)
            let range2: NSRange = (mainTextlLabel.text! as NSString).range(of: textSearched, options: .caseInsensitive)
            mainTextAttString.addAttribute(.foregroundColor, value: UIColor.orange, range: range2)
            mainTextlLabel.attributedText = mainTextAttString
        } else {
            titleLabel.textColor = .label
            mainTextlLabel.textColor = .label
        }
        
        dateLabel.text = item.dateRegistered.setDateFormat()
    }
    
}
