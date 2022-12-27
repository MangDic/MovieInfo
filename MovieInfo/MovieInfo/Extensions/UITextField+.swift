//
//  UITextField+.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/23.
//

import UIKit

extension UITextField {
    func addLeftInset(inset: CGFloat) {
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
        self.leftView = leftInsetView
        self.leftViewMode = ViewMode.always
    }
}
