
extension CalculatorViewController {
  func math(_ text: String) {
    decimalFlag = 0
    switch  text {
    case "%":
      operand = "%"
    case "X":
      operand = "X"
    case "-":
      operand = "-"
    case "+":
      operand = "+"
    case "x^y":
      operand = "x^y"
    case "/":
      operand = "/"
    case "√x":
      operand = "√x"
    case "x^2":
      operand = "x^2"
    case "x^3":
      operand = "x^3"
    case "e^x":
      operand = "e^x"
    case "10^x":
      operand = "10^x"
    case "10^x":
      operand = "10^x"
    case "1/x":
      operand = "1/x"
    case "∛x":
      operand = "∛x"
    case "ln":
      operand = "ln"
    case "log10":
      operand = "log10"
    case "x!":
      operand = "x!"
    case "y√x":
      operand = "y√x"
    case "sin":
      operand = "sin"
    case "cos":
      operand = "cos"
    case "tan":
      operand = "tan"
    case "sinh":
      operand = "sinh"
    case "cosh":
      operand = "cosh"
    case "tanh":
      operand = "tanh"
    case "sinh^-1":
      operand = "sinh^-1"
    case "sin^-1":
      operand = "sin^-1"
    case "cos^-1":
      operand = "cos^-1"
    case "cosh^-1":
      operand = "cosh^-1"
    case "tan^-1":
      operand = "tan^-1"
    case "tanh^-1":
      operand = "tanh^-1"
    case "y^x":
      operand = "y^x"
    case "2^x":
      operand = "2^x"
    case "logx":
      operand = "logx"
    case "log2":
      operand = "log2"
    case "EE":
      operand = "EE"
    default:
      assertionFailure("no operator")
    }
    //resultLabel.text = "0"
    power = 1
  }
}
