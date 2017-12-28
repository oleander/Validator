import Foundation

struct MultiParameter<T: Validatorable> {
  var checks: [KeyThing: T.Restriction] = [:]
  var options: [T]?
  var fallback: [T]?

  init(fallback: [T]) {
    self.fallback = fallback
  }

  init(checks: [String: T.Restriction] = [:]) {
    for (message, check) in checks {
      self.checks[.value(message)] = check
    }
  }

  init(checks: [T.Restriction]) {
    for check in checks {
      self.checks[.none] = check
    }
  }

  init(options: [T]?) {
    self.options = options
  }

  init(checks: [T.Restriction], options: [T]) {
    for check in checks {
      self.checks[.none] = check
    }
    self.options = options
  }

  func read(_ value: String?) throws -> [T] {
    guard let value = value else {
      if let fallback = fallback {
        return fallback
      }

      throw "No value passed"
    }

    return try value.components(separatedBy: ",").map { part in
      return try Parameter<T>(
        checks: checks,
        options: options
      ).parse(part)
    }
  }
}
