//
//  GTCamera+CameraViewController.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/27.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import AVFoundation

protocol GTCamera_CameraViewControllerDelegate {
    
}

class GTCamera_CameraViewController: GTCamera_ViewController {

    var delegate:GTCamera_CameraViewControllerDelegate? = nil
    var manager:GTCamera_CameraManager!
    var previewView:UIView!
    var shotView:UIView = UIView()
    var shotImageView:UIImageView = UIImageView()
    var shotButton:UIButton = UIButton()
    
    var flashButton:UIButton = UIButton()
    var flashView:UIView = UIView()
    var flashImageView:UIImageView = UIImageView()
    var flashLabel:UILabel = UILabel()
    
    var positionView:UIView = UIView()
    var positionButton:UIButton = UIButton()
    var positionImageView:UIImageView = UIImageView()
    var positionLabel:UILabel = UILabel()
    
    var cameraTypeView:UIView = UIView()
    var cameraTypeButton:UIButton = UIButton()
    var cameraTypeLabel:UILabel = UILabel()
    
    var focusSquareView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = GTCamera_CameraManager(gtCamera, self)
        previewView = manager.preview
        focusSquareView = manager.focusSquareView
        initView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("[Transision]", size, view.frame.size)
    }
    
    override func viewDidLayoutSubviews() {
        print("[SubViews]", "DidLayut")
        manager.previewLayer?.frame = previewView.frame

        switch UIDevice.current.orientation {
        case .landscapeLeft:
            manager.previewLayer?.connection?.videoOrientation = .landscapeRight
            break
        case .landscapeRight:
            manager.previewLayer?.connection?.videoOrientation = .landscapeLeft
            break
        case .portrait:
            manager.previewLayer?.connection?.videoOrientation = .portrait
            break
        case .portraitUpsideDown:
            manager.previewLayer?.connection?.videoOrientation = .portraitUpsideDown
            break
        default:
            break
        }
        /*
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            manager.previewLayer?.connection?.videoOrientation = .landscapeRight
        } else {
            manager.previewLayer?.connection?.videoOrientation = .portrait
        }
        */
//        manager.focusSquareView.frame = CGRect(x: (previewView.frame.width / 2) - 32, y: (previewView.frame.height / 2) - 32, width: 64, height: 64)
        manager.updateFocus(nil)
    }
    
    private func initView() {
        previewView.translatesAutoresizingMaskIntoConstraints = false
        shotView.translatesAutoresizingMaskIntoConstraints = false
        shotButton.translatesAutoresizingMaskIntoConstraints = false
        shotImageView.translatesAutoresizingMaskIntoConstraints = false
        flashView.translatesAutoresizingMaskIntoConstraints = false
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashLabel.translatesAutoresizingMaskIntoConstraints = false
        flashImageView.translatesAutoresizingMaskIntoConstraints = false
        positionView.translatesAutoresizingMaskIntoConstraints = false
        positionButton.translatesAutoresizingMaskIntoConstraints = false
        positionImageView.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(previewView)
        view.addSubview(shotView)
        view.addSubview(flashView)
        view.addSubview(positionView)
        
        view.addConstraints([
            NSLayoutConstraint(item: previewView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: previewView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        shotView.addConstraints([
            NSLayoutConstraint(item: shotView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80),
            NSLayoutConstraint(item: shotView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 80)
        ])
        view.addConstraints([
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: shotView, attribute: .bottom, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: shotView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        shotView.addSubview(shotImageView)
        shotView.addSubview(shotButton)
        shotView.addConstraints([
            NSLayoutConstraint(item: shotImageView, attribute: .top, relatedBy: .equal, toItem: shotView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shotView, attribute: .bottom, relatedBy: .equal, toItem: shotImageView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shotImageView, attribute: .leading, relatedBy: .equal, toItem: shotView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shotView, attribute: .trailing, relatedBy: .equal, toItem: shotImageView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        shotView.addConstraints([
            NSLayoutConstraint(item: shotButton, attribute: .top, relatedBy: .equal, toItem: shotView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shotView, attribute: .bottom, relatedBy: .equal, toItem: shotButton, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shotButton, attribute: .leading, relatedBy: .equal, toItem: shotView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shotView, attribute: .trailing, relatedBy: .equal, toItem: shotButton, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        shotButton.backgroundColor = .backgroundClearColor
        shotView.bringSubviewToFront(shotButton)
        
        positionView.addSubview(positionImageView)
        positionView.addSubview(positionButton)
        positionView.addSubview(positionLabel)
        positionView.addConstraints([
            NSLayoutConstraint(item: positionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 56),
            NSLayoutConstraint(item: positionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 56)
        ])
        view.addConstraints([
            NSLayoutConstraint(item: positionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: positionView, attribute: .trailing, multiplier: 1, constant: 16)
        ])
        positionView.backgroundColor = .clear
        positionLabel.addConstraints([
            NSLayoutConstraint(item: positionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 24)
        ])
        positionView.addConstraints([
            NSLayoutConstraint(item: positionView, attribute: .bottom, relatedBy: .equal, toItem: positionLabel, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: positionLabel, attribute: .leading, relatedBy: .equal, toItem: positionView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: positionView, attribute: .trailing, relatedBy: .equal, toItem: positionLabel, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        positionView.addConstraints([
            NSLayoutConstraint(item: positionImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: positionImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 32)
        ])
        positionView.addConstraints([
            NSLayoutConstraint(item: positionImageView, attribute: .top, relatedBy: .equal, toItem: positionView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: positionImageView, attribute: .centerX, relatedBy: .equal, toItem: positionView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: positionImageView, attribute: .bottom, relatedBy: .equal, toItem: positionLabel, attribute: .top, multiplier: 1, constant: 0)
        ])
        positionView.addConstraints([
            NSLayoutConstraint(item: positionButton, attribute: .top, relatedBy: .equal, toItem: positionView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: positionView, attribute: .bottom, relatedBy: .equal, toItem: positionButton, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: positionButton, attribute: .leading, relatedBy: .equal, toItem: positionView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: positionView, attribute: .trailing, relatedBy: .equal, toItem: positionButton, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        positionImageView.tintColor = .white
        positionView.backgroundColor = .backgroundClearColor
        positionButton.addTarget(self, action: #selector(onPositionButton(_:)), for: .touchUpInside)
        positionLabel.font = gtCamera.config.cameraButtonLabelFont
        positionLabel.textColor = .white
        positionLabel.textAlignment = .center
        
        flashView.addSubview(flashButton)
        flashView.addSubview(flashLabel)
        flashView.addSubview(flashImageView)
        flashView.addConstraints([
            NSLayoutConstraint(item: flashView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 56),
            NSLayoutConstraint(item: flashView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 56)
        ])
        view.addConstraints([
            NSLayoutConstraint(item: flashView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: flashView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 16)
        ])
        flashView.backgroundColor = .clear
        flashLabel.addConstraints([
            NSLayoutConstraint(item: flashLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 24)
        ])
        flashView.addConstraints([
            NSLayoutConstraint(item: flashView, attribute: .bottom, relatedBy: .equal, toItem: flashLabel, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashLabel, attribute: .leading, relatedBy: .equal, toItem: flashView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashView, attribute: .trailing, relatedBy: .equal, toItem: flashLabel, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        flashImageView.addConstraints([
            NSLayoutConstraint(item: flashImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: flashImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 32)
        ])
        flashView.addConstraints([
            NSLayoutConstraint(item: flashImageView, attribute: .top, relatedBy: .equal, toItem: flashView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashImageView, attribute: .centerX, relatedBy: .equal, toItem: flashView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashImageView, attribute: .bottom, relatedBy: .equal, toItem: flashLabel, attribute: .top, multiplier: 1, constant: 0)
        ])
        flashView.addConstraints([
            NSLayoutConstraint(item: flashButton, attribute: .top, relatedBy: .equal, toItem: flashView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashView, attribute: .bottom, relatedBy: .equal, toItem: flashButton, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashButton, attribute: .leading, relatedBy: .equal, toItem: flashView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashView, attribute: .trailing, relatedBy: .equal, toItem: flashButton, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        flashImageView.tintColor = .white
        flashView.backgroundColor = .backgroundClearColor
        flashButton.addTarget(self, action: #selector(onFlashButton(_:)), for: .touchUpInside)
        flashLabel.font = gtCamera.config.cameraButtonLabelFont
        flashLabel.textColor = .white
        flashLabel.textAlignment = .center

        shotImageView.image = gtCamera.config.cameraCameraButtonIcon
        shotImageView.tintColor = .white
        
        flashView.bringSubviewToFront(flashButton)
        shotView.bringSubviewToFront(shotButton)
        
        shotButton.addTarget(self, action: #selector(onShotButtonTouchDown(_:)), for: .touchDown)
        shotButton.addTarget(self, action: #selector(onShotButtonTouchUp(_:)), for: .touchDragOutside)
        shotButton.addTarget(self, action: #selector(onShotButtonTouchUp(_:)), for: .touchUpOutside)
        shotButton.addTarget(self, action: #selector(onShotButtonTouchUpInside(_:)), for: .touchUpInside)
        
        view.addSubview(focusSquareView)
        
        view.bringSubviewToFront(flashView)
        view.bringSubviewToFront(shotView)
        view.bringSubviewToFront(focusSquareView)
        
        updateView()
    }
    
    private func updateView() {
        
        switch manager.flashMode {
        case .auto:
            flashImageView.image = gtCamera.config.cameraFlashButtonAutoIcon
            flashLabel.text = gtCamera.transition.buttonTitleFlashAuto
            break
        case .on:
            flashImageView.image = gtCamera.config.cameraFlashButtonOnIcon
            flashLabel.text = gtCamera.transition.buttonTitleFlashOn
            break
        case .off:
            flashImageView.image = gtCamera.config.cameraFlashButtonOffIcon
            flashLabel.text = gtCamera.transition.buttonTitleFlashOff
            break
        @unknown default:
            break
        }
        
        switch manager.position {
        case .Front:
            if manager.currentDevice != nil && manager.currentDevice!.position == .back {
                manager.currentDevice = manager.cameraDevices[.Front]?.first
            }
            positionImageView.image = gtCamera.config.cameraRotateButtonIconFront
            positionLabel.text = gtCamera.transition.buttonTitleCameraFront
            break
        case .Back:
            if manager.currentDevice != nil && manager.currentDevice!.position == .front {
                manager.currentDevice = manager.cameraDevices[.Back]?.first
            }
            positionImageView.image = gtCamera.config.cameraRotateButtonIconBack
            positionLabel.text = gtCamera.transition.buttonTitleCameraBack
            break
        }
        
        view.layoutIfNeeded()
        manager.updateView()
        focusSquareView.frame = CGRect(x: previewView.frame.origin.x + (previewView.frame.width / 2) - 32, y: (previewView.frame.height / 2) - 32, width: 64, height: 64)
    }

    @objc func onFlashButton(_ sender:Any?) {
        guard let mode = AVCaptureDevice.FlashMode(rawValue: (manager.flashMode.rawValue + 1) % 3) else { return }
        manager.flashMode = mode
        updateView()
    }
    
    @objc func onPositionButton(_ sender:Any?) {
        guard let position = GTCamera_CameraManager.Position(rawValue: (manager.position.rawValue + 1) % 2) else { return }
        manager.position = position
        updateView()
    }
    
    @objc func onDeviceRotated(_ sender:Any?) {
        manager.updateLayerFrame()
    }
    
    @objc func onShotButtonTouchDown(_ sender:Any?) {
        shotImageView.tintColor = .gray
    }
    
    @objc func onShotButtonTouchUp(_ sender:Any?) {
        shotImageView.tintColor = .white
    }

    @objc func onShotButtonTouchUpInside(_ sender:Any?) {
        shotImageView.tintColor = .white
        manager.takePhoto()
    }

}
