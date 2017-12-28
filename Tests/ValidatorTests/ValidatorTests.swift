import XCTest
@testable import Validator

import Foundation

enum Car: Validatorable {
  typealias Restriction = Car
  case volvo, saab

  static func parse(_ value: String) -> Restriction? {
    switch value {
    case "volvo":
      return .volvo
    case "saab":
      return .saab
    default:
      return nil
    }
  }
}

class ValidatorTests: XCTestCase {
    func testExample() {
      let check = Parameter<Int>(
        // flag: "max-age"  jjjj
        checks: [.min(10), .max(90)]
      )

      let opt = Parameter<Car>(
        // flag: "max-age"  jjjj
        // checks: [.min(10), .max(90)]
        options: [.volvo]
      )

      let optString = Parameter<String>(
        // flag: "max-age"  jjjj
        checks: [.min(10), .max(90)],
        options: ["horse"]
      )

      let optStringWithKey = Parameter<String>(
        // flag: "max-age"  jjjj
        checks: [
          "Max 3": .max(3)
        ]
      )

      let opt3 = Parameter<Car>(
        fallback: .volvo
      )

      let multiOpt = MultiParameter<Car>(
        // options: [., .maybe]
      )

      let multiOpt2 = MultiParameter<Car>(
        options: [.volvo]
      )

      let multiOpt4 = MultiParameter<Car>(
        fallback: [.volvo]
      )

      let multiOpt3 = MultiParameter<String>(
        checks: [.max(2)]
      )

      let multiOpt5 = MultiParameter<String>(
        options: ["hello", "pelle"]
      )

      assert((try? check.parse("11")) == 11)
      assert((try! multiOpt.read("volvo,saab")) == [.volvo, .saab])
      assert((try? multiOpt2.read("volvo,saab")) == nil)
      assert((try! multiOpt2.read("volvo")) == [.volvo])

      assert((try! multiOpt3.read("aa,bb")) == ["aa", "bb"])

      assert((try! multiOpt4.read(nil)) == [.volvo])

      assert((try! multiOpt5.read("hello,pelle")) == ["hello", "pelle"])
      assert((try? multiOpt5.read("hello,ok")) == nil)

      assert((try? check.parse("100")) == nil)
      assert((try? opt.parse("volvo")) == .volvo)
      assert((try? opt.parse("nothing")) == nil)
      assert((try? opt.parse("saab")) == nil)
      assert((try? optString.parse("horse")) == "horse")
      assert((try? optString.parse("pell")) == nil)
      assert((try? opt3.read(nil)) == .volvo)
      assert((try? opt3.read("volvo")) == .volvo)
      assert((try? opt3.read("hell")) == nil)

      do {
        _ = try optStringWithKey.parse("aaaxxx")
        assert(false)
      } catch {
        assert(String(describing: error) == "Max 3")
      }
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
