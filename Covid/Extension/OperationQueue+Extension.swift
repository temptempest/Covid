//
//  OperationQueue+Extension.swift
//  Covid
//
//  Created by temptempest on 20.12.2022.
//

import UIKit

protocol OperationQueueBehavioral {
    static func mainAsyncIfNeeded(execute work: @escaping () -> Void)
}

extension OperationQueue: OperationQueueBehavioral {
    static func mainAsyncIfNeeded(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            main.addOperation(work)
        }
    }
}
