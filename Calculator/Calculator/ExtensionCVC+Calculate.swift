import UIKit

extension CalculatorViewController {
  func calculate() {
    if let index = stack.currentIndex{
      if index != stack.arrayNumber.count{
        stack.remove(from: index)
      }
    }
    if operand != "" {
      switch operand {
      case "%":
        resultLabel.text = String(fmod(firstNumber, secondNumber))
      case "X":
         resultLabel.text = String(firstNumber * secondNumber)
      case "-":
        resultLabel.text = String(firstNumber - secondNumber)
      case "+":
        resultLabel.text = String(firstNumber + secondNumber)
      case "x^y":
        resultLabel.text = String(pow(firstNumber, secondNumber))
      case "/":
        resultLabel.text = String(firstNumber / secondNumber)
      case "√x":
        resultLabel.text = String(sqrt(Double(firstNumber)))
      case "EE":
        resultLabel.text = String(firstNumber * pow(10.0, secondNumber))
      case "x^2":
         resultLabel.text = String(firstNumber * firstNumber)
      case "x^3":
         resultLabel.text = String(firstNumber * firstNumber * firstNumber)
      case "e^x":
         resultLabel.text = String(exp(firstNumber))
      case "10^x":
        resultLabel.text = String(pow(10.0, firstNumber))
      case "y√x":
        resultLabel.text = String(pow(firstNumber, (1/secondNumber)))
      case "1/x":
        resultLabel.text = String(1 / firstNumber)
      case "∛x":
        resultLabel.text = String(pow(firstNumber, (1/3)))
      case "ln":
        resultLabel.text = String(log(firstNumber))
      case "log10":
        resultLabel.text = String(log10(firstNumber))
      case "x!":
       resultLabel.text = String(factorial(number: firstNumber))
      case "sin":
        if radianStatusLabel.isHidden != true {
          resultLabel.text = String(sin(firstNumber))
        } else {
          resultLabel.text = String(sin(firstNumber * .pi / 180))
        }
      case "cos":
        if radianStatusLabel.isHidden != true {
          resultLabel.text = String(cos(firstNumber))
        } else {
          resultLabel.text = String(cos(firstNumber * .pi / 180))
        }
      case "tan":
        if radianStatusLabel.isHidden != true {
          resultLabel.text = String(tan(firstNumber))
        } else {
          resultLabel.text = String(tan(firstNumber * .pi / 180))
        }
      case "sinh":
          resultLabel.text = String(sinh(firstNumber))
      case "cosh":
          resultLabel.text = String(cosh(firstNumber))
      case "tanh":
          resultLabel.text = String(tanh(firstNumber))
      case "sinh^-1":
        resultLabel.text = String(asinh(firstNumber))
      case "sin^-1":
        if radianStatusLabel.isHidden != true {
          resultLabel.text = String(asin(firstNumber))
        } else {
          resultLabel.text = String(asin(firstNumber) / Double.pi * 180)
        }
      case "cos^-1":
        if radianStatusLabel.isHidden != true {
          resultLabel.text = String(acos(firstNumber))
        } else {
          resultLabel.text = String(acos(firstNumber) / Double.pi * 180)
        }
      case "cosh^-1":
        resultLabel.text = String(acosh(firstNumber))
      case "tan^-1":
        if radianStatusLabel.isHidden != true {
          resultLabel.text = String(atan(firstNumber))
        } else {
          resultLabel.text = String(atan(firstNumber ) / Double.pi * 180)
        }
      case "tanh^-1":
         resultLabel.text = String(tanh(firstNumber))
      case "y^x":
        resultLabel.text = String(pow(secondNumber, firstNumber))
      case "2^x":
        resultLabel.text = String(pow(2.0, firstNumber))
      case "logx":
        resultLabel.text = String(log(firstNumber) / log(secondNumber))
      case "log2":
        resultLabel.text = String(log(firstNumber) / log(2))
      default:
        resultLabel.text = "Mistake"
      }
      stack.insert(firstNumber)
      stack.insert(operand)
      if flagForNumberOeprationFirst != true{
        stack.insert(secondNumber)
      }
      stack.insert(Double(resultLabel.text!)!)
      operand = ""
       firstNumber = Double(resultLabel.text!)!
      secondNumber = 0
      flag = false
    }
  }
  func factorial(number: Double) -> Double {
    if number >= 0 {
      return number == 0 ? 1 : number * self.factorial(number: number-1 )
    } else {
      return 0 / 0
    }
  }
}
