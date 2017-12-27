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
  let checks: [T.Restriction]

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

assert((try? check.parse("11")) == 11)
assert((try? check.parse("100")) == nil)
