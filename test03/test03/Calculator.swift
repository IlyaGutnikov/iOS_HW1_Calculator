
import Foundation

class Calculator {
    
    private struct PendingBinaryOperation {
        let firstOperand: Double
        let operation: ((Double, Double) -> Double)
    }
    
    private enum OperationType {
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equal
    }

    private var pendingOperation: PendingBinaryOperation? = nil
    
    private var accumulator = 0.0
    
    static func factorial(number: Double) -> Double {
        
        if (number <= 1) {
            return 1
        }
        
        return number * factorial(number: number - 1)
    }
    
   static func mod(dividend: Double, divider: Double) -> (Double) {
        
        return dividend.truncatingRemainder(dividingBy: divider)
    }
    
    private var operations: [String: OperationType] = [
        "√": OperationType.unary(sqrt),
        "^2": OperationType.unary({ $0*$0 }),
        "π": OperationType.unary({_ in return M_PI }),
        "+": OperationType.binary({ $0 + $1 }),
        "-": OperationType.binary({ $0 - $1 }),
        "/": OperationType.binary({ $0 / $1 }),
        "*": OperationType.binary({ $0 * $1 }),
        "^": OperationType.binary({pow($0, $1)}),
        "!": OperationType.unary({Calculator.factorial(number: $0)}),
        "mod": OperationType.binary({Calculator.mod(dividend: $0, divider: $1)}),
        "=": OperationType.equal
    ]
    
    
    func setNumber(number: Double) {
        self.accumulator = number
    }
    
    func performOperation(operation: String) -> Double {
        guard let op = operations[operation] else {
            return -1
        }
        
        switch op {
        case .unary(let f):
            return f(accumulator)

        case .binary(let f):
            pendingOperation = PendingBinaryOperation(firstOperand: accumulator, operation: f)
            return accumulator
            
        case .equal:
            if let pending = pendingOperation {
                pendingOperation = nil
                return pending.operation(pending.firstOperand, accumulator)
            } else {
                return accumulator
            }
        }
    }
}
