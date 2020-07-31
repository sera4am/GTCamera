//
//  GTCamera.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/27.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3
import AVFoundation
import TOCropViewController

public protocol GTCameraDelegate {
    func gtCameraOn(selectLocalImage gtCamera:GTCameraViewController, image:UIImage?, url:URL?, mode:GTCameraViewController.ViewType)
}

open class GTCameraViewController: UIViewController {

    public enum ViewType:Int {
        case Library = 1
        case Camera = 2
        case AwsS3 = 3
    }
    
    open var delegate:GTCameraDelegate? = nil
    
    open var translation:GTCamera_Translation = GTCamera_Translation.Default {
        didSet {
            if isViewLoaded {
                updateView()
            }
        }
    }
    
    open var config:GTCamera_Config = GTCamera_Config.Default {
        didSet {
            if isViewLoaded {
                updateView()
            }
        }
    }
    open var mode:ViewType = .Camera
    
    var selectedImage:UIImage? = nil
    var selectedUrl:URL? = nil
    
    private var _viewType:ViewType = .Camera
    var viewType:ViewType {
        get {
            return _viewType
        }
        set {
            updateViewType(newValue, true)
        }
    }
    private var mainStackView:UIStackView = UIStackView()
    private var pageViewControler:UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var footerView:UIStackView = UIStackView()
    private var footerHeight:NSLayoutConstraint!
    private var footerViews:[ViewType:UIView] = [:]
    private var footerButtons:[ViewType:UIButton] = [:]
    private var footerLabels:[ViewType:UILabel] = [:]
    private var footerIcons:[ViewType:UIImageView] = [:]
    private var viewTypeSelectorBar:UIView = UIView()
    
    private var viewPages:[ViewType:UIViewController] = [:]
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init(config: GTCamera_Config, translation: GTCamera_Translation? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.config = config
        if translation != nil {
            self.translation = translation!
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        footerView.isHidden = size.width > size.height
    }
    
    func initView() {
        view.backgroundColor = .white
        addChild(pageViewControler)
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(pageViewControler.view)
        mainStackView.addArrangedSubview(footerView)
        view.addSubview(viewTypeSelectorBar)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false

        mainStackView.axis = .vertical
        footerView.axis = .horizontal
        footerView.distribution = .fillEqually
        viewPages[.Camera] = GTCamera_CameraViewController(self)
        
        footerHeight = footerView.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            footerHeight,
        ])

        for (_, vc) in viewPages {
            addChild(vc)
        }
        
