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

    func check(_ value: Int) throws {
      switch self {
      case let .max(other) where value < other:
        return
      }

      throw "not valid"
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
  // flag: "max-age",
  checks: [.max(90)]
)

do {
  print(try check.parse("10"))
} catch {
  print("ERROR: \(error)")
}
