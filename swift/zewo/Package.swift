// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "server_swift_zewo",
    products: [ 
	.executable(name: "server_swift_zewo", targets: ["server_swift_zewo"])
    ],
    dependencies: [
        .package(url: "https://github.com/Zewo/Zewo", .branch("0.16.1")),
    ],
    targets: [
        .target(
            name: "server_swift_zewo",
            dependencies: ["Zewo"],
            path: ".",
            sources: ["Sources"]),
    ]
)
