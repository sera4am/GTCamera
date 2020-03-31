//
//  GTCamera+Transition.swift
//  Pods_GTCamera
//
//  Created by 風間剛男 on 2020/03/31.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

struct GTCamera_Transition {

    var tabTitleLibrary:String = "Library"
    var tabTitleCamera:String = "Camera"
    var tabTitleAWSS3:String = "History"
    
    var buttonTitleFlashAuto:String = "Auto"
    var buttonTitleFlashOn:String = "On"
    var buttonTitleFlashOff:String = "Off"
    
    var buttonTitleCameraFront:String? = "Front"
    var buttonTitleCameraBack:String? = "Back"
    
    var buttonTitleUseThis:String = "Use this"
    
    var buttonTitleCropBack:String = "Back"
    var buttonTitleCropDone:String = "Done"
    
    var messageAWSS3NoImages:String = "No images available"
    var messageAWSS3LoadError:String = "Load images error"
    var messageAWSS3Loading:String = "Loading image..."
    var messageAWSS3Invalid:String = "Invalid AWS S3 not available\n[awsS3Enabled turned true with another aws config]"
    var messageAWSS3UndefinedSetting:String = "Config need Aws Settting\n [awsS3Enabled and awsS3Bucket with awsS3ConfigKey and awsS3PrefixPath if need]"
    
}
