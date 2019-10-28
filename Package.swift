// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PullToRefresh",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PullToRefresh",
            targets: ["PullToRefresh"]),
    ],
    dependencies: [
        .package(url: "git@github.com:noppefoxwolf/Rotoscope.git", from: .init("0.0.9"))
    ],
    targets: [
        .target(
            name: "PullToRefresh",
            dependencies: ["Rotoscope"]),
        .testTarget(
            name: "PullToRefreshTests",
            dependencies: ["PullToRefresh"]),
    ]
)
