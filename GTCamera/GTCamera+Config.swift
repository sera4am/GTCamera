//
//  GTCamera+Config.swift
//  Pods_GTCamera
//
//  Created by 風間剛男 on 2020/03/31.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

struct GTCamera_Config {
    
    var tabButtonTintColor:UIColor = .darkGray
    var tabButtonTintHighlightColor:UIColor = .lightGray
    var backgroundColor:UIColor = .black
    
    var awsS3Enabled:Bool = false
    var awsS3ConfigKey:String? = nil
    var awsS3Bucket:String? = nil
    var awsS3PrefixPath:String? = nil
    var awsS3AllowImageExtensions:[String] = ["jpg", "png", "jpeg", "gif", "tiff", "bmp", "ico", "cur"]
    
    var libraryEnabled:Bool = true
    
    var tabButtonIconLibrary:UIImage? = UIImage(systemName: "folder")
    var tabButtonIconCamera:UIImage? = UIImage(systemName: "camera")
    var tabButtonIconAwsS3:UIImage? = UIImage(systemName: "timer")
    var tabButtonIconSize:CGFloat = 20
    var tabButtonFont:UIFont = UIFont(name: "Arial", size: 14)!
    var tabButtonTextColor:UIColor = .gray
    var tabButtonHighLightTextColor:UIColor = .lightGray
    var tabSpacing:CGFloat = 8
    
    var cameraButtonLabelFont:UIFont = UIFont(name: "Arial", size: 12)!
    
    var cameraFlashButtonAutoIcon:UIImage = UIImage(systemName: "bolt")!
    var cameraFlashButtonOnIcon:UIImage = UIImage(systemName: "bolt.fill")!
    var cameraFlashButtonOffIcon:UIImage = UIImage(systemName: "bolt.slash.fill")!
    
    var cameraRotateButtonIconFront:UIImage = UIImage(systemName: "camera.rotate")!
    var cameraRotateButtonIconBack:UIImage = UIImage(systemName: "camera.rotate.fill")!
    var cameraCameraButtonIcon:UIImage = UIImage(systemName: "camera.circle")!
    
    var previewButtonIconClose:UIImage? = UIImage(systemName: "xmark.circle")
    var previewButtonIconEdit:UIImage? = UIImage(systemName: "pencil.circle")
    var previewButtonIconUndo:UIImage? = UIImage(systemName: "arrow.uturn.left.circle")
    var previewButtonIconContinue:UIImage? = UIImage(systemName: "arrow.right.circle")
    var previewButtonTitleClose:String? = nil
    var previewButtonTitleEdit:String? = nil
    var previewButtonTitleUndo:String? = nil
    var previewButtonTitleContinue:String? = nil
    var previewButtonTextColor:UIColor = .link
    
    var awsS3LoadErrorIcon:UIImage = UIImage(systemName: "cloud.hail.fill")!
    var awsS3LoadLoadingIcon:UIImage = UIImage(systemName: "clock.fill")!
}
