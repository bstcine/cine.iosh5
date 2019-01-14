//
//  BCMineVC.swift
//  iPhone
//
//  Created by 李党坤 on 2019/1/11.
//  Copyright © 2019 com.bstcine.www. All rights reserved.
//

import UIKit
import cine

class BCMineVC: BCWebVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlString = H5_URL_STRING(path: .mine)
    }

}
