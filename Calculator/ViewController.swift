//
//  ViewController.swift
//  Calculator
//
//  Created by Martin Liu on 1/26/15.
//  Copyright (c) 2015 Martin Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsTyping = false //all properties have to be initialized in swift
    
    @IBOutlet weak var history: UILabel!
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!//let declares constant var, hold option for documentation
        if userIsTyping{
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsTyping = true
        }
                //println("digit = \(digit)")
    }
    
    
    
    @IBAction func reset(sender: UIButton) {
        if let result = sender.currentTitle{
            displayValue = 0.0
            brain.clearStack()
        }
    }
    @IBAction func doOp(sender: UIButton){
        if userIsTyping{
            enter()
        }
        if let operation = sender.currentTitle{
            
            if let result = brain.performOperation(operation)
            {
                displayValue = result
            }else
            {
                displayValue = 0.0
            }
        }

        
    
    }
    
    
    @IBAction func enter() {
        userIsTyping = false

        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0.0
        }
    }
    
    var displayValue: Double {
        get {
            return display.text != "π" ? NSNumberFormatter().numberFromString(display.text!)!.doubleValue : M_PI
        }
        set{
            display.text = "\(newValue)"
            userIsTyping = false
        }
    }
    
    var historyValue: string {
        get {
            
        }
    }
}

