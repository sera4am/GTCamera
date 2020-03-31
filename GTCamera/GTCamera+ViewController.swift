//
//  GTCamera+ViewController.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/30.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

class GTCamera_ViewController: UIViewController {

    var gtCamera:GTCameraViewController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ gtCamera:GTCameraViewController) {
        self.init()
        self.gtCamera = gtCamera
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
