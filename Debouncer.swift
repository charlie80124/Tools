class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue = DispatchQueue.global(qos: .background)
    private var interval: TimeInterval
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    func debounce(block: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            block()
        }
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + interval, execute: workItem)
        }
    }
}
