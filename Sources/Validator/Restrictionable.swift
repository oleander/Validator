protocol Restrictionable {
  associatedtype ValueToCheck
  func check(_ value: ValueToCheck) throws
}

extension Restrictionable {
  func check(_ value: ValueToCheck) throws {}
}
