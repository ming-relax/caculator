//
//  ViewController.swift
//  Calculator
//
//  Created by HU Ming on 14/3/15.
//  Copyright (c) 2015 HU Ming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enterConstant(sender: UIButton) {
        
        userIsInTheMiddleOfTypingANumber = false
    
        let symbol = sender.currentTitle
        if symbol == nil {
            return
        }
        
        if let result = brain.pushOprand(symbol!) {
            displayValue = result
        } else {
            displayValue = 0
        }
        updateHistory()
    }
    
    
    @IBAction func setVariable(sender: UIButton) {
        if let symbol = sender.currentTitle? {
            brain.variableValues[symbol] = displayValue
        }
    }

    
    @IBAction func enterVariable(sender: UIButton) {
        if let symbol = sender.currentTitle? {
            brain.pushOprand(symbol)
        }
    
    }
    
    // enter() is used to push the current operand into brain/stack
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue == nil {
            return
        }
        if let result = brain.pushOprand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
        updateHistory()
    }
    
    // operate() is used to performOperation on the current operand (or with 
    // the previous operand)
    // so we need to call enter() again to push the current operand into brain/stack
    // after the result is caculated, the result should also be pushed into brain/stack
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
    
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }

    }
    
    @IBAction func clear() {
        displayValue = 0
        brain.clear()
        userIsInTheMiddleOfTypingANumber = false
        println("cleared")
    }
    
    
    func updateHistory () {
        println("updateHistory: \(brain)")
        history.text = "\(brain)"
    }
    
    var displayValue: Double? {
        get {
            
//            if display.text? == "π" {
//                return 3.1415926
//            }
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

