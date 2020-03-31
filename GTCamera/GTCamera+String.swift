//
//  GTCamera+String.swift
//  Pods_GTCamera
//
//  Created by 風間剛男 on 2020/03/30.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
    return NSLocalizedString(self, comment: "")
    }
    
    func substring(_ r: CountableRange<Int>) -> String {

        let length = self.count
        let fromIndex = (r.startIndex > 0) ? self.index(self.startIndex, offsetBy: r.startIndex) : self.startIndex
        let toIndex = (length > r.endIndex) ? self.index(self.startIndex, offsetBy: r.endIndex) : self.endIndex

        if fromIndex >= self.startIndex && toIndex <= self.endIndex {
            return String(self[fromIndex..<toIndex])
        }

        return String(self)
    }

    func substring(_ r: CountableClosedRange<Int>) -> String {

        let from = r.lowerBound
        let to = r.upperBound

        return self.substring(from..<(to+1))
    }

    func substring(_ r: CountablePartialRangeFrom<Int>) -> String {

        let from = r.lowerBound
        let to = self.count

        return self.substring(from..<to)
    }

    func substring(_ r: PartialRangeThrough<Int>) -> String {

        let from = 0
        let to = r.upperBound

        return self.substring(from..<to)
    }
}

