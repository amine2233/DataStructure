//
//  DataStructure_Node.swift
//  DataStructure
//
//  Created by Amine Bensalah on 09/09/2018.
//

import XCTest
@testable import DataStructure

class DataStructure_Node: XCTestCase {
    
    let nodeZero = Node<Int>(value: 0)
    let nodeOne = Node<Int>(value: 1)
    let nodeTwo = Node<Int>(value: 2)
    let nodeThree = Node<Int>(value: 3)
    let nodeTen = Node<Int>(value: 10)

    override func setUp() {
        nodeZero.add(child: nodeOne)
        nodeZero.add(child: nodeTwo)
        nodeZero.add(child: nodeThree)
        nodeOne.add(child: nodeTen)
        
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddChildNode() {
        XCTAssertTrue(nodeZero.isRoot)
        XCTAssertFalse(nodeOne.isRoot)
        
        XCTAssertTrue(nodeOne.hasChildren)
        XCTAssertFalse(nodeThree.hasChildren)
        
        XCTAssertEqual(nodeZero.numberOfChildren, 3)
        XCTAssertEqual(nodeOne.numberOfChildren, 1)
        
        XCTAssertEqual(nodeZero.level, 0)
        XCTAssertEqual(nodeOne.level, 1)
        XCTAssertEqual(nodeThree.level, 1)
        XCTAssertEqual(nodeTen.level, 2)
        
        XCTAssertFalse(nodeZero.isLeaf)
        XCTAssertFalse(nodeOne.isLeaf)
        XCTAssertTrue(nodeThree.isLeaf)
    }
    
    func testCreateNode() {
        let twenty = nodeTwo.createNode(value: 20)
        XCTAssertNotNil(twenty)
        XCTAssertTrue(twenty!.isLeaf)
    }
    
    func testCreateNodes() {
        let hundredNodes = nodeZero.createNodes(array: (100..<125).map { $0 })
        XCTAssertNotNil(hundredNodes)
    }
    
    func testIndexPath() {
        XCTAssertNotNil(nodeZero.indexPath)
        XCTAssertEqual(nodeZero.indexPath.first, 0)
        XCTAssertEqual(nodeOne.indexPath.first, 0)
        XCTAssertEqual(nodeOne.indexPath.last, 0)
        XCTAssertEqual(nodeTwo.indexPath.last, 1)

        let nodeTwenty = Node<Int>(value: 20)
        nodeTwenty.parent = nodeZero
        XCTAssertNotNil(nodeTwenty.indexPath)
        XCTAssertEqual(nodeTwenty.indexPath.first, 1)
    }
    
    func testGetChildAtPosition() {
        let getNodeThree = nodeZero.child(at: 2)
        XCTAssertNotNil(getNodeThree)
        XCTAssertEqual(getNodeThree, nodeThree)
        
        let getNodeTen = nodeOne.child(at: 0)
        XCTAssertNotNil(getNodeTen)
        XCTAssertEqual(getNodeTen, nodeTen)
        
        let getNodeNotExist = nodeOne.child(at: 5)
        XCTAssertNil(getNodeNotExist)
    }
    
    func testIndexOfChild() {
        XCTAssertEqual(nodeZero.index(ofChild: nodeThree), 2)
        XCTAssertEqual(nodeOne.index(ofChild: nodeTen), 0)
    }
    
    func testHasAncestor() {
        XCTAssertFalse(nodeZero.hasAncestor(in: [nodeOne,nodeTwo,nodeThree]))
        XCTAssertTrue(nodeTen.hasAncestor(in: [nodeOne]))
        XCTAssertTrue(nodeTen.hasAncestor(in: [nodeZero]))
    }
    
    func testIsAncestorOfNode() {
        XCTAssertTrue(nodeZero.isAncestor(of: nodeOne))
        XCTAssertFalse(nodeOne.isAncestor(of: nodeTwo))
    }
    
    func testContainNode() {
        XCTAssertTrue(nodeZero.contain(nodeTwo))
        let nodeNegative = Node<Int>(value: -1)
        XCTAssertFalse(nodeZero.contain(nodeNegative))
    }
    
    func testFindNode() {
        XCTAssertNotNil(nodeZero.find(nodeTwo))
        XCTAssertNotNil(nodeZero.find(nodeTen))
        let nodeNegative = Node<Int>(value: -1)
        XCTAssertNil(nodeZero.find(nodeNegative))
    }
    
    func testFindNodeWhereCondition() {
        XCTAssertNotNil(nodeZero.find(where: { $0 == nodeThree }))
        let nodeNegative = Node<Int>(value: -1)
        XCTAssertNil(nodeZero.find(where: { $0 == nodeNegative }))
    }
    
    func testRemoveNode() {
        let nodeNegative = Node<Int>(value: -1)
        
        XCTAssertNil(nodeZero.remove(nodeNegative))
        XCTAssertNil(nodeOne.remove(nodeNegative))
        
        nodeZero.add(child: nodeNegative)
        
        XCTAssertTrue(nodeZero.contain(nodeNegative))
        XCTAssertNotNil(nodeZero.remove(nodeNegative))
        XCTAssertFalse(nodeZero.contain(nodeNegative))
    }
    
    func testInsertNodeInOtherNode() {
        let nodeNegative = Node<Int>(value: -1)
        XCTAssertTrue(nodeZero.insert(nodeNegative, in: nodeOne))
        XCTAssertTrue(nodeOne.contain(nodeNegative))
        let nodeNegativeTwo = Node<Int>(value: -2)
        XCTAssertNotNil(nodeZero.remove(nodeNegative))
        XCTAssertFalse(nodeZero.insert(nodeNegativeTwo, in: nodeNegative))
    }
    
    func testMoveNodeInOtherNode() {
        XCTAssertTrue(nodeZero.move(nodeTen, to: nodeTwo))
        let nodeNegative = Node<Int>(value: -1)
        XCTAssertFalse(nodeZero.move(nodeNegative, to: nodeOne))
    }
    
    func testSearchNodeWithValue() {
        let nodeOneTmp = nodeZero.search(value: 1)
        XCTAssertNotNil(nodeOneTmp)
        XCTAssertTrue(nodeOneTmp == nodeOne)
    }
    
    func testSearchWithWhereValue() {
        let nodeTwoTmp = nodeZero.search(where: { $0 == 2 })
        XCTAssertNotNil(nodeTwoTmp)
        XCTAssertTrue(nodeTwoTmp == nodeTwo)
    }
    
    func testHashValue() {
        XCTAssertEqual(nodeOne.hashValue, nodeOne.value.hashValue)
        XCTAssertNotEqual(nodeTwo.hashValue, nodeZero.value.hashValue)
        XCTAssertEqual(nodeOne.hashValue, 1.hashValue)
    }
    
    func testNodesOrganizedByParentOfNodes() {
        XCTAssertEqual(Node.nodesOrganizedByParent([nodeOne,nodeTwo]).count, 1)
        XCTAssertEqual(Node.nodesOrganizedByParent([nodeOne,nodeTwo,nodeThree]).count, 1)
        XCTAssertEqual(Node.nodesOrganizedByParent([nodeOne,nodeTwo,nodeThree])[nodeZero], [nodeOne,nodeTwo,nodeThree])
        XCTAssertEqual(Node.nodesOrganizedByParent([nodeTen]).count, 1)
    }
    
    func testIndexSetsGroupedByParentOfNode() {
        XCTAssertEqual(Node.indexSetsGroupedByParent([nodeOne]).count, 1)
        let nodeEmpty = Node(value: 890)
        nodeEmpty.createNode(value: 891)
        nodeEmpty.createNode(value: 892)
        nodeEmpty.createNode(value: 893)
        nodeEmpty.children.forEach {
            XCTAssertEqual(Node.indexSetsGroupedByParent($0.children).count, 0)
        }
    }
    
    func testSearchValueNode() {
        XCTAssertEqual(nodeZero.search(value: 2), nodeTwo)
    }
    
    func testSearchValueNodeWithWhereClosure() {
        XCTAssertEqual(nodeZero.search { $0 == 3}, nodeThree)
        XCTAssertNotEqual(nodeZero.search { $0 == 1}, nodeTwo)
    }
    
    func testNodesOrganizedByParent() {
        // Todo: Need to implement
    }
    
    func testIndexSetGroupedByParent() {
        // Todo: Need to implement
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
