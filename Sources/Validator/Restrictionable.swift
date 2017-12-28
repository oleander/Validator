public protocol Restrictionable {
  associatedtype ValueToCheck
  func check(_ value: ValueToCheck) throws
}

extension Restrictionable {
  public func check(_ value: ValueToCheck) throws {}
}
