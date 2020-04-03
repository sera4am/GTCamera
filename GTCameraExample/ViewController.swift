//
//  ViewController.swift
//  GTCameraExample
//
//  Created by 風間剛男 on 2020/04/03.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import GTCamera

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSimple(_ sender: Any) {
        let vc = GTCameraViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onCustomize(_ sender: Any) {
        GTCamera_Config.Default.libraryEnabled = false
        GTCamera_Translation.Default.tabTitleCamera = "Photo"
        GTCamera_Config.Default.cameraFlashButtonAutoIcon = UIImage(systemName: "person.fill")!
        GTCamera_Config.Default.cameraFlashButtonOnIcon = UIImage(systemName: "person.2.fill")!
        GTCamera_Config.Default.cameraFlashButtonOffIcon = UIImage(systemName: "person.3.fill")!
        let vc = GTCameraViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onResetDefaultSettings(_ sender: Any) {
        GTCamera_Config.Default = GTCamera_Config()
        GTCamera_Translation.Default = GTCamera_Translation()
    }
    
    @IBAction func onAwsS3(_ sender: Any) {
        
        // ATTENSION!!! CRASH BEFORE AWS SETTING. (I am not bad)
        
        // First. You need additional Podfile `pod "AWSS3"` and pod install
        // Second. Open AppDelegate.swift and set default credential config to AWS (need aws s3 role)
        // Third setup berow
        
        var config = GTCamera_Config()
        config.awsS3Enabled = true
        config.awsS3Bucket = "Your AWS S3 bucket name"
        config.awsS3PrefixPath = "Your AWS S3 key at prefix. Example <bucket>/foo/bar/baz.png then 'foo/bar'"
        config.awsS3ConfigKey = "Optinal: If need AWS S3 credential config key. Default credential for default"
        config.awsS3AllowImageExtensions = ["Optional", "Choice allowed image extensions if you need"]
        
        let vc = GTCameraViewController(config: config)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onPreview(_ sender: Any) {
        
        let vc = GTCameraPreviewViewController(URL(string: "https://tripperrequest.s3-ap-northeast-1.amazonaws.com/user_data/000/000/001/image/2534.jpg")!)
        vc.dataSource = self
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController : GTCameraPreviewViewControllerDelegate {
    func GTCameraPreviewView(onButton viewController: GTCameraPreviewViewController, position: GTCameraPreviewViewController.ButtonPosition, type: GTCameraPreviewViewController.ButtonType) -> Bool {
        switch type {
        case .Back, .Close:
            return true
        case .Delete:
            let ac = UIAlertController(title: "本当に削除しますか", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                if viewController.navigationController != nil {
                    viewController.navigationController?.popViewController(animated: true)
                } else {
                    viewController.dismiss(animated: true, completion: nil)
                }
            }))
            ac.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            viewController.present(ac, animated: true, completion: nil)
            return false
        default:
            return false
        }
    }
}

extension ViewController : GTCameraPreviewViewControllerDataSource {

    func GTCameraPreviewView(buttonTypeFor viewController: GTCameraPreviewViewController, position: GTCameraPreviewViewController.ButtonPosition) -> GTCameraPreviewViewController.ButtonType? {
        switch position {
        case .topRight:
            return .Continue
        case .bottomRight:
            return .Edit
        case .bottomLeft:
            return .Delete
        case .bottomCenter:
            return .Apply
        case .topCenter:
            return .Crop
        default:
            return nil
        }
    }

}



extension ViewController : GTCameraDelegate {
    func gtCameraOn(selectLocalImage gtCamera: GTCameraViewController, image: UIImage?, url: URL?) {
        gtCamera.dismiss(animated: true) {
            let ac = UIAlertController(title: "Select Image", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
}

