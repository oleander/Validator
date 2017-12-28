open class Cmd {
  enum ArgMiddleState {
    case flag(String)
    case value(String)
    case none
  }

  enum ArgEndState: Equatable {
    case flag(String)
    case value(String)
    case param(String, String)

    static func == (lhs: ArgEndState, rhs: ArgEndState) -> Bool {
      switch (lhs, rhs) {
      case let (.flag(a), .flag(b)):
        return a == b
      case let (.value(a), .value(b)):
        return a == b
      case let (.param(a1, a2), .param(b1, b2)):
        return a1 == b1 && a2 == b2
      default:
        return false
      }
    }
  }

  private let args: [String]

  public init(_ args: [String] = CommandLine.arguments) {
    self.args = args

    // let params = self.params
    let arguments = self.arguments

    // for argument in arguments {
    //   for param in params {
    //     switch (param, argument) {
    //     case let (is Flag, .flag(flag)) where param.flag == flag:
    //       (param as! Flag).on()
    //     case let (is Value, .value(flag)):
    //       log.bug("Not yet implemented")
    //     case let (is Paramable, .param(flag, value)) where param.flag == flag:
    //       (param as! Paramable).set(value)
    //     }
    //   }
    // }
  }

  internal var arguments: [ArgEndState] {
    let initState = (acc: [ArgEndState](), rest: ArgMiddleState.none)
    let state = args.reduce(initState) { box, arg in
      let key = arg.dropFirst(2)
      switch (box.rest, arg.hasPrefix("--")) {
      case let (.flag(flag), true): // Last value was a key, this is a key i.e --a --b
        return (acc: box.acc + [.flag(flag)], rest: .flag(String(key)))
      case let (.flag(flag), false): // --flag value
        return (acc: box.acc + [.param(flag, arg)], rest: .none)
      case let (.value(value), true): // A single value followed by a key, i.e Value --key
        return (acc: box.acc + [.value(value)], rest: .flag(String(key)))
      case (.none, true):
        return (acc: box.acc, rest: .flag(String(key))) // Only --x
      case (.none, false):
        return (acc: box.acc + [.value(arg)], rest: .none) // Just a value, nothing before it
      case let (.value(value), false):
        return (acc: box.acc + [.value(value), .value(arg)], rest: .none)
      }
    }

    switch state.rest {
    case .none:
      return state.acc
    case let .flag(flag):
      return state.acc + [.flag(flag)]
    case let .value(value):
      return state.acc + [.value(value)]
    }
  }

  // private var params: [Setter] {
  //   let current = Mirror(reflecting: self)
  //   if let master = current.superclassMirror {
  //     return from(mirror: master) + from(mirror: current)
  //   } else {
  //     return from(mirror: current)
  //   }
  // }

  // private func from(mirror: Mirror) -> [Setter] {
  //   return mirror.children.reduce([Setter]()) { acc, child in
  //     if let res = child.value as? Setter {
  //       return acc + [res]
  //     }
  //
  //     return acc
  //   }
  // }
}
