import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {

    var testCalculation: Calculation!

    override func setUp() {
        super.setUp()
        testCalculation = Calculation()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetOperand() {
        let testCalculation = Calculation()
        testCalculation.setOperand(3.0)
        XCTAssertEqual(testCalculation.result, 3.0)
    }

    func testBinaryOperation() {

        testCalculation.setOperand(9)
        testCalculation.performOperation("+")
        testCalculation.setOperand(1)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 10)

        testCalculation.setOperand(1.2)
        testCalculation.performOperation("-")
        testCalculation.setOperand(0.2)
        testCalculation.performOperation("-")
        XCTAssertEqual(testCalculation.result, 1)
        testCalculation.clearAll()

        testCalculation.setOperand(5)
        testCalculation.performOperation("×")
        testCalculation.setOperand(4)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 20)

        testCalculation.setOperand(9)
        testCalculation.performOperation("÷")
        testCalculation.setOperand(3)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 3)

        testCalculation.setOperand(2)
        testCalculation.performOperation("xʸ")
        testCalculation.setOperand(4)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 16)

        testCalculation.setOperand(27)
        testCalculation.performOperation("ʸ√x")
        testCalculation.setOperand(3)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 3)

        testCalculation.setOperand(2)
        testCalculation.performOperation("EE")
        testCalculation.setOperand(3)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 2_000)
    }

    func testUnaryOperation() {

        testCalculation.setOperand(5)
        testCalculation.performOperation("1/x")
        XCTAssertEqual(testCalculation.result, 0.2)

        testCalculation.setOperand(25)
        testCalculation.performOperation("√x")
        XCTAssertEqual(testCalculation.result, 5)

        testCalculation.setOperand(27)
        testCalculation.performOperation("∛x")
        XCTAssertEqual(testCalculation.result, 3)

        testCalculation.setOperand(9)
        testCalculation.performOperation("%")
        XCTAssertEqual(testCalculation.result, 0.09)

        testCalculation.setOperand(11)
        testCalculation.performOperation("x²")
        XCTAssertEqual(testCalculation.result, 121)

        testCalculation.setOperand(3)
        testCalculation.performOperation("x³")
        XCTAssertEqual(testCalculation.result, 27)

        testCalculation.performOperation("e")
        testCalculation.performOperation("ln")
        XCTAssertEqual(testCalculation.result, 1)

        testCalculation.setOperand(10)
        testCalculation.performOperation("log₁₀")
        XCTAssertEqual(testCalculation.result, 1)

        testCalculation.setOperand(5)
        testCalculation.performOperation("10ˣ")
        XCTAssertEqual(testCalculation.result, 100_000)

        testCalculation.setOperand(5)
        testCalculation.performOperation("x!")
        XCTAssertEqual(testCalculation.result, 120)
    }

    func testUndo() {
        let testCalculation = Calculation()

        // 5 + 3 + 4
        // undo undo undo ( 5 + )
        //  2 = 7
        testCalculation.setOperand(5)
        testCalculation.performOperation("+")
        testCalculation.setOperand(3)
        testCalculation.performOperation("+")
        testCalculation.setOperand(4)
        testCalculation.undoCalculationParameter()
        testCalculation.undoCalculationParameter()
        testCalculation.undoCalculationParameter()
        testCalculation.setOperand(2)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 7)
    }

    func testRedo() {
        let testCalculation = Calculation()

        // 5 + 3 - 4
        // undo undo undo ( 5 + )
        // redo redo ( 5 + 3 - )
        // 1 = 7
        testCalculation.setOperand(5)
        testCalculation.performOperation("+")
        testCalculation.setOperand(3)
        testCalculation.performOperation("-")
        testCalculation.setOperand(4)
        testCalculation.undoCalculationParameter()
        testCalculation.undoCalculationParameter()
        testCalculation.undoCalculationParameter()
        testCalculation.redoCalculationParameter()
        testCalculation.redoCalculationParameter()
        testCalculation.setOperand(1)
        testCalculation.performOperation("=")
        XCTAssertEqual(testCalculation.result, 7)
    }
}
