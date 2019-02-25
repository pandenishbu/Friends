//
//  ConvData.swift
//  Friends
//
//  Created by Mary Milchenko on 25.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}

func randomArray() -> [(String, Bool)] {
    var Array: [(String, Bool)] = []
    let kol = Int(arc4random_uniform(10) + 10)
    for _ in 1...kol {
        let messageLength =  Int.random(in: 10...200)
        let messageType = Bool.random()
        Array.append((randomString(length: messageLength), messageType))
    }
    return Array
}
