//
//  PeriodicTableElementsUI.swift
//  McMoleculesUI
//
//  Created by Matt Houser on 12/22/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Cocoa
//TODO - debug this
import McMoleculesModel
import McMoleculesUI

protocol PeriodicTableSelectionListener : NSObjectProtocol {
    func elementSelected(_ e: Element)
}
protocol PeriodicTableSelectionBroadcaster : NSObjectProtocol {
    func registerListener(_ listener : PeriodicTableSelectionListener)
    func unRegisterListener(_ listener : PeriodicTableSelectionListener)

}

class PeriodicTableElementsUI: NSViewController, PeriodicTableSelectionBroadcaster {
    
    class PTElementPrinter : NSObject, PeriodicTableSelectionListener {
        func elementSelected(_ e: Element) {
            print (e.rawValue)
        }
    }

    fileprivate var mostRecentButton : NSButton? = nil
    fileprivate var listeners : Array<PeriodicTableSelectionListener> = []
    
    @IBAction func elementButtonClicked(_ sender: AnyObject) {
        if (sender is NSButton) {
            let senderButton : NSButton = sender as! NSButton
            let symbol = senderButton.title
            if let oldButton = self.mostRecentButton {
                oldButton.state = NSOffState
            }
            self.mostRecentButton = sender as? NSButton
            listeners.forEach({ (listener:PeriodicTableSelectionListener) -> () in
                listener.elementSelected(Element(rawValue: symbol)!)
            })
        }
    }
    
    func registerListener(_ listener: PeriodicTableSelectionListener) {
        self.listeners.append(listener)
        print("listener registered")
    }
    
    func unRegisterListener(_ listener: PeriodicTableSelectionListener) {
        if let indexOfListener = listeners.index (where: { $0 === listener}) {
            listeners.remove(at: indexOfListener)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerListener( PTElementPrinter() )
        
    }
    
}
