//
//  StikeyScrollView.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/23.
//

import Foundation
import UIKit
import RxSwift

class StickeyScrollView: UIView {
    var disposeBag = DisposeBag()
    
    var currentOffset: CGFloat = 0
    
    lazy var contentStack = UIStackView().then {
        $0.axis = .vertical
    }
    
    lazy var headerView = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var backButton = UIButton().then {
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    }
    
    var scrollView: UIScrollView
    
    let contentView: UIView?
    
    init(contentView: UIView? = nil, scrollView: UIScrollView = UIScrollView()) {
        self.contentView = contentView
        self.scrollView = scrollView
        super.init(frame: .zero)
        
        setupLayout()
        setupScrollViewDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollViewDelegate() {
        scrollView.delegate = self
    }
    
    private func showHeaderView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.headerView.alpha = 1
                self.scrollView.transform = .identity
                self.headerView.transform = .identity
            })
        }
    }
    
    private func hideHeaderView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.headerView.alpha = 0
                self.headerView.transform = CGAffineTransform(translationX: 0, y: -self.headerView.frame.height)
                self.scrollView.transform = CGAffineTransform(translationX: 0, y: -self.headerView.frame.height)
            })
        }
    }
    
    private func setupLayout() {
        addSubview(headerView)
        addSubview(scrollView)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(backButton)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        guard let contentView = contentView else { return }
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
            $0.width.equalTo(frame.width).priority(.high)
            $0.width.equalTo(scrollView.contentLayoutGuide).priority(.low)
        }
    }
    
    func isHideBackButton(_ isHidden: Bool = true) {
        backButton.isHidden = isHidden
    }
}

extension StickeyScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset < 0 || offset > scrollView.contentSize.height - scrollView.frame.height { return }
        
        if currentOffset < offset {
            hideHeaderView()
        }
        else {
            showHeaderView()
        }
        currentOffset = offset
    }
}
