enum KeyThing: Hashable {
  case none
  case value(String)

  var hashValue: Int {
    switch self {
    case .none:
      return -1
    case let .value(message):
      return message.hashValue
    }
  }

  static func == (lhs: KeyThing, rhs: KeyThing) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
      return true
    case let (.value(m1), value(m2)):
      return m1 == m2
    default:
      return false
    }
  }
}

extension String: Error {}

protocol Restrictionable {
  associatedtype ValueToCheck
  func check(_ value: ValueToCheck) throws
}

extension Restrictionable {
  func check(_ value: ValueToCheck) throws {}
}

protocol Validatorable: Equatable, Restrictionable {
  associatedtype Restriction: Restrictionable where Restriction.ValueToCheck == Self
  static func parse(_ value: String) -> Self?
}

// extension Validatorable {
//   func check(_ value: Self) throws {}
// }

extension Int: Validatorable {
  // typealias ValueToCheck = Int

  enum Restriction: Restrictionable {
    case max(Int)
    case min(Int)

    func check(_ value: Int) throws {
      switch self {
      case let .max(other) where value <= other:
        return
      case let .min(other) where value >= other:
        return
      default:
        throw "not valid"
      }
    }
  }

  static func parse(_ value: String) -> Int? {
    return Int(value)
  }
}


extension String: Validatorable {
  typealias ValueToCheck = String

  enum Restriction: Restrictionable {
    typealias ValueToCheck = String
    case max(Int)
    case min(Int)
  }

  static func parse(_ value: String) -> String? {
    return value
  }
}

struct Parameter<T: Validatorable> {
  var checks: [KeyThing: T.Restriction] = [:]
  var options: [T]?
  var fallback: T?

  init(fallback: T) {
    self.fallback = fallback
  }

  init(checks: [String: T.Restriction]) {
    for (message, check) in checks {
      self.checks[.value(message)] = check
    }
  }

  init(checks: [T.Restriction]) {
    for check in checks {
      self.checks[.none] = check
    }
  }

  init(options: [T]) {
    self.options = options
  }

  init(checks: [T.Restriction], options: [T]) {
    for check in checks {
      self.checks[.none] = check
    }
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
        if (try? check.check(result)) != nil {
          throw that
        }
      case .none:
        try check.check(result)
      }
    }

    if let options = self.options {
      guard (options.contains { $0 == result }) else {
        throw "Not in options"
      }
    }

    return result
  }
}

enum Car: Validatorable {
  typealias Restriction = Car
  typealias ValueToCheck = Car
  case volvo, saab

  static func parse(_ value: String) -> Restriction? {
    switch value {
    case "volvo":
      return .volvo
    case "saab":
      return .saab
    default:
      return nil
    }
  }
}

let check = Parameter<Int>(
  // flag: "max-age"  jjjj
  checks: [.min(10), .max(90)]
)

let opt = Parameter<Car>(
  // flag: "max-age"  jjjj
  // checks: [.min(10), .max(90)]
  options: [.volvo]
)

let optString = Parameter<String>(
  // flag: "max-age"  jjjj
  checks: [.min(10), .max(90)],
  options: ["horse"]
)

let optStringWithKey = Parameter<String>(
  // flag: "max-age"  jjjj
  checks: [
    "Max 3": .max(3)
  ]
)

let opt3 = Parameter<Car>(
  fallback: .volvo
)

assert((try? check.parse("11")) == 11)
assert((try? check.parse("100")) == nil)
assert((try? opt.parse("volvo")) == .volvo)
assert((try? opt.parse("nothing")) == nil)
assert((try? opt.parse("saab")) == nil)
assert((try? optString.parse("horse")) == "horse")
assert((try? optString.parse("pell")) == nil)
assert((try? opt3.read(nil)) == .volvo)
assert((try? opt3.read("volvo")) == .volvo)
assert((try? opt3.read("hell")) == nil)

do {
  _ = try optStringWithKey.parse("aaaxxx")
  assert(false)
} catch {
  assert(String(describing: error) == "Max 3")
}