        updateView()
    }
    
    func updateTitles() {
        
    }
    
    open func updateView() {
        view.backgroundColor = config.backgroundColor
        viewTypeSelectorBar.backgroundColor = config.tabButtonHighLightTextColor
        
        footerLabels.forEach { (_, l) in
            l.removeFromSuperview()
        }
        footerButtons.forEach { (_, b) in
            b.removeFromSuperview()
        }
        footerIcons.forEach { (_, i) in
            i.removeFromSuperview()
        }
        footerViews.forEach { (_, v) in
            footerView.removeArrangedSubview(v)
        }
        
        var height:CGFloat = 0
        if config.libraryEnabled {
            let h = setFooterView(.Library, name: translation.tabTitleLibrary, icon: config.tabButtonIconLibrary)
            if h > height { height = h }
        }
        let h = setFooterView(.Camera, name: translation.tabTitleCamera, icon: config.tabButtonIconCamera)
        if h > height { height = h }
        if config.awsS3Enabled {
            let h = setFooterView(.AwsS3, name: translation.tabTitleAWSS3, icon: config.tabButtonIconAwsS3)
            if h > height { height = h }
        }
        
        footerHeight.constant = height
        view.layoutIfNeeded()
        updateViewType(.Camera, false)
    }
    
    private func updateViewType(_ viewType:ViewType? = nil, _ animated:Bool = true) {
        
        var newViewType = viewType ?? self.viewType
        
        footerViews[.Library]?.isHidden = !config.libraryEnabled
        footerViews[.AwsS3]?.isHidden = !config.awsS3Enabled
        
        if !config.libraryEnabled && newViewType == .Library { newViewType = .Camera}
        if !config.awsS3Enabled && newViewType == .AwsS3 { newViewType = .Camera}
        
        UIView.animate(withDuration: animated ? 0.2 : 0.0, animations: {
            if let frame = self.footerViews[newViewType]?.frame {
                let baseFrame = self.footerView.convert(frame, to: self.view)
                let newRect = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height - 4.0, width: baseFrame.width, height: 2.0)
                self.viewTypeSelectorBar.frame = newRect
                
                for (type, icon) in self.footerIcons {
                    icon.tintColor = type == newViewType ? self.config.tabButtonHighLightTextColor : self.config.tabButtonTextColor
                }
                for (type, label) in self.footerLabels {
                    label.textColor = type == newViewType ? self.config.tabButtonHighLightTextColor : self.config.tabButtonTextColor
                }
                
                var vc:UIViewController? = nil
                
                switch newViewType {
                case .Camera:
                    vc = self.viewPages[.Camera]
                    break
                case .AwsS3:
                    let mVc = GTCamera_AwsS3ViewController(self)
                    vc = mVc
                    break
                default:
                    break
                }
                
                if vc != nil {
                    self.pageViewControler.setViewControllers([vc!], direction: newViewType.rawValue > self.viewType.rawValue ? .forward : .reverse, animated: true, completion: nil)
                }
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self._viewType = newViewType
        }
    }
    
    private func setFooterView(_ type:ViewType, name:String?, icon:UIImage?) -> CGFloat {
        
        let view = UIView()
        let button = UIButton()
        let label = UILabel()
        let iconImageView = UIImageView()
        view.backgroundColor = config.backgroundColor
        
        footerView.addArrangedSubview(view)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(onFooterButton(_:)), for: .touchUpInside)
        button.tag = type.rawValue

        var constraints:[NSLayoutConstraint] = []
        
        constraints = [
            button.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: button.trailingAnchor),
        ]
        
        footerButtons[type] = button

        var height:CGFloat = config.tabSpacing * 2
        if name != nil {
            view.addSubview(label)
            label.text = name
            label.font = config.tabButtonFont
            label.textColor = config.tabButtonTextColor
            label.translatesAutoresizingMaskIntoConstraints = false
            
            constraints += [
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: config.tabSpacing),
            ]
            height += label.font.pointSize + 8
            footerLabels[type] = label
        }
        if icon != nil {
            view.addSubview(iconImageView)
            iconImageView.image = icon!
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.tintColor = config.tabButtonTextColor
            constraints += [
                iconImageView.widthAnchor.constraint(equalToConstant: config.tabButtonIconSize),
                iconImageView.heightAnchor.constraint(equalToConstant: config.tabButtonIconSize),
                iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ]
            if name != nil {
                height += config.tabSpacing
            }
            height += config.tabButtonIconSize + 8
            footerIcons[type] = iconImageView
        }
        
        NSLayoutConstraint.activate(constraints)
        
        view.bringSubviewToFront(button)
        
        footerViews[type] = view
        
        return height
    }
    
    @objc func onFooterButton(_ sender:Any?) {
        guard let typeVal = (sender as? UIButton)?.tag else { return }
        guard let type = ViewType(rawValue: typeVal) else { return }
        mode = type
        if type == .Library {
            let vc = UIImagePickerController()
            vc.delegate = self
            
            if is_iPad() {
                vc.modalPresentationStyle = .popover
                if let popver = vc.popoverPresentationController {
                    popver.sourceView = view
                    popver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                    popver.sourceRect = view.frame
                    vc.preferredContentSize = CGSize(width: view.frame.width - 80, height: view.frame.height - 80)
                } else {
                    vc.modalPresentationStyle = .fullScreen
                }
            } else {
                vc.modalPresentationStyle = .fullScreen
            }
            
            present(vc, animated: true, completion: nil)
            return
        }
        updateViewType(type, true)
    }
    
    func didTakePhoto(_ manager:GTCamera_CameraManager, _ photo:UIImage?, _ error:Error?) {
        if error != nil {
            return
        }
        if config.cropEnabled {
            let vc = TOCropViewController(image: photo!)
            vc.aspectRatioPreset = config.cropAspectRaitoPreset
            vc.aspectRatioPickerButtonHidden = !config.cropEnableAspectRaitoSelector
            vc.doneButtonTitle = translation.buttonTitleCropDone
            vc.cancelButtonTitle = translation.buttonTitleCropBack
            vc.resetAspectRatioEnabled = config.cropResetAspectRaitoEnabled
            vc.aspectRatioPickerButtonHidden = config.cropAspectRaitoPickerButtonHidden
            vc.resetButtonHidden = config.cropResetButtonHidden
            vc.rotateButtonsHidden = config.cropRotateButtonsHidden
            vc.aspectRatioLockEnabled = config.cropAspectRatioLockEnabled
            vc.aspectRatioLockDimensionSwapEnabled = false
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            selectedImage = photo
            secondPreviewImage()
        }
    }
    
    func firstCropImage(_ viewController:UIViewController? = nil) {
        if config.cropEnabled {
            if selectedImage == nil { return }
            let vc = TOCropViewController(image: selectedImage!)
            vc.aspectRatioPreset = config.cropAspectRaitoPreset
            vc.aspectRatioPickerButtonHidden = !config.cropEnableAspectRaitoSelector
            vc.doneButtonTitle = translation.buttonTitleCropDone
            vc.cancelButtonTitle = translation.buttonTitleCropBack
            vc.resetAspectRatioEnabled = config.cropResetAspectRaitoEnabled
            vc.aspectRatioPickerButtonHidden = config.cropAspectRaitoPickerButtonHidden
            vc.resetButtonHidden = config.cropResetButtonHidden
            vc.rotateButtonsHidden = config.cropRotateButtonsHidden
            vc.aspectRatioLockEnabled = config.cropAspectRatioLockEnabled
            vc.delegate = self
            
            vc.modalPresentationStyle = .fullScreen
            (viewController ?? self).present(vc, animated: true, completion: nil)
        } else {
            secondPreviewImage()
        }
    }
    
    func secondPreviewImage(_ animated:Bool = true) {
        if selectedImage == nil { return }
        
        if !config.useThisPreviewEnabled {
            delegate?.gtCameraOn(selectLocalImage: self, image: selectedImage, url: selectedUrl, mode: mode)
            return
        }
        
        if selectedImage != nil {
            let vc = GTCameraPreviewViewController(selectedImage!, selectedUrl)
            vc.delegate = self
            vc.dataSource = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

extension GTCameraViewController : TOCropViewControllerDelegate {
    public func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false) {
            self.selectedImage = image
            self.secondPreviewImage(false)
        }
    }
}

