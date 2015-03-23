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
        oprandStack.removeAll()
        userIsInTheMiddleOfTypingANumber = false
        println("cleared")
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if oprandStack.count >= 2 {
            displayValue = operation(oprandStack.removeLast(), oprandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double) -> Double) {
        if oprandStack.count >= 1 {
            displayValue = operation(oprandStack.removeLast())
            enter()
        }
    }
    
    
    var oprandStack = Array<Double>()
    
    func updateHistory () {
        let text = "\(oprandStack)"
        history.text = text
    }
    
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
//        oprandStack.append(displayValue!)
//        println("oprandStack: \(oprandStack)")
        
        updateHistory()
    }
    
    var displayValue: Double? {
        get {
            if display.text == nil {
                return nil
            }
            
            if display.text! == "π" {
                return 3.1415926
            }
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    

}

