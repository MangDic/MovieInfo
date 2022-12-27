//
//  SearchResultCell.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/23.
//

import UIKit
import Kingfisher

class SearchResultCell: UITableViewCell {
    static let id = "SearchResultCell"
    
    lazy var contentStack = UIStackView().then {
        $0.spacing = 10
    }
    
    lazy var thumbNail = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    lazy var labelStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    lazy var overViewLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }
    
    lazy var rateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    lazy var tagStack = UIStackView().then {
        $0.spacing = 3
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagStack.removeAllArrangedSubviews()
    }
    
    func configure(data: ResultMovie) {
        titleLabel.text = data.original_title
        overViewLabel.text = data.overview
        let rateValue = data.vote_average == 0.0 ? "-점" : "\(data.vote_average)점"
        rateLabel.text = "평점: " + rateValue
        
        DispatchQueue.main.async {
            if let path = data.poster_path,
                let url = URL(string: NetworkController.imageUrl + path) {
                
                self.thumbNail.kf.setImage(with: url)
            }
        }
        
        if data.genre_ids.count == 0 { return }
        var cnt = 0
        for genre in data.genre_ids {
            if cnt == 3 { break }
            
            guard let view = createTagView(id: genre) else { continue }
            tagStack.addArrangedSubview(view)
            cnt += 1
        }
        
        tagStack.addArrangedSubview(UIView())
        
    }
    
    private func createTagView(id: Int) -> UIView? {
        guard let tag = GenreManager.shared.genreDic[id] else { return nil }
        let view = UIView().then {
            $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            $0.layer.cornerRadius = 4
        }
        
        let label = UILabel().then {
            $0.text = tag
            $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            $0.textColor = .white
        }
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.top.bottom.equalToSuperview().inset(3)
        }
        return view
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(thumbNail)
        contentStack.addArrangedSubview(labelStack)
        
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(overViewLabel)
        labelStack.addArrangedSubview(rateLabel)
        labelStack.addArrangedSubview(tagStack)
        labelStack.addArrangedSubview(UIView())
        
        thumbNail.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 110))
        }
        
        contentStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(5)
        }
    }
}
