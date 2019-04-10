//
//  CustomNotifications.swift
//  Friends
//
//  Created by Mary Milchenko on 19.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didRecievedMsg = Notification.Name("didRecievedMsg")
    static let needReloadData = Notification.Name("needReloadData")
    static let becomeOnline = Notification.Name("becomeOnline")
    static let becomeOffline = Notification.Name("becomeOffline")
}
