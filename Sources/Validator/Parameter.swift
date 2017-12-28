struct Parameter<T: Validatorable> {
  var checks: [KeyThing: T.Restriction] = [:]
  var options: [T]?
  var fallback: T?

  init(fallback: T) {
    self.fallback = fallback
  }

  init(checks: [KeyThing: T.Restriction] = [:], options: [T]? = nil, fallback: T? = nil) {
    self.options = options
    self.fallback = fallback
    self.checks = checks
  }

  init(checks: [String: T.Restriction] = [:], options: [T]? = nil, fallback: T? = nil) {
    for (message, check) in checks {
      self.checks[.value(message)] = check
    }

    self.options = options
    self.fallback = fallback
  }

  init(checks: [T.Restriction] = [], options: [T]? = nil, fallback: T? = nil) {
    for check in checks {
      self.checks[.none] = check
    }

    self.options = options
    self.fallback = fallback
  }

  init(options: [T]?) {
    self.options = options
  }

  func read(_ value: String?) throws -> T {
    guard let value = value else {
      if let fallback = fallback {
        return fallback
      }

      throw "No value passed"
    }

    return try parse(value)
  }

  func parse(_ value: String) throws -> T {
    guard let result = T.parse(value) else {
      throw "Could not parse"
    }

    for (message, check) in checks {
      switch message {
      case let .value(that):
        do {
          try check.check(result)
        } catch {
          throw that
        }
      case .none:
        try check.check(result)
      }
    }

    if let options = self.options, !options.isEmpty {
      guard (options.contains { $0 == result }) else {
        throw "Not in options"
      }
    }

    return result
  }
}
