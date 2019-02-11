//
//  Log.swift
//  Friends
//
//  Created by Mary Milchenko on 11.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

class Log {
    
    func AppDLogger(from: String, to: String, function: String = #function) {
        #if DEBUG
            print("Application moved from \(from) to \(to): \(function)")
        #endif
    }
    
    func VCLogger(message: String, function: String = #function) {
        #if DEBUG
        print("\(function) - \(message)")
        #endif
    }
    
}
