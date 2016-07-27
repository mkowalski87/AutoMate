//
//  SystemLaunchArguments.swift
//  AutoMate
//
//  Created by Joanna Bednarz on 03/06/16.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import Foundation

public struct SystemLanguageArgument: LanguageArgument, CollectionArgumentOption {

    // MARK: CollectionArgumetOption
    public let values: [SystemLanguages]

    public init(_ values: [SystemLanguages]) {
        self.values = values
    }
}

public struct SystemLocaleArgument: LocaleArgument, SingleArgumentOption {

    private let localeIdentifier: String

    public init(localeIdentifier: String) {
        self.localeIdentifier = localeIdentifier
    }

    public init(language: SystemLanguages, country: SystemCountries) {
        self.localeIdentifier = "\(language.rawValue)_\(country.rawValue)"
    }
}

// MARK: LaunchArgumentValue
extension SystemLocaleArgument: LaunchArgumentValue {

    public var launchArgument: String {
        return "\"\(localeIdentifier)\""
    }
}

public struct SystemSoftwareKeyboardArgument: KeyboardArgument, CollectionArgumentOption {

    // MARK: CollectionArgumetOption
    public var values: [SoftwareKeyboards]

    public init(_ values: [SoftwareKeyboards]) {
        self.values = values
    }
}

public struct SystemHardwareKeyboardArgument: KeyboardArgument, CollectionArgumentOption {

    // MARK: CollectionArgumetOption
    public var values: [HardwareKeyboards]

    public init(_ values: [HardwareKeyboards]) {
        self.values = values
    }
}

public struct SystemKeyboardArgument: KeyboardArgument {

    private let software: SystemSoftwareKeyboardArgument
    private let hardware: SystemHardwareKeyboardArgument

    public var values: [LaunchArgumentValue] {
        return software.values.combineValues(hardware.values)
    }

    public init(software: SystemSoftwareKeyboardArgument = [], hardware: SystemHardwareKeyboardArgument = []) {
        self.software = software
        self.hardware = hardware
    }

    public var launchArguments: [String]? {
        return ["-\(argumentKey)", "(" + values.map({ $0.launchArgument }).joinWithSeparator(", ") + ")"]
    }
}

// MARK: - CoreDataArgument
public enum CoreDataArgument {
    case SQLDebug(verbosityLevel: VerbosityLevel)
    case SyntaxColoredLogging
    case MigrationDebug
    case ConcurrencyDebug
    case SQLiteDebugSynchronous(syncing: DiskSyncing)
    case SQLiteIntegrityCheck
    case ThreadingDebug(verbosityLevel: VerbosityLevel)

    public enum VerbosityLevel: Int {
        case Low = 1
        case Medium = 2
        case High = 3
    }

    public enum DiskSyncing: Int {
        case Disabled = 1
        case Normal = 2
        case Full = 3
    }
}

extension CoreDataArgument.VerbosityLevel : LaunchArgumentValue {}

extension CoreDataArgument.DiskSyncing : LaunchArgumentValue {}

extension CoreDataArgument: SingleArgumentOption {
    public var argumentKey: String {
        switch self {
        case SQLDebug:
            return "com.apple.CoreData.SQLDebug"
        case SyntaxColoredLogging:
            return "com.apple.CoreData.SyntaxColoredLogging"
        case MigrationDebug:
            return "com.apple.CoreData.MigrationDebug"
        case ConcurrencyDebug:
            return "com.apple.CoreData.ConcurrencyDebug"
        case SQLiteDebugSynchronous:
            return "com.apple.CoreData.SQLiteDebugSynchronous"
        case SQLiteIntegrityCheck:
            return "com.apple.CoreData.SQLiteIntegrityCheck"
        case ThreadingDebug:
            return "com.apple.CoreData.ThreadingDebug"
        }
    }

    public var value: LaunchArgumentValue {
        switch self {
        case let SQLDebug(value):
            return value
        case SyntaxColoredLogging:
            return "1"
        case MigrationDebug:
            return "1"
        case ConcurrencyDebug:
            return "1"
        case let SQLiteDebugSynchronous(value):
            return value
        case SQLiteIntegrityCheck:
            return "1"
        case let ThreadingDebug(value):
            return value
        }
    }
}


// MARK: - LocalizedStringArgument
enum LocalizedStringsArgument: String {
    case DoubleLocalizedStrings = "NSDoubleLocalizedStrings"
    case ShowNonLocalizedStrings = "NSShowNonLocalizedStrings"
}

extension LocalizedStringsArgument: SingleArgumentOption {
    var value: LaunchArgumentValue {
        return "YES"
    }
    var argumentKey: String {
        return rawValue
    }
}
