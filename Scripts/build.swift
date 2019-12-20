#!/usr/bin/env swift

import Foundation

// Usage: build.swift platforms

func execute(commandPath: String, arguments: [String]) throws {
    let task = Process()
    task.launchPath = commandPath
    task.arguments = arguments
    print("Launching command: \(commandPath) \(arguments.joined(separator: " "))")
    task.launch()
    task.waitUntilExit()
    guard task.terminationStatus == 0 else {
        throw TaskError.code(task.terminationStatus)
    }
}

enum TaskError: Error {
    case code(Int32)
}

enum Platform: String, CaseIterable, CustomStringConvertible {
    case iOS_12
    case iOS_13
    case tvOS_12
    case tvOS_13
    case macOS_10_15
    case watchOS_5
    case watchOS_6

    var destination: String {
        switch self {
        case .iOS_12:
            return "platform=iOS Simulator,OS=12.2,name=iPad Pro (12.9-inch) (3rd generation)"
        case .iOS_13:
            return "platform=iOS Simulator,OS=13.2.2,name=iPad Pro (12.9-inch) (3rd generation)"

        case .tvOS_12:
            return "platform=tvOS Simulator,OS=12.2,name=Apple TV"
        case .tvOS_13:
            return "platform=tvOS Simulator,OS=13.2,name=Apple TV"

        case .macOS_10_15:
            return "platform=OS X"

        case .watchOS_5:
             return "OS=5.2,name=Apple Watch Series 4 - 44mm"
        case .watchOS_6:
            return "OS=6.1,name=Apple Watch Series 4 - 44mm"
        }
    }

    var sdk: String {
        switch self {
        case .iOS_12,
             .iOS_13:
            return "iphonesimulator"

        case .tvOS_12,
             .tvOS_13:
            return "appletvsimulator"

        case .macOS_10_15:
            return "macosx10.15"

        case .watchOS_5,
             .watchOS_6:
            return "watchsimulator"
        }
    }

    var shouldTest: Bool {
        switch self {
        case .iOS_12,
             .iOS_13,
             .tvOS_12,
             .tvOS_13:
            return true

        case .macOS_10_15:
            // We can't run tests on macOS 10.15 because CacheAdvance assumes macOS 10.15 APIs are available, and Travis CI's machines run on macOS 10.14.
            // For more information, see https://github.com/dfed/CacheAdvance/issues/2
            return false

        case .watchOS_5,
             .watchOS_6:
            // watchOS does not support unit testing (yet?).
            return false
        }
    }

    var enableCodeCoverage: Bool {
        switch self {
        case .tvOS_12,
             .tvOS_13:
            return true

        case .iOS_12,
             .iOS_13,
             .macOS_10_15,
             .watchOS_5,
             .watchOS_6:
            return false
        }
    }

    var description: String {
        rawValue
    }
}

guard CommandLine.arguments.count > 1 else {
    print("Usage: build.swift platforms")
    throw TaskError.code(1)
}

try execute(commandPath: "/usr/bin/swift", arguments: ["package", "generate-xcodeproj", "--output=generated/"])

let rawPlatforms = CommandLine.arguments[1].components(separatedBy: ",")

for rawPlatform in rawPlatforms {
    guard let platform = Platform(rawValue: rawPlatform) else {
        print("Received unknown platform type \(rawPlatform)")
        print("Possible platform types are: \(Platform.allCases)")
        throw TaskError.code(1)
    }
    var xcodeBuildArguments = [
        "-project", "generated/CacheAdvance.xcodeproj",
        "-scheme", "CacheAdvance-Package",
        "-sdk", platform.sdk,
        "-configuration", "Release",
        "-PBXBuildsContinueAfterErrors=0",
    ]
    if !platform.destination.isEmpty {
        xcodeBuildArguments.append("-destination")
        xcodeBuildArguments.append(platform.destination)
    }
    if platform.enableCodeCoverage {
        xcodeBuildArguments.append("-enableCodeCoverage")
        xcodeBuildArguments.append("YES")
        xcodeBuildArguments.append("-derivedDataPath")
        xcodeBuildArguments.append(".build/derivedData")
    }
    xcodeBuildArguments.append("build")
    if platform.shouldTest {
        xcodeBuildArguments.append("test")
    }

    try execute(commandPath: "/usr/bin/xcodebuild", arguments: xcodeBuildArguments)
}
