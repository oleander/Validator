protocol Validatorable: Equatable, Restrictionable {
  associatedtype Restriction: Restrictionable
    where Restriction.ValueToCheck == Self
  static func parse(_ value: String) -> Self?
}

extension Validatorable {
  typealias ValueToCheck = Self
  func check(_ value: Self) throws {}
}
