//
//  ViewController.swift
//  Friends
//
//  Created by Mary Milchenko on 11.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let log = Log()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        log.VCLogger(message: "the view of the view controller has been created")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        log.VCLogger(message: "view controller comes on screen")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        log.VCLogger(message: "called after the view controller appears on screen")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        log.VCLogger(message: "called every time the frame changes")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        log.VCLogger(message: "called to notify the view controller that its view has just laid out its subviews")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        log.VCLogger(message: "called before the transition to the next view controller happens and the origin view controller gets removed from screen")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        log.VCLogger(message: "called after a view controller gets removed from the screen")
    }
    


}

