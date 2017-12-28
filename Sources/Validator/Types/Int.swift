extension Int: Validatorable {
  public enum Restriction: Restrictionable {
    case max(Int)
    case min(Int)

    public func check(_ value: Int) throws {
      switch self {
      case let .max(other) where value <= other:
        return
      case let .min(other) where value >= other:
        return
      default:
        throw "not valid"
      }
    }
  }

  public static func parse(_ value: String) -> Int? {
    return Int(value)
  }
}
