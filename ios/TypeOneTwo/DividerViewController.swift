//
//  DividerViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/7/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

class DividerViewController: UIViewController {
    @IBOutlet weak var insulinButton: UIButton!
    @IBOutlet weak var glucoseButton: UIButton!

    let offset: CGFloat = 200.0

    override func viewDidLoad() {
        animate()
    }

    func animate() {
        insulinButton.frame.origin.x += offset
        glucoseButton.frame.origin.x += offset
        let originalColor = view.backgroundColor
        view.backgroundColor = UIColor.whiteColor()

        UIView.animateWithDuration(0.6, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.insulinButton.frame.origin.x -= self.offset
            self.glucoseButton.frame.origin.x -= self.offset
            self.view.backgroundColor = originalColor
        }, completion: nil)

    }

}
