//
//  PhotoManager.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/10/28.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

final class PhotoManager {
    
    // MARK: - Properties
    
    static let shared = PhotoManager()
    
    
    // MARK: - Init
    
    private init() { }
    
    
    // MARK: - Helper Functions
    
    func setRequest() -> URLRequest? {
        
        let urlString = Endpoints.randomURL
        
        guard let url = URL(string: urlString) else {
            print("URL 오류")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(APIKeys.authorization, forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
