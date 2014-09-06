//
//  FirstViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        let user = PFUser.currentUser()
        let object = PFObject(className: "Insulin", dictionary: [
            "type": "value",
        ])
    }

}
