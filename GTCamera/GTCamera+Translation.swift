//
//  GTCamera+Translation.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/31.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

public struct GTCamera_Translation {

    // # Button title for base views bottom buttons
    public var tabTitleLibrary:String = "Library"
    public var tabTitleCamera:String = "Camera"
    public var tabTitleAWSS3:String = "Uploaded"
    
    // # Button title for flash button for Camera View
    public var buttonTitleFlashAuto:String = "Auto"
    public var buttonTitleFlashOn:String = "On"
    public var buttonTitleFlashOff:String = "Off"
    
    // # Button title for camera rotate button for Camera view
    public var buttonTitleCameraFront:String? = "Front"
    public var buttonTitleCameraBack:String? = "Back"
    
    // # Button title for choice button for Preview view
    public var buttonTitleUseThis:String = "Use this"
    
    // # Button title for crop button for Crop view
    public var buttonTitleCropBack:String = "Back"
    public var buttonTitleCropDone:String = "Done"
    
    // # Message text for aws s3 view
    public var messageAWSS3NoImages:String = "No images available"
    public var messageAWSS3LoadError:String = "Load images error"
    public var messageAWSS3Loading:String = "Loading image..."
    public var messageAWSS3Invalid:String = "Invalid AWS S3 not available\n[awsS3Enabled turned true with another aws config]"
    public var messageAWSS3UndefinedSetting:String = "Config need Aws Settting\n [awsS3Enabled and awsS3Bucket with awsS3ConfigKey and awsS3PrefixPath if need]"
    
    public static var Default:GTCamera_Translation = GTCamera_Translation(true)
    
    private init(_ default:Bool) {
    }
    
    public init() {
        
        tabTitleLibrary = GTCamera_Translation.Default.tabTitleLibrary
        tabTitleCamera = GTCamera_Translation.Default.tabTitleCamera
        tabTitleAWSS3 = GTCamera_Translation.Default.tabTitleAWSS3
        buttonTitleFlashAuto = GTCamera_Translation.Default.buttonTitleFlashAuto
        buttonTitleFlashOn = GTCamera_Translation.Default.buttonTitleFlashOn
        buttonTitleFlashOff = GTCamera_Translation.Default.buttonTitleFlashOff
        buttonTitleCameraFront = GTCamera_Translation.Default.buttonTitleCameraFront
        buttonTitleCameraBack = GTCamera_Translation.Default.buttonTitleCameraBack
        buttonTitleUseThis = GTCamera_Translation.Default.buttonTitleUseThis
        buttonTitleCropBack = GTCamera_Translation.Default.buttonTitleCropBack
        buttonTitleCropDone = GTCamera_Translation.Default.buttonTitleCropDone
        messageAWSS3NoImages = GTCamera_Translation.Default.messageAWSS3NoImages
        messageAWSS3LoadError = GTCamera_Translation.Default.messageAWSS3LoadError
        messageAWSS3Loading = GTCamera_Translation.Default.messageAWSS3Loading
        messageAWSS3Invalid = GTCamera_Translation.Default.messageAWSS3Invalid
        messageAWSS3UndefinedSetting = GTCamera_Translation.Default.messageAWSS3UndefinedSetting
    }
}
