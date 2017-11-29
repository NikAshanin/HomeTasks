struct UndoStep {
    let digitString: String
    let binaryOperation: String
    let newLine: Bool

    init(_ digitString: String, _ binaryOperation: String, _ newLine: Bool) {
        self.digitString = digitString
        self.binaryOperation = binaryOperation
        self.newLine = newLine
    }
}
