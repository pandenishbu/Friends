//
//  GCDDataManager.swift
//  Friends
//
//  Created by Mary Milchenko on 13.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

class GCDDataManager {
    
    var name: String
    var photo: String
    var description: String
    
    private let concurrentQueue = DispatchQueue(label: "concurrency.friend.concurrent", attributes: .concurrent)
    
    init(name: String, photo: String, description:String) {
        self.name = name
        self.photo = photo
        self.description = description
    }
    
    func save(type: String, completionHandler: (_ result: Bool) -> Void){
        var isSuccess: Bool
        isSuccess = false
        concurrentQueue.async {
            isSuccess = self.saveData(filename: type)
        }
        completionHandler(isSuccess)
    }

    func load(completionHandler: @escaping (_ txt1: String, _ txt2: String, _ txt3: String) -> Void) {
        concurrentQueue.async {
            let name = self.readData(filename: "name")
            if name != "error" {
                self.name = name
            }
            let photo = self.readData(filename: "photo")
            if photo != "error" {
                self.photo = photo
            }
            let description = self.readData(filename: "description")
            if description != "error" {
                self.description = description
            }
             completionHandler(self.name, self.photo, self.description)
        }
       
    }
    
    private func saveData(filename: String) -> Bool{
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: filename) {
            let file: FileHandle? = FileHandle(forWritingAtPath: filename)
            if file != nil {
                let data = ("Silentium est aureum").data(using: String.Encoding.utf8)
                file?.write(data!)
                file?.closeFile()
                return true
            }
            else { return false }
        }
        else { return false }
    }
    
    private func readData(filename: String) -> String{
        
        if let path = Bundle.main.path(forResource: filename, ofType: "txt"){
            do {
                let content = try String(contentsOfFile:path) as String//encoding: NSUTF8StringEncoding
                return content
            } catch {
                return "error"
            }
        }
        else {return "error"}
    }
}
