//
//  StatusOfMemo.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/03.
//

import Foundation

import RealmSwift

struct MemoStatus {
    static var pinned: Results<Memo>!
    static var unPinned: Results<Memo>!
}
