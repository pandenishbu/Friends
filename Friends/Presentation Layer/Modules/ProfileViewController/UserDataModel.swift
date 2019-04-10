//
//  Peer.swift
//  Friends
//
//  Created by Mary Milchenko on 19.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

class UserDataModel {
    var name: String?
    var descr: String?
    var photo: Data?

    var nameChanged: Bool = false
    var descriptionChanged: Bool = false
    var photoChanged: Bool = false

    init() {}

    init(name: String?, descr: String?, image: Data?) {
        self.name = name
        self.descr = descr
        self.photo = image
    }

}
