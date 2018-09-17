//
//  Event.swift
//  DataStructure
//
//  Created by BENSALA on 17/09/2018.
//

import Foundation

public enum Event {
    case reset
    case inserts([Int])
    case deletes([Int])
    case updates([Int])
    case move(Int, Int)
    case beginBatchEditing
    case endBatchEditing
}

public protocol ObservableEventProtocol {
    associatedtype Item
    var event: Event { get }
    var source: Node<Item> { get }
}

public struct ObservableEvent<Item>: ObservableEventProtocol {
    public var event: Event
    public var source: Node<Item>
    
    init (change: Event, source: Node<Item>) {
        self.event = change
        self.source = source
    }
    
    init (change: Event, value: Item) {
        self.event = change
        self.source = Node(value: value)
    }
}

final public class ObservableNode<Item>: NodeProtocol {
    
    public var value: Item
    
    public var children: [ObservableNode] = []
    public weak var parent: ObservableNode?
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var hasChildren: Bool {
        return !children.isEmpty
    }
    
    public var numberOfChildren: Int {
        return children.count
    }
    
    public var level: Int {
        if let parent = parent {
            return parent.level + 1
        }
        return 0
    }
    
    public var isLeaf: Bool {
        return numberOfChildren < 1
    }
    
    public var indexPath: IndexPath {
        if let parent = parent {
            let parentPath = parent.indexPath
            if let childIndex = parent.index(for: self) {
                return parentPath.appending(childIndex)
            }
        }
        return IndexPath(index: level)
    }
    
    public init(value: Item, parent: ObservableNode? = nil) {
        
        precondition(Thread.isMainThread)
        
        self.value = value
        self.parent = parent
    }
    
    public func index(for node: ObservableNode) -> Int? {
        return children.index { (oneChildNode) -> Bool in
            return oneChildNode === node
        }
    }
}
