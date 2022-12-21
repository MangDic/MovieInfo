//
//  MovieCell.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    static let id = "MovieCell"
    
    lazy var thumbNail = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Movie) {
        if let urlStr = data.thumbnailImage, let url = URL(string: urlStr) {
            DispatchQueue.main.async {
                self.thumbNail.kf.setImage(with: url)
            }
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(thumbNail)
        
        thumbNail.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
