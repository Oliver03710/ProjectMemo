//
//  Results+Extension.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/22.
//

import Foundation

import RealmSwift

extension Results {
  func toArray() -> [Element] {
    return compactMap {
        $0
    }
  }
}
