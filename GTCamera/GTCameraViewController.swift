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
    func gtCameraOn(selectLocalImage gtCamera:GTCameraViewController, image:UIImage?, url:URL?)
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
        print(Locale.current)
        initView()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        footerView.isHidden = (UIScreen.main.bounds.width > UIScreen.main.bounds.height)
    }
    
    func initView() {
        view.backgroundColor = .white
        addChild(pageViewControler)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
        self.view.addConstraints([
            NSLayoutConstraint(item: mainStackView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: mainStackView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        mainStackView.axis = .vertical

        mainStackView.addArrangedSubview(pageViewControler.view)
        mainStackView.addArrangedSubview(footerView)
        footerHeight = NSLayoutConstraint(item: footerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 60)
        footerView.addConstraint(footerHeight)
        footerView.axis = .horizontal
        footerView.distribution = .fillEqually
        
        self.view.addSubview(viewTypeSelectorBar)
        
        viewPages[.Camera] = GTCamera_CameraViewController(self)
        
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
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        view.addConstraints([
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        button.addTarget(self, action: #selector(onFooterButton(_:)), for: .touchUpInside)
        button.tag = type.rawValue
        footerButtons[type] = button
        var height:CGFloat = config.tabSpacing * 2
        
        if name != nil {
            view.addSubview(label)
            label.text = name
            label.font = config.tabButtonFont
            label.textColor = config.tabButtonTextColor
            view.addConstraints([
                NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: config.tabSpacing)
            ])
            height += label.font.pointSize + 8
            footerLabels[type] = label
        }
        if icon != nil {
            view.addSubview(iconImageView)
            iconImageView.image = icon!
            iconImageView.addConstraints([
                NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: config.tabButtonIconSize),
                NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: config.tabButtonIconSize)
            ])
            iconImageView.tintColor = config.tabButtonTextColor
            view.addConstraints([
                NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ])
            if name != nil {
                height += config.tabSpacing
            }
            height += config.tabButtonIconSize + 8
            footerIcons[type] = iconImageView
        }
        
        view.bringSubviewToFront(button)
        
        footerViews[type] = view
        
        return height
    }
    
    @objc func onFooterButton(_ sender:Any?) {
        guard let typeVal = (sender as? UIButton)?.tag else { return }
        guard let type = ViewType(rawValue: typeVal) else { return }
        
        if type == .Library {
            let vc = UIImagePickerController()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            return
        }
        
        updateViewType(type, true)
    }
    
    func didTakePhoto(_ manager:GTCamera_CameraManager, _ photo:UIImage?, _ error:Error?) {
        if error != nil {
            return
        }
        let vc = TOCropViewController(image: photo!)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = true
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func firstCropImage() {
        if config.cropEnabled {
            if selectedImage == nil { return }
            let vc = TOCropViewController(image: selectedImage!)
            vc.aspectRatioPreset = config.cropAspectRaitoPreset
            vc.aspectRatioPickerButtonHidden = config.cropEnableAspectRaitoSelector
            vc.doneButtonTitle = translation.buttonTitleCropDone
            vc.cancelButtonTitle = translation.buttonTitleCropBack
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            secondPreviewImage()
        }
    }
    
    func secondPreviewImage(_ animated:Bool = true) {
        if selectedImage == nil { return }
        let vc = GTCamera_ImagePreviewViewController(self, selectedImage!, selectedUrl)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: animated, completion: nil)
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
    func ImagePreviewView(onSelect viewController: GTCamera_ImagePreviewViewController, image: UIImage?, url: URL?) {
        delegate?.gtCameraOn(selectLocalImage: self, image: image, url: url)
    }
}

extension GTCameraViewController : UINavigationControllerDelegate {
    
}

extension GTCameraViewController : UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.selectedImage = image
            self.firstCropImage()
        }
    }
}
