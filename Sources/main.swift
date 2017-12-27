protocol Validatorable {
  associatedtype Restriction
  static func parse(_ value: String) -> Self
}

extension Int: Validatorable {
  enum Restriction {
    case max(Int)
  }

  static func parse(_ value: String) -> Int {
    return Int(value)!
  }
}

struct Parameter<T: Validatorable> {
  let restrictions: [T.Restriction]

  func parse(_ value: String) -> T {
    return T.parse(value)
  }
}

let check = Parameter<Int>(
  // flag: "max-age",
  restrictions: [.max(90)]
)

print(check.parse("10"))
