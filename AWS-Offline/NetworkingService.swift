//
//  NetworkingServices.swift
//  AWS-Offline
//
//  Created by Hoàng Anh on 07/08/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import Foundation

enum NetworkingService {
    
    static func requestUsers(completion: @escaping (Result<[WireUser], Error>) -> Void) {
        let task = URLSession.shared.dataTask(
            with: URL(string: "https://jsonplaceholder.typicode.com/users")!
        ) {
            if let error = $2 {
                completion(.failure(error))
            } else if let data = $0, let users = try? JSONDecoder().decode([WireUser].self, from: data) {
                completion(.success(users))
            }
        }
        task.resume()
    }
}
