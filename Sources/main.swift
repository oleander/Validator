extension String: Error {}

protocol Restrictionable {
  associatedtype ValueToCheck
  func check(_ value: ValueToCheck) throws
}

protocol Validatorable {
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

struct Parameter<T: Validatorable> {
  let checks: [T.Restriction] = []
  let options: [T] = []

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

    for check in checks {
      try check.check(result)
    }

    return result
  }
}

let check = Parameter<Int>(
  // flag: "max-age"  jjjj
  checks: [.min(10), .max(90)]
)

enum Car: Validatorable, Restrictionable {
  typealias Restriction = Self
  case volvo, saab

  func check(_ value: Car) throws {}

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

assert((try? check.parse("11")) == 11)
assert((try? check.parse("100")) == nil)
assert((try? opt.parse("volvo")) == .volvo)
assert((try? opt.parse("nothing")) == nil)
