// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "PieChart",
            type: .static,
            targets: ["PieChart"]
        ),
    ],
    targets: [
        .target(
            name: "PieChart",
            dependencies: []
        ),
    ]
)
