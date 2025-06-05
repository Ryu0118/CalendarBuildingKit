// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CalendarBuildingKit",
    platforms: [
        .iOS(.v17), .macOS(.v14), .visionOS(.v1), .watchOS(.v10), .macCatalyst(.v17), .tvOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CalendarBuildingKit",
            targets: ["CalendarBuildingKit"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CalendarBuildingKit"
        ),
        .testTarget(
            name: "CalendarBuildingKitTests",
            dependencies: ["CalendarBuildingKit"]
        ),
    ]
)
