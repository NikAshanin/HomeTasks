
import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double {
        get {
            return Double(resultLabel.text ?? "") ?? 0
        }
        set {
            resultLabel.text = String(newValue)
        }
    }
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.titleLabel
        if userIsInTheMiddleOfTyping {
            let textOnDisplay = resultLabel.text
            resultLabel.text = textOnDisplay ?? "" + String(describing: digit)
        } else {
            resultLabel.text = String(describing: digit)
            userIsInTheMiddleOfTyping = true
        }
    }
    
    

}

  

  
  
  
  
  
  
//
//  var stack = Stack()
//  var operand = ""
//  var firstNumber: Double = 0
//  var secondNumber: Double = 0
//  var decimalFlag = 0
//  var flag = false
//  var flagForFindOperandBack = true
//  var flagForFindOperandForward = true
//  var flagForNumberOeprationFirst = false
//  var flagForNumberOperationSecond = false
//  var flagSecondMode = true
//  var power: Double = 1
//  let singleOperation: [String] = ["√x", "x^2", "x^3", "e^x", "10^x", "1/x", "∛x", "ln", "log10", "x!","sin", "cos", "tan","sinh", "cosh", "tanh", "sin^-1", "cos^-1", "tan^-1","sinh^-1", "cosh^-1", "tanh^-1", "log2", "2^x"]
//  let doubleOperation: [String] = ["%", "X", "-", "+", "x^y", "y√x", "/", "y√x", "y^x", "logx", "EE"]
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    radianStatusLabel.isHidden = true
//  }
//  @IBAction func buttonPressed(_ sender: UIButton) {
//    let text =  sender.title(for: .normal) ?? ""
//    print(text)
//    switch text {
//    case _ where doubleOperation.contains(text):
//      math(text)
//      flag = true
//    case "=":
//      calculate()
//    case _ where singleOperation.contains(text):
//      flagForNumberOeprationFirst = true
//      math(text)
//      if firstNumber == 0 {
//        break
//      }
//      calculate()
//    case ",":
//      decimal()
//    case "AC":
//      clear()
//    default:
//      if flag != true {
//        if decimalFlag == 0 {
//          resultLabel.text = text
//          firstNumber = firstNumber * 10 + Double(text)!
//          resultLabel.text = "\(Int(firstNumber))"
//        } else {
//          resultLabel.text = text
//          firstNumber +=  Double(text)! / pow(10, power)
//          resultLabel.text = "\(firstNumber)"
//          power += 1
//        }
//      } else {
//
//        if decimalFlag == 0 {
//          resultLabel.text = text
//          secondNumber = secondNumber * 10 + Double(text)!
//          resultLabel.text = "\(Int(secondNumber))"
//        } else {
//          resultLabel.text = text
//          secondNumber += Double(text)! / pow(10, power)
//          resultLabel.text = "\(secondNumber)"
//          power += 1
//        }
//      }
//    }
//  }
//  @IBAction func changeDegree(_ sender: Any) {
//    if flag == false {
//      firstNumber = firstNumber - 2 * firstNumber
//      resultLabel.text = String(firstNumber)
//    } else {
//      secondNumber = secondNumber - 2 * secondNumber
//      resultLabel.text = String(secondNumber)
//    }
//  }
//  //MARK: - make number like exp, pi, rand'
//  @IBAction func numberPI(_ sender: Any) {
//    if flag == false {
//      firstNumber = .pi
//      resultLabel.text = String(firstNumber)
//    } else {
//      secondNumber = .pi
//      resultLabel.text = String(secondNumber)
//    }
//  }
//  @IBAction func numberExp(_ sender: Any) {
//    if flag == false {
//      firstNumber = exp(1)
//      resultLabel.text = String(firstNumber)
//    } else {
//      secondNumber = exp(1)
//      resultLabel.text = String(secondNumber)
//    }
//  }
//  @IBAction func numberRand(_ sender: Any) {
//    if flag == false {
//      firstNumber = Double(arc4random())
//      resultLabel.text = String(firstNumber)
//    } else {
//      secondNumber = Double(arc4random())
//      resultLabel.text = String(secondNumber)
//    }
//  }
//  //MARK: Radian
//  @IBOutlet weak var radianStatusLabel: UILabel!
//  @IBOutlet weak var radianDegreeLabel: UIButton!
//  @IBAction func setRadian(_ sender: Any) {
//    if radianStatusLabel.isHidden == true {
//      radianStatusLabel.isHidden = false
//      radianDegreeLabel.setTitle("Deg", for: .normal)
//    } else {
//      radianStatusLabel.isHidden = true
//      radianDegreeLabel.setTitle("Rad", for: .normal)
//    }
//  }
//  //MARK: button for second mode
//  @IBOutlet weak var sinButton: UIButton!
//  @IBOutlet weak var sinHButton: UIButton!
//  @IBOutlet weak var cosButton: UIButton!
//  @IBOutlet weak var cosHButton: UIButton!
//  @IBOutlet weak var tanButton: UIButton!
//  @IBOutlet weak var tanHButton: UIButton!
//  @IBOutlet weak var exButton: UIButton!
//  @IBOutlet weak var lnButton: UIButton!
//  @IBOutlet weak var tenXButton: UIButton!
//  @IBOutlet weak var log10Button: UIButton!
//  @IBAction func secondMode(_ sender: Any) {
//    if flagSecondMode == true{
//      sinHButton.setTitle("sinh^-1", for: .normal)
//      sinButton.setTitle("sin^-1", for: .normal)
//      cosButton.setTitle("cos^-1", for: .normal)
//      cosHButton.setTitle("cosh^-1", for: .normal)
//      tanButton.setTitle("tan^-1", for: .normal)
//      tanHButton.setTitle("tanh^-1", for: .normal)
//      exButton.setTitle("y^x", for: .normal)
//      tenXButton.setTitle("2^x", for: .normal)
//      lnButton.setTitle("logx", for: .normal)
//      log10Button.setTitle("log2", for: .normal)
//      flagSecondMode = false
//    } else {
//      sinHButton.setTitle("sinh", for: .normal)
//      sinButton.setTitle("sin", for: .normal)
//      cosButton.setTitle("cos", for: .normal)
//      cosHButton.setTitle("cosh", for: .normal)
//      tanButton.setTitle("tan", for: .normal)
//      tanHButton.setTitle("tanh", for: .normal)
//      exButton.setTitle("e^x", for: .normal)
//      tenXButton.setTitle("10^x", for: .normal)
//      lnButton.setTitle("ln", for: .normal)
//      log10Button.setTitle("log10", for: .normal)
//      flagSecondMode = true
//    }
//  }
//  //MARK: forward buttons
//  @IBAction func backButton(_ sender: Any) {
//    flagForFindOperandBack = true
//    if stack.currentIndex != 0 {
//      stack.currentIndex = stack.currentIndex! - 1
//      for operation in singleOperation {
//        if stack.arrayNumber[stack.currentIndex!] == operation {
//          operand = operation
//          resultLabel.text = stack.arrayNumber[stack.currentIndex!]
//          firstNumber = Double(stack.arrayNumber[stack.currentIndex! - 1])! ///
//          flagForFindOperandBack = false
//          flag = true
//        }
//      }
//      for operation in doubleOperation {
//        if stack.arrayNumber[stack.currentIndex!] == operation {
//          operand = operation
//          resultLabel.text = stack.arrayNumber[stack.currentIndex!]
//          firstNumber = Double(stack.arrayNumber[stack.currentIndex! - 1])! ///
//          flagForFindOperandBack = false
//          flag = true
//        }
//      }
//      if flagForFindOperandBack == true{
//        resultLabel.text = stack.arrayNumber[stack.currentIndex!]
//        if operand != "" {
//          math(operand)
//        }
//      }
//    }
//  }
//
//  @IBAction func forwardButton(_ sender: Any) {
//    flagForFindOperandForward = true
//    if stack.currentIndex! < stack.arrayNumber.count - 1 {
//      stack.currentIndex = stack.currentIndex! + 1
//      for operation in singleOperation {
//        // Вопрос, можно ли эти два цикла объединить? Код в них идентичен, кроме массивов, которые просматриваются?
//        if stack.arrayNumber[stack.currentIndex!] == operation {
//          operand = operation
//          resultLabel.text = stack.arrayNumber[stack.currentIndex!]
//          firstNumber = Double(stack.arrayNumber[stack.currentIndex! - 1])!
//          flagForFindOperandForward = false
//          flag = true
//        }
//      }
//      for operation in doubleOperation {
//        if stack.arrayNumber[stack.currentIndex!] == operation {
//          operand = operation
//          resultLabel.text = stack.arrayNumber[stack.currentIndex!]
//          firstNumber = Double(stack.arrayNumber[stack.currentIndex! - 1])!
//          flagForFindOperandForward = false
//          flag = true
//        }
//      }
//
//      if flagForFindOperandBack == true{
//        resultLabel.text = stack.arrayNumber[stack.currentIndex!]
//        if operand != "" {
//          math(operand)
//        }
//      }
//    }
//  }
//  @IBAction func clearStack(_ sender: Any) {
//    stack.arrayNumber.removeAll()
//  }
//}
////MARK: extension for clear and decimal
//extension CalculatorViewController {
//  fileprivate func clear() {
//    operand = ""
//    firstNumber = 0
//    secondNumber = 0
//    resultLabel.text = "0"
//    flag = false
//    decimalFlag = 0
//    power = 1
//    flagForNumberOeprationFirst = false
//    flagForNumberOperationSecond = false
//  }
//  fileprivate func decimal() {
//    if decimalFlag == 0 {
//      decimalFlag = 1
//      resultLabel.text = resultLabel.text! + ","
//    }
//  }
//}
//
