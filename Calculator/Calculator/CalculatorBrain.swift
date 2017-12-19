import Foundation

final class CalculatorBrain {
    typealias Operation = (Double, Double) -> Double

    let ops: [AvailableOperations: Operation] = [.plus: plus, .minus: minus, .multiply: multiply, .divide: divide,
                                                 .sqrt: sqrt, .pow: numberPow,
                                                 .fact: fact, .log: log, .sin: sin, .cos: cos, .tan: tan,
                                                 .sinh: sinh, .cosh: cosh, .tanh: tanh, .arcsin: arcsin,
                                                 .arccos: arccos, .arctan: arctan, .arcsinh: arcsinh,
                                                 .arccosh: arccosh, .arctanh: arctanh, .numberPow: numberPow]

    static func plus(_ firstValue: Double, secondValue: Double) -> Double {
        let result = firstValue + secondValue
        return result
    }

    static func minus(_ firstValue: Double, secondValue: Double) -> Double {
        let result = firstValue - secondValue
        return result
    }

    static func multiply(_ firstValue: Double, secondValue: Double) -> Double {
        let result = firstValue * secondValue
        return result
    }

    static func divide(_ firstValue: Double, secondValue: Double) -> Double {
        if secondValue != 0 {
            let result = firstValue / secondValue
            return result
        } else {
            return 0
        }
    }

    static func sin(firstValue: Double, _: Double) -> Double {
        return Darwin.sin(firstValue)
    }

    static func cos(firstValue: Double, _: Double) -> Double {
        return Darwin.cos(firstValue)
    }

    static func tan(firstValue: Double, _: Double) -> Double {
        return Darwin.tan(firstValue)
    }

    static func sinh(firstValue: Double, _: Double) -> Double {
        return Darwin.sinh(firstValue)
    }

    static func cosh(firstValue: Double, _: Double) -> Double {
        return Darwin.cosh(firstValue)
    }

    static func tanh(firstValue: Double, _: Double) -> Double {
        return Darwin.tanh(firstValue)
    }

    static func arcsin(firstValue: Double, _: Double) -> Double {
        return asin(firstValue)
    }

    static func arccos(firstValue: Double, _: Double) -> Double {
        return acos(firstValue)
    }

    static func arctan(firstValue: Double, _: Double) -> Double {
        return atan(firstValue)
    }

    static func arcsinh(firstValue: Double, _: Double) -> Double {
        return asinh(firstValue)
    }

    static func arccosh(firstValue: Double, _: Double) -> Double {
        return acosh(firstValue)
    }

    static func arctanh(firstValue: Double, _: Double) -> Double {
        return atanh(firstValue)
    }

    static func log(base: Double, number: Double) -> Double {
        if base == M_E {
            return Darwin.log(number)
        } else {
            return Darwin.log(number) / Darwin.log(base)
        }
    }

    static func fact(number: Double, _: Double) -> Double {
        var fact = 1

        for i in 1...Int(number) {
            fact *= i
        }
        return Double(fact)
    }

    static func sqrt(_ firstValue: Double, secondValue: Double) -> Double {
        return pow(firstValue, (1 / secondValue))
    }

    static func numberPow(number: Double, secondValue: Double) -> Double {
        if number == M_E {
            return exp(secondValue)
        }
        return pow(number, secondValue)
    }
}
