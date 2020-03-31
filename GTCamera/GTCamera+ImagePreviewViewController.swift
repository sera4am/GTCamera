//
//  GTCamera+ImagePreviewViewController.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/30.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import Kingfisher

protocol GTCamera_ImagePreviewViewControllerDelegate {
    func ImagePreviewView(onSelect viewController:GTCamera_ImagePreviewViewController, image:UIImage?, url: URL?)
    func ImagePreviewView(onCancel viewController:GTCamera_ImagePreviewViewController, image:UIImage?, url:URL?)
    func ImagePreviewView(onContinue viewController:GTCamera_ImagePreviewViewController, image:UIImage?, url:URL?)
}

extension GTCamera_ImagePreviewViewControllerDelegate {
    func ImagePreviewView(onSelect viewController:GTCamera_ImagePreviewViewController, image:UIImage?, url:URL?) {}
    func ImagePreviewView(onCancel viewController:GTCamera_ImagePreviewViewController, image:UIImage?, url:URL?) {}
    func ImagePreviewView(onContinue viewController:GTCamera_ImagePreviewViewController, image:UIImage?, url:URL?) {}
}

class GTCamera_ImagePreviewViewController: UIViewController {

    enum ViewType {
        case Editor
        case Preview
    }
    
    var delegate:GTCamera_ImagePreviewViewControllerDelegate? = nil
    
    let scrollView:UIScrollView = UIScrollView()
    let imageView:UIImageView = UIImageView()
    let closeButton:UIButton = UIButton()
    let selectButton:UIButton = UIButton()
    let editButton:UIButton = UIButton()
    let undoButton:UIButton = UIButton()
    let headerView:UIView = UIView()
    let continuebutton:UIButton = UIButton()
    var headerFooterHideTimer:Timer? = nil
    var blurView:UIVisualEffectView = UIVisualEffectView()
    var viewType:ViewType = .Editor
    
    let footerView:UIView = UIView()
    let applyButton:UIButton = UIButton()
    
    var image:UIImage? = nil
    var url:URL? = nil
    var originalImage:UIImage? = nil
    
