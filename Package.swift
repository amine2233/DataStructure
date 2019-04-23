// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DataStructure",
    products: [
        .library(
            name: "DataStructure",
            targets: ["DataStructure"])
    ],
    targets: [
        .target(
            name: "DataStructure",
            dependencies: []
        ),
        .testTarget(
            name: "DataStructureTests",
            dependencies: ["DataStructure"])
    ]
)
