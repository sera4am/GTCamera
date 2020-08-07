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
    }
    
    override func viewDidLayoutSubviews() {
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
        shotView.addSubview(shotImageView)
        shotView.addSubview(shotButton)
        view.addSubview(positionView)
        positionView.addSubview(positionImageView)
        positionView.addSubview(positionButton)
        positionView.addSubview(positionLabel)
        view.addSubview(flashView)
        flashView.addSubview(flashButton)
        flashView.addSubview(flashLabel)
        flashView.addSubview(flashImageView)

        shotButton.backgroundColor = .backgroundClearColor
        shotView.bringSubviewToFront(shotButton)
        positionView.backgroundColor = .clear
        positionImageView.tintColor = .white
        positionView.backgroundColor = .backgroundClearColor
        positionButton.addTarget(self, action: #selector(onPositionButton(_:)), for: .touchUpInside)
        positionLabel.font = gtCamera.config.cameraButtonLabelFont
        positionLabel.textColor = .white
        positionLabel.textAlignment = .center
        flashView.backgroundColor = .clear
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

        NSLayoutConstraint.activate([
            // preview view
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: previewView.bottomAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: previewView.trailingAnchor),
            
            // shot view
            shotView.widthAnchor.constraint(equalToConstant: 80),
            shotView.heightAnchor.constraint(equalToConstant: 80),
            view.bottomAnchor.constraint(equalTo: shotView.bottomAnchor, constant: 16),
            shotView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // shot image view
            shotImageView.topAnchor.constraint(equalTo: shotView.topAnchor),
            shotView.bottomAnchor.constraint(equalTo: shotImageView.bottomAnchor),
            shotImageView.leadingAnchor.constraint(equalTo: shotView.leadingAnchor),
            shotView.trailingAnchor.constraint(equalTo: shotImageView.trailingAnchor),
            
            // shot button
            shotButton.topAnchor.constraint(equalTo: shotView.topAnchor),
            shotView.bottomAnchor.constraint(equalTo: shotButton.bottomAnchor),
            shotButton.leadingAnchor.constraint(equalTo: shotView.leadingAnchor),
            shotView.trailingAnchor.constraint(equalTo: shotButton.trailingAnchor),
            
            // position view
            positionView.widthAnchor.constraint(equalToConstant: 56),
            positionView.heightAnchor.constraint(equalToConstant: 56),
            positionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: positionView.trailingAnchor, constant: 16),
            
            // position label
            positionLabel.heightAnchor.constraint(equalToConstant: 24),
            positionView.bottomAnchor.constraint(equalTo: positionLabel.bottomAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: positionView.leadingAnchor),
            positionView.trailingAnchor.constraint(equalTo: positionLabel.trailingAnchor),
            
            // position image view
            positionImageView.widthAnchor.constraint(equalToConstant: 32),
            positionImageView.heightAnchor.constraint(equalToConstant: 32),
            positionImageView.topAnchor.constraint(equalTo: positionView.topAnchor),
            positionImageView.centerXAnchor.constraint(equalTo: positionView.centerXAnchor),
//            positionImageView.bottomAnchor.constraint(equalTo: positionLabel.topAnchor),
            
            // position buttoon
            positionButton.topAnchor.constraint(equalTo: positionView.topAnchor),
            positionView.bottomAnchor.constraint(equalTo: positionButton.bottomAnchor),
            positionButton.leadingAnchor.constraint(equalTo: positionView.leadingAnchor),
            positionView.trailingAnchor.constraint(equalTo: positionButton.trailingAnchor),
            
            // flash view
            flashView.widthAnchor.constraint(equalToConstant: 56),
            flashView.heightAnchor.constraint(equalToConstant: 56),
            flashView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            flashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // flash label
            flashLabel.heightAnchor.constraint(equalToConstant: 24),
            flashView.bottomAnchor.constraint(equalTo: flashLabel.bottomAnchor),
            flashLabel.leadingAnchor.constraint(equalTo: flashView.leadingAnchor),
            flashView.trailingAnchor.constraint(equalTo: flashLabel.trailingAnchor),
          
            // flash iamge view
            flashImageView.widthAnchor.constraint(equalToConstant: 32),
            flashImageView.heightAnchor.constraint(equalToConstant: 32),
            flashImageView.topAnchor.constraint(equalTo: flashView.topAnchor),
            flashImageView.centerXAnchor.constraint(equalTo: flashView.centerXAnchor),
//            flashImageView.bottomAnchor.constraint(equalTo: flashLabel.topAnchor),
            
            // flash button
            flashButton.topAnchor.constraint(equalTo: flashView.topAnchor),
            flashView.bottomAnchor.constraint(equalTo: flashButton.bottomAnchor),
            flashButton.leadingAnchor.constraint(equalTo: flashView.leadingAnchor),
            flashView.trailingAnchor.constraint(equalTo: flashButton.trailingAnchor),
        ])

        view.addSubview(focusSquareView)
        view.bringSubviewToFront(flashView)
        view.bringSubviewToFront(shotView)
        view.bringSubviewToFront(focusSquareView)
        
        updateView()
    }
    
    private func updateView() {
        
        if is_iPad() || !(manager.currentDevice?.hasFlash ?? false) {
            flashView.isHidden = true
        } else {
            flashView.isHidden = false
            switch manager.flashMode {
            case .auto:
                flashImageView.image = gtCamera.config.cameraFlashButtonAutoIcon
                flashLabel.text = gtCamera.translation.buttonTitleFlashAuto
                break
            case .on:
                flashImageView.image = gtCamera.config.cameraFlashButtonOnIcon
                flashLabel.text = gtCamera.translation.buttonTitleFlashOn
                break
            case .off:
                flashImageView.image = gtCamera.config.cameraFlashButtonOffIcon
                flashLabel.text = gtCamera.translation.buttonTitleFlashOff
                break
            @unknown default:
                break
            }
        }
        
        switch manager.position {
        case .Front:
            if manager.currentDevice != nil && manager.currentDevice!.position == .back {
                manager.currentDevice = manager.cameraDevices[.Front]?.first
            }
            positionImageView.image = gtCamera.config.cameraRotateButtonIconFront
            positionLabel.text = gtCamera.translation.buttonTitleCameraFront
            break
        case .Back:
            if manager.currentDevice != nil && manager.currentDevice!.position == .front {
                manager.currentDevice = manager.cameraDevices[.Back]?.first
            }
            positionImageView.image = gtCamera.config.cameraRotateButtonIconBack
            positionLabel.text = gtCamera.translation.buttonTitleCameraBack
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
