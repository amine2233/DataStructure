import Foundation

protocol NodeProtocol {
    associatedtype Item
    var value: Item { get set }
    
    var isRoot: Bool { get }
    var hasChildren: Bool { get }
    var numberOfChildren: Int { get }
    var level: Int { get }
    var isLeaf: Bool { get }
    var indexPath: IndexPath { get }
}

final public class Node<T>: NodeProtocol {
    
    public var value: T
    
    public var children: [Node] = []
    public weak var parent: Node?
    
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
    
    public init(value: T, parent: Node? = nil) {
        
        precondition(Thread.isMainThread)
        
        self.value = value
        self.parent = parent
    }
    
    @discardableResult
    public func createNode(value: T) -> Node? {
        let node = Node(value: value, parent: self)
        children.append(node)
        return node
    }
    
    @discardableResult
    public func createNodes(array: [T]) -> [Node]? {
        var values: [Node] = []
        array.forEach { value in
            let node = Node(value: value, parent: self)
            children.append(node)
            values.append(node)
        }
        return values
    }
    
    public func add(child: Node) {
        children.append(child)
        child.parent = self
    }
    
    public func child(at index: Int) -> Node? {
        if index >= children.count || index < 0 {
            return nil
        }
        return children[index]
    }
    
    public func index(for node: Node) -> Int? {
        return children.index { (oneChildNode) -> Bool in
            return oneChildNode === node
        }
    }
    
    public func hasAncestor(in nodes: [Node]) -> Bool {
        for node in nodes {
            if node.isAncestor(of: self) {
                return true
            }
        }
        return false
    }
    
    public func isAncestor(of node: Node) -> Bool {
        if node == self {
            return false
        }
        var nomad = node
        while true {
            guard let parent = nomad.parent else {
                return false
            }
            if parent == self {
                return true
            }
            nomad = parent
        }
    }
}

extension Node: Equatable {
    public class func == (lhs: Node, rhs: Node) -> Bool {
        return lhs === rhs
    }
    
    public func contain(_ node: Node) -> Bool {
        if self == node {
            return true
        }
        for child in children {
            if child.contain(node) {
                return true
            }
        }
        return false
    }
    
    public func find(where: (Node) -> Bool) -> Node? {
        if `where`(self) {
            return self
        }
        
        for child in children {
            if let found = child.find(where: `where`) {
                return found
            }
        }
        
        return nil
    }
    
    public func find(_ node: Node) -> Node? {
        if self == node {
            return self
        }
        
        for child in children {
            if let find = child.find(node) {
                return find
            }
        }
        
        return nil
    }
    
    @discardableResult
    public func remove(_ node: Node) -> Node? {
        if let index = children.index(where: { $0 == node }) {
            children[index].parent = nil
            return children.remove(at: index)
        }
        
        for child in children {
            if let removeNode = child.remove(node) {
                return removeNode
            }
        }
        
        return nil
    }
    
    @discardableResult
    public func insert(_ node: Node, in newNode: Node) -> Bool {
        if let new = find(newNode) {
            new.add(child: node)
            return true
        }
        return false
    }
    
    @discardableResult
    public func move(_ node: Node, to new: Node) -> Bool {
        if let child = find(node), let parentChild = child.parent {
            parentChild.remove(child)
            return self.insert(child, in: new)
        }
        return false
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        var text = "\(value) at \(indexPath) for level \(level) \n"
        text += "\((0...level).map { _ in return " " })"
        
        if !children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        
        return text
    }
}

extension Node where T: Equatable {
    public func search(value: T) -> Node? {
        if value == self.value {
            return self
        }
        
        for child in children {
            if let found = child.search(value: value) {
                return found
            }
        }
        
        return nil
    }
    
    public func search(where: (T) -> Bool) -> Node? {
        if `where`(self.value) {
            return self
        }
        
        for child in children {
            if let found = child.search(where: `where`) {
                return found
            }
        }
        
        return nil
    }
}
