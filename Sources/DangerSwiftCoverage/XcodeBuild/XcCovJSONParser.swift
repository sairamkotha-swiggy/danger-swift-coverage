import Foundation

enum XcCovJSONParserError: LocalizedError {
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid coverage report"
        }
    }
}

protocol XcCovJSONParsing {
    static func json(fromXCoverageFile file: String) throws -> Data
    static func json(fromXcresultFile file: String) throws -> Data
}

enum XcCovJSONParser: XcCovJSONParsing {
    static func json(fromXCoverageFile file: String) throws -> Data {
        return try json(fromXCoverageFile: file, shellOutExecutor: ShellOutExecutor())
    }

    static func json(fromXCoverageFile file: String, shellOutExecutor: ShellOutExecuting) throws -> Data {
        return try jsonData(fromCommand: "xcrun xccov view \(file) --json", shellOutExecutor: shellOutExecutor)
    }
    
    static func json(fromXcresultFile file: String) throws -> Data {
        return try json(fromXcresultFile: file, shellOutExecutor: ShellOutExecutor())
    }
    
    static func json(fromXcresultFile file: String, shellOutExecutor: ShellOutExecuting) throws -> Data {
        return try jsonData(fromCommand: "xcrun xccov view --report --json \(file)", shellOutExecutor: shellOutExecutor)
    }
    
    private static func jsonData(fromCommand command: String, shellOutExecutor: ShellOutExecuting) throws -> Data {
        if let json = try? shellOutExecutor.execute(command: command) {
            return json
        } else {
            throw XcCovJSONParserError.invalidData
        }
    }
}
