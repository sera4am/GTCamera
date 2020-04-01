//
//  GTCamera+EditorViewController.swift
//  Pods_GTCamera
//
//  Created by 風間剛男 on 2020/03/31.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

class GTCamera_FilterViewController: UIViewController {

    var gtCamera:GTCameraViewController!
    var image:UIImage? = nil
    var url:URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ gtCamera:GTCameraViewController, _ image:UIImage?, _ url:URL?) {
        self.init()
        self.image = image
        self.url = url
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initView() {
        
    }
    

}
