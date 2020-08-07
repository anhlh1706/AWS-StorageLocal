//
//  DataManager.swift
//  AWS-Offline
//
//  Created by Hoàng Anh on 07/08/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import Amplify
import Foundation

final class DataManager {
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        Amplify.DataStore.query(User.self) { result in
            switch result {
            case .success(let users):
                completion(users)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
            
        NetworkingService.requestUsers { [weak self] result in
            switch result {
            case .success(let wireUsers):
                self?.save(wireUsers: wireUsers, completion: { users in
                    DispatchQueue.main.async {
                        completion(users)
                    }
                })
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func save(wireUsers: [WireUser], completion: @escaping ([User]) -> Void) {
        let users = wireUsers.map { User(id: String($0.id), content: $0.name) }
        
        // batch save users
        let batchSaveOp = BatchSaveOperation(models: users)
        batchSaveOp.completionBlock = { [unowned batchSaveOp] in
            let savedUsers = batchSaveOp.savedModels
            completion(savedUsers)
        }
        
        let queue = OperationQueue()
        queue.addOperations([batchSaveOp], waitUntilFinished: true)
    }
}
