// class Base<Element: Paramable>: Setter {
//   var items: [String]?
//   let fallback: [Element]
//   let flag: String
//   let options: [Element]
//   let examples: [String: String]
//   let validation: [Element.Validator]
// }

protocol Validatorable {

}

extension Int: Validatorable {}

struct Validator<T: Validatorable> {

}

let check = Validator<Int>(
  // flag: "max-age",
  // validation: [.max(90)]
)
