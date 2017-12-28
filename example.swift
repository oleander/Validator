protocol Group {}

struct Person: Group {}
struct Monkey: Group {}
struct Horse: Group {}

struct Thing<T: Group> {}

let person = Thing<Person>()
let monkey = Thing<Monkey>()
let horse = Thing<Horse>()
