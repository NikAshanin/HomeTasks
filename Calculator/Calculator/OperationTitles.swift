import Foundation

final class OperationTitles {
    private static let availableStates: [(String, String)] = [
        ("e^x", "yˣ"),
        ("10^x", "2^x"),
        ("ln", "logᵧ"),
        ("log10", "log₂"),
        ("sin", "sin^-1"),
        ("cos", "cos^-1"),
        ("tan", "tan^-1"),
        ("sinh", "sinh^-1"),
        ("cosh", "cosh^-1"),
        ("tanh", "tanh^-1")
    ]

    static func switchStateForButton(withTitle: String) -> String {
        for (firstState, secondState) in availableStates {
            if withTitle == firstState {
                return secondState
            } else if withTitle == secondState {
                return firstState
            }
        }
        // Если в массиве нет такого тайтла, то передали не парный тайтл и мы его возвращаем
        return withTitle
    }
}