    var gtCamera:GTCamera!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ gtCamera:GTCamera, _ url:URL) {
        self.init()
        self.gtCamera = gtCamera
        self.url = url
    }
    
    convenience init(_ gtCamera:GTCamera, _ image:UIImage) {
        self.init()
        self.gtCamera = gtCamera
        self.image = image
        self.originalImage = image.copy() as? UIImage
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showHeaderFooterView()
    }
    
    func initView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        continuebutton.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(scrollView)
        self.view.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0)
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
        self.view.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        if image != nil {
            imageView.image = image
        } else {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url!, placeholder: nil, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.image = value.image
                    self.originalImage = value.image
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
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        headerView.addBlur(style: .light)
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 80))
        view.addConstraints([
            NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        
        headerView.addSubview(closeButton)
        closeButton.addConstraints([
            NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 64)
        ])
        headerView.addConstraints([
            NSLayoutConstraint(item: closeButton, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: closeButton, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 8)
        ])
        closeButton.setTitle(gtCamera.config.previewButtonTitleClose, for: .normal)
        closeButton.setImage(gtCamera.config.previewButtonIconClose, for: .normal)
        closeButton.tintColor = gtCamera.config.previewButtonTextColor
        closeButton.setTitleColor(gtCamera.config.previewButtonTextColor, for: .normal)
        closeButton.contentVerticalAlignment = .fill
        closeButton.contentHorizontalAlignment = .fill
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        closeButton.addTarget(self, action: #selector(onClose(_:)), for: .touchUpInside)
        
        headerView.addSubview(editButton)
        editButton.addConstraints([
            NSLayoutConstraint(item: editButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: editButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 64)
        ])
        headerView.addConstraints([
            NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: editButton, attribute: .trailing, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: editButton, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 8)
        ])
        editButton.setTitle(gtCamera.config.previewButtonTitleEdit, for: .normal)
        editButton.setImage(gtCamera.config.previewButtonIconEdit, for: .normal)
        editButton.tintColor = gtCamera.config.previewButtonTextColor
        editButton.setTitleColor(gtCamera.config.previewButtonTextColor, for: .normal)
        editButton.contentVerticalAlignment = .fill
        editButton.contentHorizontalAlignment = .fill
        editButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        editButton.addTarget(self, action: #selector(onEdit(_:)), for: .touchUpInside)
        headerView.isHidden = true
        
        headerView.addSubview(undoButton)
        undoButton.addConstraints([
            NSLayoutConstraint(item: undoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: undoButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 64)
        ])
        headerView.addConstraints([
            NSLayoutConstraint(item: undoButton, attribute: .trailing, relatedBy: .equal, toItem: editButton, attribute: .leading, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: undoButton, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 8)
        ])
        undoButton.setTitle(gtCamera.config.previewButtonTitleUndo, for: .normal)
        undoButton.setImage(gtCamera.config.previewButtonIconUndo, for: .normal)
        undoButton.tintColor = gtCamera.config.previewButtonTextColor
        undoButton.setTitleColor(gtCamera.config.previewButtonTextColor, for: .normal)
        undoButton.contentVerticalAlignment = .fill
        undoButton.contentHorizontalAlignment = .fill
        undoButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        undoButton.isHidden = true
        undoButton.addTarget(self, action: #selector(onUndo(_:)), for: .touchUpInside)
        
        headerView.addSubview(continuebutton)
        continuebutton.addConstraints([
            NSLayoutConstraint(item: continuebutton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: continuebutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 64)
        ])
        headerView.addConstraints([
            NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: continuebutton, attribute: .trailing, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: continuebutton, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 8)
        ])
        continuebutton.setTitle(gtCamera.config.previewButtonTitleContinue, for: .normal)
        continuebutton.setImage(gtCamera.config.previewButtonIconContinue, for: .normal)
        continuebutton.tintColor = gtCamera.config.previewButtonTextColor
        continuebutton.setTitleColor(gtCamera.config.previewButtonTextColor, for: .normal)
        continuebutton.contentVerticalAlignment = .fill
        continuebutton.contentHorizontalAlignment = .fill
        continuebutton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        continuebutton.isHidden = true
        continuebutton.addTarget(self, action: #selector(onContinue(_:)), for: .touchUpInside)
        
        view.addSubview(footerView)
        footerView.addBlur(style: .light)
        footerView.addConstraint(NSLayoutConstraint(item: footerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 80))
        view.addConstraints([
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: footerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: footerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: footerView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        footerView.addSubview(applyButton)
        applyButton.setTitle(gtCamera.transition.buttonTitleUseThis, for: .normal)
        applyButton.addConstraints([
            NSLayoutConstraint(item: applyButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200),
            NSLayoutConstraint(item: applyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        ])
        footerView.addConstraints([
            NSLayoutConstraint(item: applyButton, attribute: .centerX, relatedBy: .equal, toItem: footerView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: applyButton, attribute: .centerY, relatedBy: .equal, toItem: footerView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        applyButton.setTitleColor(.link, for: .normal)
        applyButton.addTarget(self, action: #selector(onApply(_:)), for: .touchUpInside)
        footerView.isHidden = true
        
        view.bringSubviewToFront(footerView)
        view.bringSubviewToFront(headerView)
        
        if viewType == .Preview {
            editButton.isHidden = true
            continuebutton.isHidden = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onScrollTapped(_:)))
        scrollView.addGestureRecognizer(tapGesture)
        
    }

    func showHeaderFooterView(_ hidden:Bool = false) {
        
        DispatchQueue.main.async {
            self.headerFooterHideTimer?.invalidate()
            self.headerFooterHideTimer = nil
            
            if hidden {
                UIView.animate(withDuration: 0.3, animations: {
                    self.headerView.alpha = 0
                    self.footerView.alpha = 0
                }) { _ in
                    self.headerView.isHidden = true
                    self.headerView.isHidden = true
                }
            } else {
                self.headerView.isHidden = false
                if self.viewType == .Editor { self.footerView.isHidden = false }
                UIView.animate(withDuration: 0.3, animations: {
                    self.headerView.alpha = 1
                    if self.viewType == .Editor { self.footerView.alpha = 1 }
                }) { _ in
                    self.headerFooterHideTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
                        self.showHeaderFooterView(true)
                    })
                }
            }
        }
    }
    
    @objc func onScrollTapped(_ sender:Any?) {
        showHeaderFooterView( !headerView.isHidden )
    }
    
    @objc func onClose(_ sender:Any?) {
        dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            self.delegate?.ImagePreviewView(onCancel: self, image: self.image, url: self.url)
        }
    }
    
    @objc func onApply(_ sender:Any?) {
        dismiss(animated: true) {
            self.delegate?.ImagePreviewView(onSelect: self, image: self.image, url: self.url)
        }
    }
    
    @objc func onEdit(_ sender:Any?) {
        if image == nil { return }
        let vc = SHViewController(image: image!)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc func onUndo(_ sender:Any?) {
        if originalImage == nil { return }
        imageView.image = originalImage
        image = originalImage!.copy() as? UIImage
        undoButton.isHidden = true
    }
    
    @objc func onContinue(_ sender:Any?) {
        dismiss(animated: false) {
            self.delegate?.ImagePreviewView(onContinue: self, image: self.image, url: self.url)
        }
    }
}

extension GTCamera_ImagePreviewViewController : SHViewControllerDelegate {
    func shViewControllerImageDidFilter(image: UIImage) {
        self.image = image
        self.imageView.image = image
        undoButton.isHidden = false
    }
    
    func shViewControllerDidCancel() {
        
    }
    
}

extension GTCamera_ImagePreviewViewController : UIScrollViewDelegate {
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
