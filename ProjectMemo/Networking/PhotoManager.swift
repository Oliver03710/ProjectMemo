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
    
    func requestPhotos(completion: @escaping (RandomPhoto?, APIError?) -> Void) {

        let urlString = "\(Endpoints.randomURL)"

        guard  let url = URL(string: urlString) else {
            print("URL 오류")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(APIKeys.authorization, forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {

                guard error == nil else {
                    print("Failed Request")
                    completion(nil, .failedRequest)
                    return
                }

                guard let data = data else {
                    print("No Data Returned")
                    completion(nil, .noData)
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    print("Unable Response")
                    completion(nil, .invalidResponse)
                    return
                }

                guard response.statusCode == 200 else {
                    print("Failed Response: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }

                do {
                    let result = try JSONDecoder().decode(RandomPhoto.self, from: data)
//                    print(result)
                    completion(result, nil)
                } catch {
                    print("error Data: \(error)")
                    completion(nil, .invalidData)
                }

            }

        }.resume()

    }
    
}
