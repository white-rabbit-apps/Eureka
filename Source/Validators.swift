import Foundation

public enum ValidationResult {
  case Valid(BaseRow)
  case Invalid(BaseRow, String)

  public var valid: Bool {
    switch self {
    case .Valid: return true
    case .Invalid: return false
    }
  }

  public var errors: [String] {
    switch self {
    case .Valid: return []
    case let .Invalid(_, msg): return [msg]
    }
  }
}

public protocol RowValidator {
  func validate(row: BaseRow) -> ValidationResult
}

public struct PresenceValidator: RowValidator {
  private let msg: String

  public init(msg: String = "Value needs to be present") {
    self.msg = msg
  }

  public func validate(row: BaseRow) -> ValidationResult {
    switch row.baseValue {
    case .Some: return .Valid(row)
    case .None: return .Invalid(row, msg)
    }
  }
}

public struct RegexValidator: RowValidator {
  private let regex: String
  private let msg: String

  public init(regex: String, msg: String = "Regex didn't match") {
    self.regex = regex
    self.msg = msg
  }

  public func validate(row: BaseRow) -> ValidationResult {
    if let value = row.baseValue as? String where match(value) {
      return .Valid(row)
    } else {
      return .Invalid(row, msg)
    }
  }

  private func match(value: String) -> Bool {
    return value.rangeOfString(regex, options: .RegularExpressionSearch) != nil
  }
}
