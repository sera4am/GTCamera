//
//  GTCamera+Config.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/31.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import TOCropViewController

public struct GTCamera_Config {
    
    public var useThisPreviewEnabled:Bool = true
    
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
    
    public var cropEnabled:Bool = true
    public var cropAspectRaitoPreset:TOCropViewControllerAspectRatioPreset = .preset4x3
    public var cropEnableAspectRaitoSelector:Bool = true
    public var cropResetAspectRaitoEnabled:Bool = true
    public var cropAspectRaitoPickerButtonHidden:Bool = false
    public var cropResetButtonHidden:Bool = false
    public var cropRotateButtonsHidden:Bool = false
    public var cropAspectRatioLockEnabled:Bool = false
    
    public static var Default:GTCamera_Config = GTCamera_Config(true)
    
    private init(_ config:Bool) {}
    
    public init() {
        useThisPreviewEnabled = GTCamera_Config.Default.useThisPreviewEnabled
        tabButtonTintColor = GTCamera_Config.Default.tabButtonTintColor
        tabButtonTintHighlightColor = GTCamera_Config.Default.tabButtonTintHighlightColor
        backgroundColor = GTCamera_Config.Default.backgroundColor
        awsS3Enabled = GTCamera_Config.Default.awsS3Enabled
        awsS3ConfigKey = GTCamera_Config.Default.awsS3ConfigKey
        awsS3Bucket = GTCamera_Config.Default.awsS3Bucket
        awsS3PrefixPath = GTCamera_Config.Default.awsS3PrefixPath
        awsS3AllowImageExtensions = GTCamera_Config.Default.awsS3AllowImageExtensions
        libraryEnabled = GTCamera_Config.Default.libraryEnabled
        tabButtonIconLibrary = GTCamera_Config.Default.tabButtonIconLibrary
        tabButtonIconCamera = GTCamera_Config.Default.tabButtonIconCamera
        tabButtonIconAwsS3 = GTCamera_Config.Default.tabButtonIconAwsS3
        tabButtonIconSize = GTCamera_Config.Default.tabButtonIconSize
        tabButtonFont = GTCamera_Config.Default.tabButtonFont
        tabButtonTextColor = GTCamera_Config.Default.tabButtonTextColor
        tabButtonHighLightTextColor = GTCamera_Config.Default.tabButtonHighLightTextColor
        tabSpacing = GTCamera_Config.Default.tabSpacing
        cameraButtonLabelFont = GTCamera_Config.Default.cameraButtonLabelFont
        cameraFlashButtonAutoIcon = GTCamera_Config.Default.cameraFlashButtonAutoIcon
        cameraFlashButtonOnIcon = GTCamera_Config.Default.cameraFlashButtonOnIcon
        cameraFlashButtonOffIcon = GTCamera_Config.Default.cameraFlashButtonOffIcon
        cameraRotateButtonIconFront = GTCamera_Config.Default.cameraRotateButtonIconFront
        cameraRotateButtonIconBack = GTCamera_Config.Default.cameraRotateButtonIconBack
        cameraCameraButtonIcon = GTCamera_Config.Default.cameraCameraButtonIcon
        previewButtonIconClose = GTCamera_Config.Default.previewButtonIconClose
        previewButtonIconEdit = GTCamera_Config.Default.previewButtonIconEdit
        previewButtonIconUndo = GTCamera_Config.Default.previewButtonIconUndo
        previewButtonIconContinue = GTCamera_Config.Default.previewButtonIconContinue
        previewButtonTitleClose = GTCamera_Config.Default.previewButtonTitleClose
        previewButtonTitleEdit = GTCamera_Config.Default.previewButtonTitleEdit
        previewButtonTitleUndo = GTCamera_Config.Default.previewButtonTitleUndo
        previewButtonTitleContinue = GTCamera_Config.Default.previewButtonTitleContinue
        previewButtonTextColor = GTCamera_Config.Default.previewButtonTextColor
        awsS3LoadErrorIcon = GTCamera_Config.Default.awsS3LoadErrorIcon
        awsS3LoadLoadingIcon = GTCamera_Config.Default.awsS3LoadLoadingIcon
        cropEnabled = GTCamera_Config.Default.cropEnabled
        cropAspectRaitoPreset = GTCamera_Config.Default.cropAspectRaitoPreset
        cropEnableAspectRaitoSelector = GTCamera_Config.Default.cropEnableAspectRaitoSelector
        cropResetAspectRaitoEnabled = GTCamera_Config.Default.cropResetAspectRaitoEnabled
        cropAspectRaitoPickerButtonHidden = GTCamera_Config.Default.cropAspectRaitoPickerButtonHidden
        cropResetButtonHidden = GTCamera_Config.Default.cropResetButtonHidden
        cropRotateButtonsHidden = GTCamera_Config.Default.cropRotateButtonsHidden
        cropAspectRatioLockEnabled = GTCamera_Config.Default.cropAspectRatioLockEnabled
    }
}
