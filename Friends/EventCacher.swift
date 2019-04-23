//
//  EventCacher.swift
//  Friends
//
//  Created by Mary Milchenko on 23.04.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

@objc(Friends) class Friends: UIApplication {

    var logoAnimation: LogoAnimationProtocol = LogoAnimation()

    override func sendEvent(_ event: UIEvent) {

        if event.type != .touches {
            super.sendEvent(event)
            return
        }
        var restartTimer = true
        var touch: UITouch?

        if let touches = event.allTouches {
            if let first = touches.first {
                touch = first
            }
            for touch in touches.enumerated() {
                if touch.element.phase != .cancelled && touch.element.phase != .ended {
                    restartTimer = false
                    break
                }
            }
        }

        if restartTimer {
            self.logoAnimation.stopAnimation()
        } else if let touch = touch {
            self.logoAnimation.startAnimation(with: touch)
        }

        super.sendEvent(event)
    }
}
