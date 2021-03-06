//
//  GTCamera+UIView.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/30.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

extension UIView {

    func addBlur(style: UIBlurEffect.Style = .extraLight, alpha:CGFloat = 0.8) {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: style)
        blurView.frame = bounds
        blurView.alpha = alpha
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        insertSubview(blurView, at: 0)
    }

}
