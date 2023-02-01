//
//  UIView+.swift
//  MovieInfo
//
//  Created by 이명직 on 2023/02/01.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}
