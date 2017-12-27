extension String: Error {}

protocol Restrictionable {
  associatedtype ValueToCheck
  func check(_ value: ValueToCheck) throws
}

protocol Validatorable: Equatable {
  associatedtype Restriction: Restrictionable where Restriction.ValueToCheck == Self
  static func parse(_ value: String) -> Self?
}

extension Int: Validatorable {
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


extension String: Validatorable, Restrictionable {
  typealias Restriction = String
  func check(_ value: String) throws {}
  static func parse(_ value: String) -> Restriction? {
    return value
  }
}

struct Parameter<T: Validatorable> {
  var checks: [T.Restriction]?
  var options: [T]?

  init(checks: [T.Restriction]) {
    self.checks = checks
  }

  init(options: [T]) {
    self.options = options
  }

  func parse(_ value: String) throws -> T {
    guard let result = T.parse(value) else {
      throw "Could not parse"
    }

    if let checks = self.checks {
      for check in checks {
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

let check = Parameter<Int>(
  // flag: "max-age"  jjjj
  checks: [.min(10), .max(90)]
)

enum Car: Validatorable, Restrictionable {
  typealias Restriction = Car
  case volvo, saab

  func check(_ value: Car) throws {

  }

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

let opt = Parameter<Car>(
  // flag: "max-age"  jjjj
  // checks: [.min(10), .max(90)]
  options: [.volvo]
)

let optString = Parameter<String>(
  // flag: "max-age"  jjjj
  // checks: [.min(10), .max(90)]
  options: ["horse"]
)

assert((try? check.parse("11")) == 11)
assert((try? check.parse("100")) == nil)
assert((try? opt.parse("volvo")) == .volvo)
assert((try? opt.parse("nothing")) == nil)
assert((try? opt.parse("saab")) == nil)
assert((try? optString.parse("horse")) == "horse")
assert((try? optString.parse("pell")) == nil)
