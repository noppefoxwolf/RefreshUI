// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RefreshUI",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "RefreshUI",
            targets: ["RefreshUI"]),
    ],
    dependencies: [
        .package(url: "git@github.com:noppefoxwolf/Rotoscope.git", from: .init("0.1.2"))
    ],
    targets: [
        .target(
            name: "RefreshUI",
            dependencies: ["Rotoscope"]),
        .testTarget(
            name: "RefreshUITests",
            dependencies: ["RefreshUI"]),
    ]
)
