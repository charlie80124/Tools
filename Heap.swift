struct Heap<T> {
    var elements: [T]
    let priority: (T,T) -> Bool
    
    var isEmpty: Bool { elements.isEmpty }
    var count: Int { elements.count }
    
    
    init(elements: [T], priority: @escaping (T, T) -> Bool) {
        self.elements = elements
        self.priority = priority
        buildHeap()
    }
    
    mutating func buildHeap() {
        for i in stride(from: count/2-1, through: 0, by: -1) {
            swiftDown(elementAtIndex: i)
        }
    }
    
    func peek()->T? { elements.first }
    
    func isRoot(_ index:Int) -> Bool { index == 0 }
    func leftChildIndex(of index:Int) -> Int { 2*index+1 }
    func rightChildIndex(of index:Int) -> Int { 2*index+2 }
    func parentIndex(of index:Int) -> Int { (index-1)/2 }
    
    func isHigherPriority(at firstIndex: Int, then secondIndex: Int) -> Bool {
        return priority(elements[firstIndex], elements[secondIndex])
    }
    
    func highestPriortyIndex(of paranetIndex:Int, and childIndex:Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, then: paranetIndex) else { return paranetIndex }
        return childIndex
    }
    
    func highestPriorityIndex(for parent:Int) -> Int {
        return highestPriortyIndex(of: highestPriortyIndex(of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
    }
    
    mutating func swapElement(at firstIndex:Int, with secondIndex:Int) {
        guard firstIndex != secondIndex else { return }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    mutating func enqueue(_ element:T) {
        elements.append(element)
        siftUp(elementAtIndex: count - 1 )
    }
    
    mutating func siftUp(elementAtIndex index:Int) {
        let parent = parentIndex(of: index)
        guard isRoot(index),
              isHigherPriority(at: index, then: parent) else { return }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
        
    }
    
    mutating func dequeue(_ element:T) -> T? {
        guard !isEmpty else { return nil}
        swapElement(at: 0, with: count-1) //把第一個移到最後
        let element = elements.removeLast() //移除
        if !isEmpty {
            siftDown(elementAtIndex:0)
        }
        return element
    }
    
    mutating func siftDown(elementAtIndex index:Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex { return }
        swapElement(at: index, with: childIndex)
        swiftDown(elementAtIndex: childIndex)
    }
}
