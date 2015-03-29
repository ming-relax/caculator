//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by HU Ming on 23/3/15.
//  Copyright (c) 2015 HU Ming. All rights reserved.
//

import Foundation


class CalculatorBrain: Printable {
    private enum Op: Printable {
        case Oprand(Double)
        case Constant(String)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Oprand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Constant(let symbol):
                    return symbol
                case .Variable(let variable):
                    return variable
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private var constantMapping = [
        "π": 3.1415926
    ]
    
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Oprand(let oprand):
                return (oprand, remainingOps)
            case .Constant(let symbol):
                return (constantMapping[symbol], remainingOps)
            case .Variable(let symbol):
                if let variable = variableValues[symbol] {
                    return (variable, remainingOps)
                } else {
                    return (nil, remainingOps)
                }
            case .UnaryOperation(let symbol, let operation):
                let operationEvaluation = evaluate(remainingOps)
                if let operand = operationEvaluation.result {
                   return (operation(operand), operationEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    
    var variableValues = Dictionary<String, Double>()
    
    // description of the brain
    var description :String {
        return "brain"
    }

    init() {
        
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", {$1 - $0}))
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷", {$1 / $0}))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        //println("brain: \(resultDescription)")
        return result
    }
    
    func pushOprand(oprand: Double) -> Double? {
        opStack.append(Op.Oprand(oprand))
        return evaluate()
    }
    
    // push a variable or constant into stack
    func pushOprand(symbol: String) -> Double? {
        if constantMapping[symbol] != nil {
            opStack.append(Op.Constant(symbol))
        } else {
            opStack.append(Op.Variable(symbol))
        }
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack.removeAll(keepCapacity: false)
        variableValues.removeAll(keepCapacity: false)
    }
    
}