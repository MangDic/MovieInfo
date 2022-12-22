//
//  UIScrollView+.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import UIKit

extension UICollectionView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
