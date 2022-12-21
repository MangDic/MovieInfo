//
//  DetailViewController.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Kingfisher
import ReactorKit

class DetailViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let loadTrigger = PublishRelay<Void>()
    
    let movieRelay = PublishRelay<Movie>()
    
    init(reactor: DetailReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
        loadTrigger.accept(())
    }
    
    func setupDI(movie: Movie) {
        movieRelay.accept(movie)
    }
    
    private func bind() {
        movieRelay.subscribe(onNext: { [weak self] movie in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                if let urlStr = movie.thumbnailImage, let url = URL(string: urlStr) {
                    self.thumbNail.kf.setImage(with: url)
                }
                
                if let title = movie.title {
                    self.titleLabel.text = title
                }
                
                if let genre = movie.genreNames {
                    self.genreLabel.text = genre
                }
                
                if let rate = movie.ratingAverage {
                    self.rateLabel.text = "평점 " + rate
                }
                
                if let link = movie.linkUrl {
                    self.linkLabel.text = link
                }
            }
        }).disposed(by: disposeBag)
    }
    
    lazy var contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    lazy var thumbNail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    lazy var infoStack = UIStackView().then {
        $0.spacing = 10
    }
    
    lazy var genreLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    lazy var rateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    lazy var divider = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var linkLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.numberOfLines = 3
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        view.addSubview(contentStack)
        
        contentStack.addArrangedSubview(thumbNail)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(infoStack)
        contentStack.addArrangedSubview(linkLabel)
        contentStack.addArrangedSubview(UIView())
        
        infoStack.addArrangedSubview(genreLabel)
        infoStack.addArrangedSubview(divider)
        infoStack.addArrangedSubview(rateLabel)
        infoStack.addArrangedSubview(UIView())
        
        contentStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        thumbNail.snp.makeConstraints {
            $0.height.equalTo(self.view.frame.width * 1.5)
        }
        
        divider.snp.makeConstraints {
            $0.width.equalTo(1)
        }
    }
}

extension DetailViewController: View {
    func bind(reactor: DetailReactor) {
        loadTrigger
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
            
        reactor.state
            .map{ $0.movie }
            .bind(to: self.movieRelay)
            .disposed(by: disposeBag)
    }
}
