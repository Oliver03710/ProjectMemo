//
//  PhotoData.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/28.
//

import Foundation

struct RandomPhoto: Codable, Hashable {
     
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case urls
    }
}

struct Urls: Codable, Hashable {
    let raw, full, regular, small, thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
