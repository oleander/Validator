struct Validator {
    var text = "Hello, World!"
}

let maxAge = Single<Int>(
  flag: "max-age",
  validation: [.max(90)]
)
