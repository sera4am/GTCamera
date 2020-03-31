//
//  GTCamera+ViewController.swift
//  Pods_GTCamera
//
//  Created by 風間剛男 on 2020/03/30.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

class GTCamera_ViewController: UIViewController {

    var gtCamera:GTCamera!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ gtCamera:GTCamera) {
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