extension GTCameraViewController : GTCamera_ImagePreviewViewControllerDelegate {
}

extension GTCameraViewController : GTCameraPreviewViewControllerDelegate {
    public func GTCameraPreviewView(onButton viewController: GTCameraPreviewViewController, position: GTCameraPreviewViewController.ButtonPosition, type: GTCameraPreviewViewController.ButtonType) -> Bool {
        switch type {
        case .Close:
            return true
        case .Apply:
            viewController.dismiss(animated: false) {
                self.delegate?.gtCameraOn(selectLocalImage: self, image: self.selectedImage, url: self.selectedUrl, mode: self.mode)
            }
            return false
        default:
            break
        }
        return true
    }
    
    
}

extension GTCameraViewController : GTCameraPreviewViewControllerDataSource {
    public func GTCameraPreviewView(buttonTypeFor viewController: GTCameraPreviewViewController, position: GTCameraPreviewViewController.ButtonPosition) -> GTCameraPreviewViewController.ButtonType? {
        switch position {
        case .topRight:
            return .Close
        case .bottomCenter:
            return .Apply
        default:
            break
        }
        return nil
    }
    
    public func GTCameraPreviewView(buttonTitleFor viewController: GTCameraPreviewViewController, position: GTCameraPreviewViewController.ButtonPosition, type: GTCameraPreviewViewController.ButtonType) -> String? {
        switch type {
        case .Apply:
            return translation.buttonTitleUseThis
        default:
            break
        }
        return nil
    }
}

extension GTCameraViewController : UINavigationControllerDelegate {
    
}

extension GTCameraViewController : UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.selectedImage = image
        self.firstCropImage(picker)
/*
        picker.dismiss(animated: false) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.selectedImage = image
        }
*/
    }
}
