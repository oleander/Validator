// class Base<Element: Paramable>: Setter {
//   var items: [String]?
//   let fallback: [Element]
//   let flag: String
//   let options: [Element]
//   let examples: [String: String]
//   let validation: [Element.Validator]
// }

protocol Validatorable {
  associatedtype Checker
}

extension Int: Validatorable {
  // static public let max = MaxCheck()
  enum Checker {
    case max(Int)
  }
}


struct Validator<T: Validatorable> {
  init(validation: [T.Checker]) {
    print(validation)
  }
}

let check = Validator<Int>(
  // flag: "max-age",
  validation: [.max(90)]
)
