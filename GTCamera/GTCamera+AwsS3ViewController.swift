//
//  GTCamera+AwsS3ViewController.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/27.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit
import Kingfisher
import AWSS3

protocol GTCamera_AwsS3ViewControllerDelegate {
    
}

class GTCamera_AwsS3ViewController: GTCamera_ViewController {

    var delegate:GTCamera_AwsS3ViewControllerDelegate? = nil
    var collectionView:UICollectionView!
    var imageUrl:[URL] = []
    var errorView:UIView = UIView()
    var errorLabel:UILabel = UILabel()
    var errorIcon:UIImageView = UIImageView()
    
    var loadingView:UIView = UIView()
    var loadingLabel:UILabel = UILabel()
    var loadingIcon:UIImageView = UIImageView()
    
    var selectedImage:UIImage? = nil
    var selectedUrl:URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorIcon.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(errorIcon)
        
        view.addConstraints([
            NSLayoutConstraint(item: errorView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: errorView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: errorView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: errorView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        errorIcon.addConstraints([
            NSLayoutConstraint(item: errorIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: errorIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 64)
        ])
        errorView.addConstraints([
            NSLayoutConstraint(item: errorIcon, attribute: .centerX, relatedBy: .equal, toItem: errorView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: errorIcon, attribute: .centerY, relatedBy: .equal, toItem: errorView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        errorView.addConstraints([
            NSLayoutConstraint(item: errorLabel, attribute: .centerX, relatedBy: .equal, toItem: errorView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: errorLabel, attribute: .top, relatedBy: .equal, toItem: errorIcon, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: errorLabel, attribute: .leading, relatedBy: .equal, toItem: errorView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: errorView, attribute: .trailing, relatedBy: .equal, toItem: errorLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: errorView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: errorLabel, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        errorLabel.numberOfLines = 0
        errorView.backgroundColor = .darkGray
        errorLabel.textColor = .gray
        errorIcon.tintColor = .gray
        errorIcon.image = gtCamera.config.awsS3LoadErrorIcon
        errorLabel.text = gtCamera.translation.messageAWSS3NoImages
        errorLabel.textAlignment = .center
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingIcon.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loadingView)
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(loadingIcon)
        view.addConstraints([
            NSLayoutConstraint(item: loadingView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: loadingView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: loadingView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        loadingIcon.addConstraints([
            NSLayoutConstraint(item: loadingIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: loadingIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 64)
        ])
        loadingView.addConstraints([
            NSLayoutConstraint(item: loadingIcon, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingIcon, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        loadingView.addConstraints([
            NSLayoutConstraint(item: loadingLabel, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingLabel, attribute: .top, relatedBy: .equal, toItem: loadingIcon, attribute: .bottom, multiplier: 1, constant: 8)
        ])
        loadingView.backgroundColor = .darkGray
        loadingLabel.textColor = .gray
        loadingIcon.tintColor = .gray
        loadingIcon.image = gtCamera.config.awsS3LoadLoadingIcon
        loadingLabel.text = gtCamera.translation.messageAWSS3Loading
        loadingLabel.textAlignment = .center
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width / 4, height: view.frame.height / 6)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        view.addSubview(collectionView)
        view.addConstraints([
            NSLayoutConstraint(item: collectionView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: collectionView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        
        collectionView.register(GTCamera_AWSS3CollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentSize = CGSize(width: view.frame.width / 4, height: view.frame.height / 6)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.bringSubviewToFront(errorView)
        view.bringSubviewToFront(loadingView)
        
        errorView.isHidden = true
        
        loadFileList()
    }
    
    func loadFileList() {
        if !gtCamera.config.awsS3Enabled {
            loadingView.isHidden = true
            errorView.isHidden = false
            errorLabel.text = gtCamera.translation.messageAWSS3Invalid
        }
        if gtCamera.config.awsS3Bucket == nil {
            loadingView.isHidden = true
            errorView.isHidden = false
            errorLabel.text = gtCamera.translation.messageAWSS3UndefinedSetting
            return
        }
        
        var s3:AWSS3 = AWSS3.default()
        if gtCamera.config.awsS3ConfigKey != nil {
            s3 = AWSS3.s3(forKey: gtCamera.config.awsS3ConfigKey!)
        }
        let listRequest:AWSS3ListObjectsRequest = AWSS3ListObjectsRequest()
        listRequest.encodingType = .URL
        listRequest.bucket = gtCamera.config.awsS3Bucket!
        s3.listObjects(listRequest) { (output, error) in
            print("call returned")
            if error != nil {
                DispatchQueue.main.async {
                    self.loadingView.isHidden = true
                    self.errorView.isHidden = false
                    self.errorLabel.text = "\(self.gtCamera.translation.messageAWSS3LoadError)\n\n\(error!.localizedDescription)"
                }
            } else {
                for obj in output?.contents ?? [] {
                    if obj.key == nil { continue }
                    if self.gtCamera.config.awsS3PrefixPath != nil && !obj.key!.hasPrefix(self.gtCamera.config.awsS3PrefixPath!) {
                        continue
                    }
                    let url = s3.configuration.endpoint.url.appendingPathComponent(self.gtCamera.config.awsS3Bucket!).appendingPathComponent(obj.key!)
                    let ext = url.pathExtension.lowercased()
                    if !self.gtCamera.config.awsS3AllowImageExtensions.contains(ext) {
                        continue
                    }
                    self.imageUrl.append(url)
                }
                
                DispatchQueue.main.async {
                    self.loadingView.isHidden = true
                    if self.imageUrl.count > 0 {
                        self.collectionView.reloadData()
                    } else {
                        self.errorView.isHidden = false
                        self.errorLabel.text = self.gtCamera.translation.messageAWSS3NoImages
                    }
                }
            }
        }
    }
}

extension GTCamera_AwsS3ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GTCamera_AWSS3CollectionCell else { return }
        guard let image = cell.imageView.image else { return }
        gtCamera.selectedImage = image
        gtCamera.selectedUrl = cell.url
        gtCamera.secondPreviewImage(true)
    }
}

extension GTCamera_AwsS3ViewController : GTCamera_ImagePreviewViewControllerDelegate {
    func ImagePreviewView(onContinue viewController: GTCamera_ImagePreviewViewController, image: UIImage?, url: URL?) {
        gtCamera.selectedImage = image
        gtCamera.selectedUrl = url
        gtCamera.secondPreviewImage()
    }
}

extension GTCamera_AwsS3ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GTCamera_AWSS3CollectionCell
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.clipsToBounds = true
        let url = imageUrl[indexPath.row]
        cell.url = url
        cell.imageView.kf.setImage(with: url, options: [.cacheOriginalImage])
        return cell
    }
}

extension GTCamera_AwsS3ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width / 4, height: view.frame.height / 6)
        print(size)
        return size
    }
    
}

class GTCamera_AWSS3CollectionCell : UICollectionViewCell {
    
    var imageView:UIImageView = UIImageView()
    var url:URL? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        contentView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        imageView.contentMode = .scaleAspectFill
    }
}
