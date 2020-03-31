//
//  GTCamera+Config.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/31.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

public struct GTCamera_Config {
    
    public var tabButtonTintColor:UIColor = .darkGray
    public var tabButtonTintHighlightColor:UIColor = .lightGray
    public var backgroundColor:UIColor = .black
    
    public var awsS3Enabled:Bool = false
    public var awsS3ConfigKey:String? = nil
    public var awsS3Bucket:String? = nil
    public var awsS3PrefixPath:String? = nil
    public var awsS3AllowImageExtensions:[String] = ["jpg", "png", "jpeg", "gif", "tiff", "bmp", "ico", "cur"]
    
    public var libraryEnabled:Bool = true
    
    public var tabButtonIconLibrary:UIImage? = UIImage(systemName: "folder")
    public var tabButtonIconCamera:UIImage? = UIImage(systemName: "camera")
    public var tabButtonIconAwsS3:UIImage? = UIImage(systemName: "timer")
    public var tabButtonIconSize:CGFloat = 20
    public var tabButtonFont:UIFont = UIFont(name: "Arial", size: 14)!
    public var tabButtonTextColor:UIColor = .gray
    public var tabButtonHighLightTextColor:UIColor = .lightGray
    public var tabSpacing:CGFloat = 8
    
    public var cameraButtonLabelFont:UIFont = UIFont(name: "Arial", size: 12)!
    
    public var cameraFlashButtonAutoIcon:UIImage = UIImage(systemName: "bolt")!
    public var cameraFlashButtonOnIcon:UIImage = UIImage(systemName: "bolt.fill")!
    public var cameraFlashButtonOffIcon:UIImage = UIImage(systemName: "bolt.slash.fill")!
    
    public var cameraRotateButtonIconFront:UIImage = UIImage(systemName: "camera.rotate")!
    public var cameraRotateButtonIconBack:UIImage = UIImage(systemName: "camera.rotate.fill")!
    public var cameraCameraButtonIcon:UIImage = UIImage(systemName: "camera.circle")!
    
    public var previewButtonIconClose:UIImage? = UIImage(systemName: "xmark.circle")
    public var previewButtonIconEdit:UIImage? = UIImage(systemName: "pencil.circle")
    public var previewButtonIconUndo:UIImage? = UIImage(systemName: "arrow.uturn.left.circle")
    public var previewButtonIconContinue:UIImage? = UIImage(systemName: "arrow.right.circle")
    public var previewButtonTitleClose:String? = nil
    public var previewButtonTitleEdit:String? = nil
    public var previewButtonTitleUndo:String? = nil
    public var previewButtonTitleContinue:String? = nil
    public var previewButtonTextColor:UIColor = .link
    
    public var awsS3LoadErrorIcon:UIImage = UIImage(systemName: "cloud.hail.fill")!
    public var awsS3LoadLoadingIcon:UIImage = UIImage(systemName: "clock.fill")!
    
    public init() {}
}
