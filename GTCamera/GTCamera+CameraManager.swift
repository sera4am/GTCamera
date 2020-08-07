//
//  GTCamera+CameraManager.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/30.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import AVFoundation

class GTCamera_CameraManager: NSObject {

    var gtCamera:GTCameraViewController!
    var viewController:GTCamera_CameraViewController!
    var captureDevice:AVCaptureDevice? = nil
    
    enum Position:Int {
        case Front
        case Back
    }
    
    enum FocusMode:Int {
        case locked
        case autoFocus
        case continuousAutoFocus
    }
    
    open var preview:UIView = UIView()
    open var focusSquareView:UIView = UIView()
    open var currentDevice:AVCaptureDevice? = nil
    open var cameraDevices:[Position:[AVCaptureDevice]] = [:] {
        didSet {
            updateView()
        }
    }
    open var flashMode:AVCaptureDevice.FlashMode = .auto
    open var position:Position = .Back
    open var focusMode:FocusMode = .autoFocus
    open var focusPoint:CGPoint? = nil {
        didSet {
            updateFocus(focusPoint)
        }
    }
    
//    var photoOutput:AVCapturePhotoOutput? = nil
    var captureSession:AVCaptureSession? = nil
    var previewLayer:AVCaptureVideoPreviewLayer? = nil
    
    var baseZoomFactor:CGFloat = 1.0
    
    private var keyValueObservations = [NSKeyValueObservation]()
    
    init(_ gtCamera:GTCameraViewController, _ viewController:GTCamera_CameraViewController) {
        self.gtCamera = gtCamera
        self.viewController = viewController
        
        let deviceDiscaverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [
            .builtInDualCamera,
            .builtInDualWideCamera,
            .builtInTripleCamera,
            .builtInTrueDepthCamera,
            .builtInUltraWideCamera,
            .builtInWideAngleCamera
        ], mediaType: .video, position: .unspecified)
        
        for device in deviceDiscaverySession.devices {
            switch device.position {
            case .back:
                if cameraDevices[.Back] == nil {
                    cameraDevices[.Back] = []
                }
                cameraDevices[.Back]?.append(device)
                break
            case .front:
                if cameraDevices[.Front] == nil {
                    cameraDevices[.Front] = []
                }
                cameraDevices[.Front]?.append(device)
                break
            default:
                break
            }
        }
        
        currentDevice = cameraDevices[.Back]?.first
        
        focusSquareView.layer.borderColor = UIColor.white.cgColor
        focusSquareView.layer.borderWidth = 1.5
        focusSquareView.isUserInteractionEnabled = false
        
        super.init()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPreviewTapped(_:)))
        preview.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onPreviewPinch(_:)))
        preview.addGestureRecognizer(pinchGesture)
    }
    
    @objc func onPreviewTapped(_ sender:Any?) {
        guard let gesture = sender as? UIGestureRecognizer else { return }
        let point = gesture.location(in: preview)
        focusPoint = point
    }
    
    @objc func onPreviewPinch(_ sender:UIPinchGestureRecognizer) {
        if currentDevice == nil { return }
        
        if sender.state == .began {
            baseZoomFactor = currentDevice!.videoZoomFactor
        }
        
        var zoom:CGFloat = baseZoomFactor * sender.scale
        if zoom < currentDevice!.minAvailableVideoZoomFactor { zoom = currentDevice!.minAvailableVideoZoomFactor }
        if zoom > currentDevice!.maxAvailableVideoZoomFactor { zoom = currentDevice!.maxAvailableVideoZoomFactor }
        
        do {
            try currentDevice?.lockForConfiguration()
            currentDevice?.ramp(toVideoZoomFactor: zoom, withRate: 32.0)
            currentDevice?.unlockForConfiguration()
        } catch {
            print("Failed to change zoom factor.")
        }
    }
    
    func updateView() {
        if currentDevice == nil {
            return
        }
        
        captureSession?.stopRunning()
        try? currentDevice?.lockForConfiguration()
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice!) else { return }
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        captureSession?.addInput(captureDeviceInput)
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession?.addOutput(photoOutput)
        
        previewLayer?.removeFromSuperlayer()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        previewLayer?.frame = preview.frame
        preview.layer.insertSublayer(previewLayer!, at: 0)
        currentDevice?.unlockForConfiguration()
        currentDevice?.isFocusModeSupported(.autoFocus)
        captureSession?.startRunning()

        if currentDevice != nil {
            keyValueObservations.append(currentDevice!.observe(\.isAdjustingFocus, changeHandler: { (device, changes) in
                if self.currentDevice?.isAdjustingFocus ?? true {
                    self.focusSquareView.layer.borderColor = UIColor.white.cgColor
                } else if !self.focusSquareView.isHidden && self.focusSquareView.layer.borderColor == UIColor.white.cgColor {
                    self.focusSquareView.layer.borderColor = UIColor.green.cgColor
                    self.focusSquareView.layer.borderWidth = 2.5
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.focusSquareView.layer.borderColor = UIColor.clear.cgColor
                        }) { _ in
                            self.focusSquareView.isHidden = true
                        }
                    }
                }
            }))
        }
        
        if focusMode == .autoFocus {
            focusSquareView.isHidden = true
        } else {
            focusSquareView.frame = CGRect(x: (preview.frame.width / 2) - 32, y: (preview.frame.height / 2) - 32, width: 64, height: 64)
        }
    }
    
    func updateLayerFrame() {
        previewLayer?.connection?.videoOrientation = .portrait
        previewLayer?.frame = preview.frame
    }
    
    
    func updateFocus(_ point:CGPoint?) {
        
        focusSquareView.isHidden = true

        if !(currentDevice?.isFocusPointOfInterestSupported ?? false) || !(currentDevice?.isFocusModeSupported(.autoFocus) ?? false) {
//            currentDevice?.focusMode = .autoFocus
            return
        }

        if point == nil {
            guard let _ = try? currentDevice?.lockForConfiguration() else { return }
            currentDevice?.focusMode = .autoFocus
            currentDevice?.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
            currentDevice?.unlockForConfiguration()
            return
        }
        
        guard let pPoint = previewLayer?.captureDevicePointConverted(fromLayerPoint: point!) else { return }
        focusMode = .autoFocus
        guard let _ = try? currentDevice?.lockForConfiguration() else { return }
        focusSquareView.frame = CGRect(x: point!.x - 32, y: point!.y - 32, width: 64, height: 64)
        focusSquareView.isHidden = false
        focusSquareView.layer.borderColor = UIColor.white.cgColor
        focusSquareView.layer.borderWidth = 1.5
        currentDevice?.focusMode = .autoFocus
        currentDevice?.focusPointOfInterest = pPoint
        currentDevice?.unlockForConfiguration()
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        if is_iPad() || !(currentDevice?.hasFlash ?? false) {
            settings.flashMode = .off
        } else {
            settings.flashMode = flashMode
        }
        settings.isAutoStillImageStabilizationEnabled = true
        guard let output = captureSession?.outputs.first as? AVCapturePhotoOutput else { return }
        guard let orientation = previewLayer?.connection?.videoOrientation else { return }
        output.connection(with: AVMediaType.video)?.videoOrientation = orientation
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension GTCamera_CameraManager : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            gtCamera.didTakePhoto(self, nil, error)
            return
        }
        let imageData = photo.fileDataRepresentation()!
//        let image = UIImage(cgImage: photo.cgImageRepresentation(), scale: 0, orientation: previewLayer?.connection?.videoOrientation)
        let image = UIImage(data: imageData)!.fixedOrientation()
        gtCamera.didTakePhoto(self, image, nil)
        
    }
    
}
