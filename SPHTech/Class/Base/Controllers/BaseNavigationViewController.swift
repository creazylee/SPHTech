//
//  BaseNavigationViewController.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBar.isTranslucent = false
    }
}
