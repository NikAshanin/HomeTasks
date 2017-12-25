import Foundation
enum Operation {
    case constant (Double)
    case unaryOperation ((Double) -> Double, ((Double) -> Bool?)?)
    case geomOperation ((Double) -> Double)
    case changeOperation ((Double) -> Double)
    case binaryOperation ((Double, Double) -> Double)
    case equals
    case clearAc
}
