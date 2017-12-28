extension String: Validatorable {
  public enum Restriction: Restrictionable {
    public typealias ValueToCheck = String
    case max(Int)
    case min(Int)

    public func check(_ value: String) throws {
      switch self {
      case let .max(other) where value.count <= other:
        return
      case let .min(other) where value.count >= other:
        return
      default:
        throw "not valid"
      }
    }
  }

  public static func parse(_ value: String) -> String? {
    return value
  }
}
