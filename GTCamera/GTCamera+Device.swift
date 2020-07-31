//
//  GTCamera+Device.swift
//  GTCamera
//
//  Created by 風間剛男 on 2020/07/22.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

func is_iPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
