//
//  SplitText+Extension.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/02.
//

import UIKit

extension UIViewController {
    func splitText(_ text: String?) -> (String, String) {
        
        guard let text = text else { return ("", "")}
        
        var lines = text.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
       
        let firstElement = String(lines.removeFirst())
        
        let restElements = lines.joined(separator: "\n")
        
        return (firstElement, restElements)
        
    }
}
