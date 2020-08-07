//
//  BatchSaveOperation.swift
//  AWS-Offline
//
//  Created by Hoàng Anh on 07/08/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import Amplify
import Foundation

class AsyncOperation: Operation {
    override var isAsynchronous: Bool { true }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isExecuting: Bool {
        state == .executing
    }
    
    override var isFinished: Bool {
        state == .finished
    }
    
    override var isReady: Bool {
        super.isReady && state == .ready
    }
    
    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
}

extension AsyncOperation {
    enum State: String {
        case executing = "isExecuting"
        case finished = "isFinished"
        case ready = "isReady"
    }
}

final class BatchSaveOperation<M: Model>: AsyncOperation {
    private let models: [M]
    
    var savedModels = [M]()
    
    init(models: [M]) {
        self.models = models
        super.init()
    }
    
    override func main() {
        guard !isCancelled else {
            state = .finished
            return
        }
        
        for (index, model) in models.enumerated() {
            Amplify.DataStore.save(model) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let savedModel):
                    self.savedModels.append(savedModel)
                case .failure(let error):
                    print(error)
                }
                if index == self.models.count-1 {
                    self.state = .finished
                    print("finished saving")
                }
            }
        }
    }
}
