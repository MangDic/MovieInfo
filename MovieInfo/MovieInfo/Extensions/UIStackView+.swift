//
//  UIStackView+.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/23.
//
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
