//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Martin Liu on 4/16/15.
//  Copyright (c) 2015 Martin Liu. All rights reserved.
//

import Foundation //model is ui independent so not import UI


class CalculatorBrain{
    private enum Op: Printable{ //protocol
        case Operand(Double)
        case UnaryOperation(String, Double ->  Double) //func are just types, no diff than String
        case BinaryOperation(String, (Double,Double) ->  Double)
        //enum can have computed properties and read-only (no set)

        
        var description: String{
            get {
                switch self{
                case .Operand(let operand):
                    return operand == M_PI ?  "π": "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                    
                    
                }
            }
        }
    }
    
    private var opStack = Array<Op>()
    
    private var knownOps = Dictionary<String, Op>()
    
    init (){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))// same as BinaryOperation("x") {$0 *$1}
        learnOp(Op.BinaryOperation("÷", /))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", -))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        
        learnOp(Op.Operand(M_PI))
        
        
    
        
    }
    
    private func getHistory(var history: String, opstack: [Op]) -> String{
        history += " " + opstack.last!.description
        return history 
    }
    
    func clearStack() -> String{
        opStack.removeAll()
        return "0"
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){ //by default without "var" ops is a "copy" -- a pointer,  and read-only
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
            
        }
        return evaluate()
    }
    
}