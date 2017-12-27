extension String: Error {}

protocol Validatorable {
  associatedtype Restriction
  static func parse(_ value: String) -> Self?
}

extension Int: Validatorable {
  enum Restriction {
    case max(Int)
  }

  static func parse(_ value: String) -> Int? {
    return Int(value)
  }
}

struct Parameter<T: Validatorable> {
  let restrictions: [T.Restriction]

  func parse(_ value: String) throws -> T {
    guard let result = T.parse(value) else {
      throw "Could not parse"
    }

    return result
  }
}

let check = Parameter<Int>(
  // flag: "max-age",
  restrictions: [.max(90)]
)

do {
  print(try check.parse("10"))
} catch {
  print("ERROR: \(error)")
}
