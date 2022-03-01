
# Single-line comments start with a #

#[
  This is a multiline comment.
  In Nim, multiline comments can be nested, beginning with #[
  ... and ending with ]#
]#

discard """
This can also work as a multiline comment.
Or for unparsable, broken code
"""
# 变量名: 的写法，比较骚；有类型说明则 类型= xxx
var                     # Declare (and assign) variables, 声明和分配变量
  letter: char = 'n'    # with or without type annotations  有 有无类型注释的两种
  lang = "N" & "im"     # 
  nLength: int = len(lang)
  boat: float
  truth: bool = false

let            # Use let to declare and bind variables *once*. 使用let去声明和绑定变量，
  legs = 400   # legs is immutable.  这跟const很像，让他不可变
  arms = 2_000 # _ are ignored and are useful for long numbers. _会被忽略，用于长的数字，像200,000,000中的,
  aboutPi = 3.15

const            # Constants are computed at compile time. This provides   常量在编译时杯计算
  debug = true   # performance and is useful in compile time expressions.  这提供了性能，且在编译中的表达式很有用
  compileBadCode = false

when compileBadCode:            # `when` is a compile time `if` when像if
  legs = legs + 1               # This error will never be compiled.  这里不会被编译，因为这是个const
  const input = readline(stdin) # Const values must be known at compile time.

discard 1 > 2 # Note: The compiler will complain if the result of an expression
              # is unused. `discard` bypasses this.
              # 如果表达式的结果没用，编译器会报错，而discark用于绕过这个报错


#
# Data Structures
#

# Tuples 元组

var
  child: tuple[name: string, age: int]   # Tuples have *both* field names 元组比较像python
  today: tuple[sun: string, temp: float] # *and* order.

child = (name: "Rudiger", age: 2) # Assign all at once with literal ()
today.sun = "Overcast"            # or individual fields.
today.temp = 70.1               # 赋值的几种办法

# Sequences 序列
# 这玩意看起来像python的元组和列表
var
  drinks: seq[string]

drinks = @["Water", "Juice", "Chocolate"] # @[V1,..,Vn] is the sequence literal

drinks.add("Milk")

if "Milk" in drinks:
  echo "We have Milk and ", drinks.len - 1, " other drinks"

let myDrink = drinks[2]

#
# Defining Types  类型定义
#

# Defining your own types puts the compiler to work for you. It's what makes
# static typing powerful and useful.
# 定义你自己的类型 给编译器为你工作，可以使得静态类型更有用的
# 即把 类型 给一个别名，比如把Name整成类型 string
type
  Name = string # A type alias gives you a new type that is interchangeable 类型别名为您提供了一个可互换的新类型
  Age = int     # with the old type but is more descriptive. 使得老的类型更有描述性
  Person = tuple[name: Name, age: Age] # Define data structures too.
  AnotherSyntax = tuple
    fieldOne: string
    secondField: int

var
  john: Person = (name: "John B.", age: 17)
  newage: int = 18 # It would be better to use Age than int

john.age = newage # But still works because int and Age are synonyms

type
  Cash = distinct int    # `distinct` makes a new type incompatible with its
  Desc = distinct string # base type. 

var
  money: Cash = 100.Cash # `.Cash` converts the int to our type
  description: Desc  = "Interesting".Desc

when compileBadCode:
  john.age  = money        # Error! age is of type int and money is Cash 上边用了distinct，使得crash的int和原本的int不一样（不兼容）
  john.name = description  # Compiler says: "No way!"

#
# More Types and Data Structures 更多的类型和数据结构
#

# Enumerations allow a type to have one of a limited number of values
# 枚举，跟C差不多
type
  Color = enum cRed, cBlue, cGreen
  Direction = enum # Alternative formatting
    dNorth
    dWest
    dEast
    dSouth
var
  orient = dNorth # `orient` is of type Direction, with the value `dNorth` orient是枚举类型的“Direction”的值
  pixel = cGreen # `pixel` is of type Color, with the value `cGreen` 同上，一个道理

