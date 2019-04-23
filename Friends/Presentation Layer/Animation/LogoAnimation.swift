//
//  LongPressHandler.swift
//  Friends
//
//  Created by Mary Milchenko on 23.04.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation

protocol LogoAnimationProtocol: class {

    func startAnimation(with touch: UITouch)
    func stopAnimation()
}

class LogoAnimation: LogoAnimationProtocol {

    var objects: [UIImageView]?
    var touched = false
    var timer: Timer?

    func startAnimation(with touch: UITouch) {
        if self.objects == nil {
            self.objects = []
        }
        if self.timer == nil {
            self.startTimer(touch: touch)
        }
    }

    func stopAnimation() {
        self.stopTimer()
        self.deleteObjects()
    }

    private func startTimer(touch: UITouch) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
            if var view = touch.view {
                guard let window = view.window else {
                    assertionFailure()
                    return
                }
                view =  window.subviews[0]
                let object = UIImageView(frame: CGRect(origin: touch.location(in: view), size: CGSize(width: 50, height: 50)))
                object.image = UIImage(named: "tinkoff")
                self.objects?.append(object)
                view.addSubview(object)
                Animation.logoAnimation(view: object)
            }
        })

    }

    private func stopTimer() {
        if self.timer != nil {
            self.timer = nil
        }
    }

    private func deleteObjects() {
        if self.objects != nil {
            for object in self.objects! {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    object.removeFromSuperview()
                })
            }
        }
    }

}
