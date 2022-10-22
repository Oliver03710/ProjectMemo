//
//  Obserable.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/18.
//

import Foundation

final class Observable<T> {
    
    // MARK: - Properties
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    
    // MARK: - Init
    
    init(_ value: T) {
        self.value = value
    }
    
    
    // MARK: - Helper Functions
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
    
}
