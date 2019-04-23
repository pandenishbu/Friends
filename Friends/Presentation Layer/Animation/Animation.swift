//
//  Animation.swift
//  Friends
//
//  Created by Mary Milchenko on 23.04.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

struct Animation {

    static func animateButton(button: UIButton, isEnable: Bool) {
        let oldButtonFrame = button.frame
        UIView.transition(with: button, duration: 0.15, options: .transitionCrossDissolve, animations: {
            button.tintColor = isEnable ? UIColor.blue : UIColor.red
        }, completion: { _ in
            button.isEnabled = isEnable
        })
        UIView.animate(withDuration: 0.5, animations: {

            button.frame.size.height = oldButtonFrame.size.height * CGFloat(1.15)
            button.frame.size.width = oldButtonFrame.size.width * CGFloat(1.15)
            button.frame.origin = CGPoint(x: oldButtonFrame.origin.x + oldButtonFrame.width - button.frame.width, y: oldButtonFrame.origin.y + oldButtonFrame.height - button.frame.height)
            button.isEnabled = isEnable

        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                button.frame.origin = oldButtonFrame.origin
                button.frame.size = oldButtonFrame.size
            })
        })
    }

    static func animateTitle(label: UILabel, isOnline: Bool) {
        UIView.transition(with: label, duration: 1, options: .transitionCrossDissolve, animations: {
            label.textColor = isOnline ? UIColor.green : UIColor.black
        })
        UIView.animate(withDuration: 1, animations: {
            let height = label.frame.size.height
            if isOnline {
                label.frame.size.height = height * CGFloat(1.10)
                label.frame.size.width = height * CGFloat(1.10)
            } else {
                label.frame.size.height = height * CGFloat(0.9)
                label.frame.size.width = height * CGFloat(0.9)
            }
        })
    }

    static func logoAnimation(view: UIView) {
        let animationFading = CABasicAnimation(keyPath: "position")
        let param = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 2
        let xPoint = view.layer.position.x * param
        let newPosition = CGPoint(x: xPoint, y: UIScreen.main.bounds.height)
        animationFading.fromValue = view.layer.position
        animationFading.toValue = newPosition
        animationFading.duration = 5
        view.layer.position = newPosition

        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.fromValue = view.layer.opacity
        animationOpacity.toValue = 0
        animationOpacity.duration = 5
        view.layer.opacity = 0

        view.layer.add(animationFading, forKey: "fading")
        view.layer.add(animationOpacity, forKey: "invisible")
    }

}
