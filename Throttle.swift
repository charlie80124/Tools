//
//  Throttle.swift
//  VantageFX
//
//  Created by Charlie.Hsu on 2019/12/24.
//

import Foundation
import UIKit

class Throttler {
    private let queue: DispatchQueue = DispatchQueue.global(qos: .background)
    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: TimeInterval = 0
    private var maxInterval: TimeInterval
    
    init(seconds:TimeInterval) {
        self.maxInterval = seconds
    }
    
    func throttle(block: @escaping()->()){
        job.cancel()
        job = DispatchWorkItem{ [weak self] in
            self?.previousRun = Date().timeIntervalSince1970
            block()
        }
        let delay =  previousRun > maxInterval ? 0 : maxInterval
        queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
    }
    
}
var t = Throttler(seconds: 1)
for _ in 0...10 {
    t.throttle {
        print(10)
    }
}
