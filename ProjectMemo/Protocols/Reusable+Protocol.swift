//
//  Reusable+Protocol.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/08/31.
//

import UIKit

private protocol ReusableViewProtocol {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
