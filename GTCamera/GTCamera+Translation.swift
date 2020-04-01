//
//  GTCamera+Translation.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/31.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

public struct GTCamera_Translation {

    public var tabTitleLibrary:String = "Library"
    public var tabTitleCamera:String = "Camera"
    public var tabTitleAWSS3:String = "History"
    
    public var buttonTitleFlashAuto:String = "Auto"
    public var buttonTitleFlashOn:String = "On"
    public var buttonTitleFlashOff:String = "Off"
    
    public var buttonTitleCameraFront:String? = "Front"
    public var buttonTitleCameraBack:String? = "Back"
    
    public var buttonTitleUseThis:String = "Use this"
    
    public var buttonTitleCropBack:String = "Back"
    public var buttonTitleCropDone:String = "Done"
    
    public var messageAWSS3NoImages:String = "No images available"
    public var messageAWSS3LoadError:String = "Load images error"
    public var messageAWSS3Loading:String = "Loading image..."
    public var messageAWSS3Invalid:String = "Invalid AWS S3 not available\n[awsS3Enabled turned true with another aws config]"
    public var messageAWSS3UndefinedSetting:String = "Config need Aws Settting\n [awsS3Enabled and awsS3Bucket with awsS3ConfigKey and awsS3PrefixPath if need]"
    
    public static var Default:GTCamera_Translation = GTCamera_Translation()
    
    public init() {}
    public init(_ locale:Locale) {}
}
