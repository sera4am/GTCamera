//
//  GTCameraPreviewViewController.swift
//  GTCamera
//
//  Created by Sera Naoto on 2020/04/03.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import Kingfisher

public protocol GTCameraPreviewViewControllerDataSource {
    func GTCameraPreviewView(buttonIconFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> UIImage?
    func GTCameraPreviewView(buttonTitleFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> String?
    func GTCameraPreviewView(buttonFontFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType, baseFont:UIFont) -> UIFont?
    func GTCameraPreviewView(buttonTitleColorFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> UIColor?
    func GTCameraPreviewView(buttonTypeFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition) -> GTCameraPreviewViewController.ButtonType?
    func GTCameraPreviewView(updateButtonFor viewController:GTCameraPreviewViewController, button:inout UIButton, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType)
    func GTCameraPreviewView(buttonContentInsets viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> UIEdgeInsets?
}

public extension GTCameraPreviewViewControllerDataSource {
    func GTCameraPreviewView(buttonIconFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> UIImage? { return nil }
    func GTCameraPreviewView(buttonTitleFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> String? { return nil }
    func GTCameraPreviewView(buttonFontFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType, baseFont:UIFont) -> UIFont? { return nil }
    func GTCameraPreviewView(buttonTitleColorFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> UIColor? { return nil }
    func GTCameraPreviewView(buttonTypeFor viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition) -> GTCameraPreviewViewController.ButtonType? { return nil }
    func GTCameraPreviewView(updateButtonFor viewController:GTCameraPreviewViewController, button:inout UIButton, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) {}
    func GTCameraPreviewView(buttonContentInsets viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> UIEdgeInsets? { return nil }
}

public protocol GTCameraPreviewViewControllerDelegate {
    func GTCameraPreviewView(onButton viewController:GTCameraPreviewViewController, position:GTCameraPreviewViewController.ButtonPosition, type:GTCameraPreviewViewController.ButtonType) -> Bool
}

open class GTCameraPreviewViewController: UIViewController {

    public enum ButtonPosition:Int {
        case topLeft
        case topCenter
        case topRight
        case bottomLeft
        case bottomCenter
        case bottomRight
    }
    
    public enum ButtonType:Int {
        case Close
        case Back
        case Apply
        case Edit
        case Undo
        case Continue
        case Select
        case Delete
        case Crop
        case Custom
    }
    
    public var dataSource:GTCameraPreviewViewControllerDataSource? = nil
    public var delegate:GTCameraPreviewViewControllerDelegate? = nil
    
    fileprivate let scrollView:UIScrollView = UIScrollView()
    fileprivate let imageView:UIImageView = UIImageView()
    fileprivate var controlButtons:[ButtonType:UIButton] = [:]
    
    fileprivate let controlHeaderView:UIView = UIView()
    fileprivate let controlFooterView:UIView = UIView()
    fileprivate var controlViewHiddenTimer:Timer? = nil
    
    fileprivate var beforeNavigationBarHidden:Bool? = nil
    fileprivate var image:UIImage? = nil
    fileprivate var url:URL? = nil
    fileprivate var animationRect:CGRect? = nil
    
    fileprivate var controlHeaderEnabled:Bool = false
    fileprivate var controlFooterEnabled:Bool = false
    
    public var closeButtonEnabled:Bool = true {
        didSet {
            updateView()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(_ imageView:UIImageView) {
        self.init()
        self.image = imageView.image
        self.animationRect = imageView.frame
    }
    
    public convenience init(_ image:UIImage, _ url:URL? = nil) {
        self.init()
        self.image = image
        self.url = url
    }
    public convenience init(_ url:URL, _ image:UIImage? = nil) {
        self.init()
        self.image = image
        self.url = url
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if navigationController != nil {
            beforeNavigationBarHidden = navigationController?.isNavigationBarHidden
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
//        print("[ControlEnabled]", controlHeaderEnabled, controlFooterEnabled)
        showControlView()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        if navigationController != nil && beforeNavigationBarHidden != nil {
            navigationController?.setNavigationBarHidden(beforeNavigationBarHidden!, animated: true)
        }
    }
    
    private func initView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        controlHeaderView.translatesAutoresizingMaskIntoConstraints = false
        controlFooterView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        view.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        scrollView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: scrollView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        print(view.topAnchor.anchorWithOffset(to: view.safeAreaLayoutGuide.topAnchor))
        
        let topPadding = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        
        view.addSubview(controlHeaderView)
        controlHeaderView.addConstraint(NSLayoutConstraint(item: controlHeaderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50 + topPadding))
        view.addConstraints([
            NSLayoutConstraint(item: controlHeaderView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: controlHeaderView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: controlHeaderView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        controlHeaderView.addBlur(style: .dark)
        view.addSubview(controlFooterView)
        controlFooterView.addConstraint(NSLayoutConstraint(item: controlFooterView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50 + bottomPadding))
        view.addConstraints([
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: controlFooterView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: controlFooterView, attribute: .leading, relatedBy: .equal, toItem: view!, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: controlFooterView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        controlFooterView.addBlur(style: .dark)
        
        view.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        if image != nil {
            imageView.image = image
        } else {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url!, placeholder: nil, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.image = value.image
                    break
                default:
                    break
                }
            }
        }
        scrollView.contentMode = .center
        scrollView.isMultipleTouchEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.contentSize = imageView.frame.size
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapScreen(_:)))
        scrollView.addGestureRecognizer(gesture)
        
        view.bringSubviewToFront(controlHeaderView)
        view.bringSubviewToFront(controlFooterView)
        
        updateView()
    }
    
    private func updateView() {

        controlHeaderEnabled = false
        controlFooterEnabled = false
        if closeButtonEnabled {
            if navigationController != nil {
                setControlButton(.topLeft, .Back)
            } else {
                setControlButton(.topLeft, .Close)
            }
        } else {
            if let type = dataSource?.GTCameraPreviewView(buttonTypeFor: self, position: .topLeft) {
                setControlButton(.topLeft, type)
            }
        }
        for position in [ButtonPosition.topCenter, ButtonPosition.topRight, ButtonPosition.bottomLeft, ButtonPosition.bottomCenter, ButtonPosition.bottomRight] {
            if let type = dataSource?.GTCameraPreviewView(buttonTypeFor: self, position: position) {
                setControlButton(position, type)
            }
        }
        
        controlHeaderView.isHidden = !controlHeaderEnabled
        controlFooterView.isHidden = !controlFooterEnabled
    }
    
    private func setControlButton(_ position:ButtonPosition, _ type:ButtonType) {
        
        controlButtons[type]?.removeFromSuperview()
        controlButtons[type] = nil
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(onControlButton(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.tag = position.rawValue * 100 + type.rawValue
        button.addTarget(self, action: #selector(onControlButton(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        if let insets = dataSource?.GTCameraPreviewView(buttonContentInsets: self, position: position, type: type) {
            button.contentEdgeInsets = insets
        }
        
        var buttonImage:UIImage? = nil
        
        switch type {
        case .Apply:
//            button.setImage(UIImage(systemName: "checkmark"), for: .normal)
            buttonImage = UIImage(systemName: "checkmark")
            break
        case .Back:
//            button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            buttonImage = UIImage(systemName: "arrow.left")
            break
        case .Close:
//            button.setImage(UIImage(systemName: "xmark"), for: .normal)
            buttonImage = UIImage(systemName: "xmark")
            break
        case .Continue:
//            button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            buttonImage = UIImage(systemName: "arrow.right")
            break
        case .Edit:
//            button.setImage(UIImage(systemName: "wand.and.rays"), for: .normal)
            buttonImage = UIImage(systemName: "wand.and.rays")
            break
        case .Select:
//            button.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
            buttonImage = UIImage(systemName: "smallcircle.fill.circle")
            break
        case .Undo:
//            button.setImage(UIImage(systemName: "arrow.uturn.left"), for: .normal)
            buttonImage = UIImage(systemName: "arrow.utrun.left")
            break
        case .Delete:
//            button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
            buttonImage = UIImage(systemName: "trash.fill")
            button.tintColor = .gray
            break
        case .Crop:
//            button.setImage(UIImage(systemName: "crop"), for: .normal)
            buttonImage = UIImage(systemName: "crop")
            break
        case .Custom:
            // Nothing to do here.
            break
        }
        
        var baseView:UIView!
        switch position {
        case .topLeft, .topCenter, .topRight:
            controlHeaderEnabled = true
            baseView = controlHeaderView
            break
        case .bottomLeft, .bottomCenter, .bottomRight:
            controlFooterEnabled = true
            baseView = controlFooterView
            break
        }
        baseView.addSubview(button)

        let titleColor = dataSource?.GTCameraPreviewView(buttonTitleColorFor: self, position: position, type: type) ?? .lightGray
        
        if let userTitle = dataSource?.GTCameraPreviewView(buttonTitleFor: self, position: position, type: type) {
            button.setTitle(userTitle, for: .normal)
            button.titleLabel?.font = dataSource?.GTCameraPreviewView(buttonFontFor: self, position: position, type: type, baseFont: button.titleLabel?.font ?? UIFont.systemFont(ofSize: 18)) ?? UIFont.systemFont(ofSize: 18)

            button.addConstraints([
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
            ])
            button.setTitleColor(titleColor, for: .normal)
        } else {
            if let userImage = dataSource?.GTCameraPreviewView(buttonIconFor: self, position: position, type: type) {
                buttonImage = userImage
            }
            button.setImage(buttonImage, for: .normal)
            button.addConstraints([
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 30),
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
            ])
            button.tintColor = titleColor
        }
        
        var padding:CGFloat!
        switch position {
        case .topLeft, .topCenter, .topRight:
            padding = -1 * (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            break
        case .bottomLeft, .bottomCenter, .bottomRight:
            padding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            break
        }
        
        baseView.addConstraint(NSLayoutConstraint(item: baseView!, attribute: .centerY, relatedBy: .equal, toItem: button, attribute: .centerY, multiplier: 1, constant: padding / 2))
        
        switch position {
        case .topLeft, .bottomLeft:
            baseView.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1, constant: 8))
            break
        case .topCenter, .bottomCenter:
            baseView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: baseView, attribute: .centerX, multiplier: 1, constant: 0))
            break
        case .topRight, .bottomRight:
            baseView.addConstraint(NSLayoutConstraint(item: baseView!, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 8))
            break
        }
        
        controlButtons[type] = button
    }
    
    private func showControlView(_ animated:Bool = true) {
        controlViewHiddenTimer?.invalidate()
        controlViewHiddenTimer = nil
        
        DispatchQueue.main.async {
            if self.controlHeaderEnabled && self.controlHeaderView.isHidden {
                self.controlHeaderView.alpha = 0.0
                self.controlHeaderView.isHidden = false
            }
            if self.controlFooterEnabled && self.controlFooterView.isHidden {
                self.controlFooterView.alpha = 0.0
                self.controlFooterView.isHidden = false
            }
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: animated ? 0.2 : 0.0, animations: {
                if self.controlHeaderEnabled {
                    self.controlHeaderView.alpha = 1.0
                }
                if self.controlFooterEnabled {
                    self.controlFooterView.alpha = 1.0
                }
                self.controlViewHiddenTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
                    self.hideControlView()
                })
            }) { _ in
            }
        }
    }
    
    private func hideControlView(_ animated:Bool = true) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: animated ? 0.2 : 0.0, animations: {
                self.controlHeaderView.alpha = 0.0
                self.controlFooterView.alpha = 0.0
            }) { _ in
                self.controlHeaderView.isHidden = true
                self.controlFooterView.isHidden = true
            }
        }
    }
    
    
    @objc func onTapScreen(_ sender:Any?)  {
        if !controlHeaderView.isHidden || !controlFooterView.isHidden {
            hideControlView()
        } else {
            showControlView()
        }
    }
    
    @objc func onControlButton(_ sender:UIButton) {
        guard let position = ButtonPosition(rawValue: Int(floor(Double(sender.tag) / Double(100)))) else { return }
        guard let type = ButtonType(rawValue: Int(sender.tag % 100)) else { return }

        if delegate?.GTCameraPreviewView(onButton: self, position: position, type: type) ?? false {
            closeViewController()
        }
    }
}

extension GTCameraPreviewViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
