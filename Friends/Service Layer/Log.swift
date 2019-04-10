//
//  Log.swift
//  Friends
//
//  Created by Mary Milchenko on 11.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

class Log {

    func appDLogger(from: String, toFunc: String, function: String = #function) {
        #if DEBUG
            print("Application moved from \(from) to \(toFunc): \(function)")
        #endif
    }

    func vCLogger(message: String, function: String = #function) {
        #if DEBUG
        print("\(function) - \(message)")
        #endif
    }
}
