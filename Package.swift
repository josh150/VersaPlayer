// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VersaPlayer",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v15),
		.macOS(.v10_15),
		.watchOS(.v7),
		.tvOS(.v14)
	],
    products: [
		.library(name: "VersaPlayer", targets: ["VersaPlayer"])
	],
    targets: [
        .target(
            name: "VersaPlayer",
			path: "VersaPlayer/Classes/Source"
		)
    ]
)
