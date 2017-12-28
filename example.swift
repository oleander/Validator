protocol Group {}

struct Person: Group {}
struct Monkey: Group {}
struct Horse: Group {}

struct Thing<T: Group> {}

class Command {
  let person = Thing<Person>()
  let monkey = Thing<Monkey>()
  let horse = Thing<Horse>()

  let value = "hello"
}

let command = Command()
let children = Mirror(reflecting: command).children

for child in children {
  if child is Thing<Group> {
    print("Found an instance varible of type Thing<Group>!")
  }
}
