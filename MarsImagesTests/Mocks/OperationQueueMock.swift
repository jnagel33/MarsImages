//
//  OperationQueueMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

class OperationQueueMock: OperationQueue {
    
    var operationsResult: [Operation]?
    override var operations: [Operation] {
        return operationsResult ?? super.operations
    }
    
    var addOperationCalled = false
    override func addOperation(_ op: Operation) {
        super.addOperation(op)
        addOperationCalled = true
    }
}
