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
    
    let movieRelay = PublishRelay<DetailMovie?>()
    
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
    
    func setupDI(movie: DetailMovie) {
        movieRelay.accept(movie)
    }
    
    private func bind() {
        movieRelay.subscribe(onNext: { [weak self] movie in
            guard let `self` = self else { return }
            guard let movie = movie else { return }
            DispatchQueue.main.async {
                if let url = URL(string: NetworkController.imageUrl + movie.poster_path) {
                    self.thumbNail.kf.setImage(with: url)
                }
                self.titleLabel.text = movie.title
                self.tagLabel.text = movie.tagline
                self.rateLabel.text = "평점: \(movie.vote_average)"
                self.runtimeLabel.text = "상영시간: \(movie.runtime)분"
                self.releaseDateLabel.text = movie.release_date
                self.overviewLabel.text = movie.overview
            }
        }).disposed(by: disposeBag)
    }
    
    lazy var scrollView = UIScrollView()
    
    lazy var contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    lazy var thumbNail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    lazy var tagLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
    
    lazy var overviewLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    lazy var runtimeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    lazy var releaseDateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(thumbNail)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(tagLabel)
        contentStack.addArrangedSubview(infoStack)
        contentStack.addArrangedSubview(overviewLabel)
        contentStack.addArrangedSubview(UIView())
        
        infoStack.addArrangedSubview(rateLabel)
        createDivider(infoStack)
        infoStack.addArrangedSubview(runtimeLabel)
        createDivider(infoStack)
        infoStack.addArrangedSubview(releaseDateLabel)
        infoStack.addArrangedSubview(UIView())
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        contentStack.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
            $0.width.equalTo(view.frame.width).priority(.high)
            $0.width.equalTo(scrollView.contentLayoutGuide).priority(.low)
        }
        
        thumbNail.snp.makeConstraints {
            $0.height.equalTo(self.view.frame.width * 1.5)
        }
    }
    
    private func createDivider(_ superView: UIStackView) {
        let divider = UIView().then {
            $0.backgroundColor = .white
        }
        superView.addArrangedSubview(divider)
        
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
