// extension String: Error {}
//
// protocol Restrictionable {
//   associatedtype ValueToCheck
//   func check(_ value: ValueToCheck) throws
// }
//
// protocol Validatorable: Equatable {
//   associatedtype Restriction: Restrictionable where Restriction.ValueToCheck == Self
//   static func parse(_ value: String) -> Self?
// }
//
// extension Validatorable {
//   func check(_ value: Self) throws {}
// }
//
// extension Int: Validatorable {
//   enum Restriction: Restrictionable {
//     case max(Int)
//     case min(Int)
//
//     func check(_ value: Int) throws {
//       switch self {
//       case let .max(other) where value <= other:
//         return
//       case let .min(other) where value >= other:
//         return
//       default:
//         throw "not valid"
//       }
//     }
//   }
//
//   static func parse(_ value: String) -> Int? {
//     return Int(value)
//   }
// }
//
//
// extension String: Validatorable, Restrictionable {
//   enum Restriction: Restrictionable {
//     case max(Int)
//     case min(Int)
//
//     func check(_ value: String) throws {
//       // switch self {
//       // case let .max(other) where value.count <= other:
//       //   return
//       // case let .min(other) where value.count >= other:
//       //   return
//       // default:
//       //   throw "not valid"
//       // }
//     }
//   }
//
//   static func parse(_ value: String) -> String? {
//     return value
//   }
// }
//
// struct Parameter<T: Validatorable> {
//   var checks: [String: T.Restriction:]?
//   var options: [T]?
//
//   init(checks: [T.Restriction: String]) {
//     self.checks = checks
//   }
//
//   init(checks: [T.Restriction]) {
//     for check in checks {
//       self.checks[check] = nil
//     }
//   }
//
//   init(options: [T]) {
//     self.options = options
//   }
//
//   init(checks: [T.Restriction], options: [T]) {
//     self.checks = checks
//     self.options = options
//   }
//
//   func parse(_ value: String) throws -> T {
//     guard let result = T.parse(value) else {
//       throw "Could not parse"
//     }
//
//     if let checks = self.checks {
//       for (check, message) in checks {
//         if let message = message {
//           if (try? check.check(result)) == nil {
//             throw message
//           }
//         } else {
//           try? check.check(result)
//         }
//       }
//     }
//
//     if let options = self.options {
//       guard (options.contains { $0 == result }) else {
//         throw "Not in options"
//       }
//     }
//
//     return result
//   }
// }
//
// let check = Parameter<Int>(
//   // flag: "max-age"  jjjj
//   checks: [.min(10), .max(90)]
// )
//
// enum Car: Validatorable, Restrictionable {
//   typealias Restriction = Car
//   case volvo, saab
//
//   static func parse(_ value: String) -> Restriction? {
//     switch value {
//     case "volvo":
//       return .volvo
//     case "saab":
//       return .saab
//     default:
//       return nil
//     }
//   }
// }
//
// let opt = Parameter<Car>(
//   // flag: "max-age"  jjjj
//   // checks: [.min(10), .max(90)]
//   options: [.volvo]
// )
//
// let optString = Parameter<String>(
//   // flag: "max-age"  jjjj
//   checks: [.min(10), .max(90)],
//   options: ["horse"]
// )
//
// let optStringWithKey = Parameter<String>(
//   // flag: "max-age"  jjjj
//   checks: [
//     .max(3) => "Max 3"
//   ]
// )
//
// assert((try? check.parse("11")) == 11)
// assert((try? check.parse("100")) == nil)
// assert((try? opt.parse("volvo")) == .volvo)
// assert((try? opt.parse("nothing")) == nil)
// assert((try? opt.parse("saab")) == nil)
// assert((try? optString.parse("horse")) == "horse")
// assert((try? optString.parse("pell")) == nil)
//
// do {
//   try optStringWithKey.parse("xxx")
//   assert(false)
// } catch {
//   assert(error == "Max 3")
// }


enum KeyThing: Hashable {
  case none
  case value(String)

  var hashValue: Int {
    switch self {
    case let .none:
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

var x = [KeyThing: String] = [:]