discard dNorth > dEast # Enums are usually an "ordinal" type 

# Subranges specify a limited valid range

type
  DieFaces = range[1..20] # Only an int from 1 to 20 is a valid value 这个很像python
var
  my_roll: DieFaces = 13

when compileBadCode:
  my_roll = 23 # Error!

# Arrays 数组

type # 数组[数组内容，类型]  英文描述的就是数组，固定长度且有索引
  RollCounter = array[DieFaces, int]  # Array's are fixed length and
  DirNames = array[Direction, string] # indexed by any ordinal type.
  Truths = array[42..44, bool]
var #  变量的赋值方法，还是有点骚和别扭
  counter: RollCounter
  directions: DirNames
  possible: Truths
# 数组的几种赋值方式
possible = [false, false, false] # Literal arrays are created with [V1,..,Vn]
possible[42] = true

directions[dNorth] = "Ahh. The Great White North!"
directions[dWest] = "No, don't go there."

my_roll = 13
counter[my_roll] += 1
counter[my_roll] += 1

var anotherArray = ["Default index", "starts at", "0"]

# More data structures are available, including tables, sets, lists, queues,
# and crit bit trees.
# http://nim-lang.org/docs/lib.html#collections-and-algorithms

#
# IO and Control Flow IO和控制流
#

# `case`, `readLine()`

echo "Read any good books lately?" # echo 跟cmd命令行一样
case readLine(stdin)  # switch case nim版  readline也是读取行的内容
of "no", "No":
  echo "Go to your local library."
of "yes", "Yes":
  echo "Carry on, then."
else:
  echo "That's great; I assume."

# `while`, `if`, `continue`, `break`

import strutils as str # http://nim-lang.org/docs/strutils.html  # 导入后重命名 跟 python的import as
echo "I'm thinking of a number between 41 and 43. Guess which!"
let number: int = 42
var
  raw_guess: string
  guess: int
while guess != number:  # while的使用
  raw_guess = readLine(stdin)
  if raw_guess == "": continue # Skip this iteration
  guess = str.parseInt(raw_guess)
  if guess == 1001:
    echo("AAAAAAGGG!")
    break
  elif guess > number:
    echo("Nope. Too high.")
  elif guess < number:
    echo(guess, " is too low")
  else:
    echo("Yeeeeeehaw!")

#
# Iteration 迭代
#

for i, elem in ["Yes", "No", "Maybe so"]: # Or just `for elem in`
  echo(elem, " is at index: ", i)

for k, v in items(@[(person: "You", power: 100), (person: "Me", power: 9000)]):
  echo v

let myString = """
an <example>
`string` to
play with
""" # Multiline raw string

for line in splitLines(myString):
  echo(line)

for i, c in myString:       # Index and letter. Or `for j in` for just letter
  if i mod 2 == 0: continue # Compact `if` form
  elif c == 'X': break
  else: echo(c)

#
# Procedures 程序 ？ 这看起来像函数啊
#

type Answer = enum aYes, aNo

proc ask(question: string): Answer =
  echo(question, " (y/n)")
  while true:
    case readLine(stdin)
    of "y", "Y", "yes", "Yes":
      return Answer.aYes  # Enums can be qualified
    of "n", "N", "no", "No":
      return Answer.aNo
    else: echo("Please be clear: yes or no")

proc addSugar(amount: int = 2) = # Default amount is 2, returns nothing
  assert(amount > 0 and amount < 9000, "Crazy Sugar")
  for a in 1..amount:
    echo(a, " sugar...")

case ask("Would you like sugar in your tea?")
of aYes:
  addSugar(3)
of aNo:
  echo "Oh do take a little!"
  addSugar()
# No need for an `else` here. Only `yes` and `no` are possible.

#
# FFI 即 在一种语言中调用另一种语言的接口
#

# Because Nim compiles to C, FFI is easy:

proc strcmp(a, b: cstring): cint {.importc: "strcmp", nodecl.}

let cmp = strcmp("C?", "Easy!")

