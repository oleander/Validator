enum KeyThing: Hashable {
  case none
  case value(String)

  var hashValue: Int {
    switch self {
    case .none:
      return -1
    case let .value(message):
      return message.hashValue
    }
  }

  static func == (lhs: KeyThing, rhs: KeyThing) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
      return true
    case let (.value(m1), value(m2)):
      return m1 == m2
    default:
      return false
    }
  }
}
