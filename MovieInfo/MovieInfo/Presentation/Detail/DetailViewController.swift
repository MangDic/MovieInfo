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
        tabBarController?.tabBar.isHidden = true
        setupLayout()
        bind()
        
        loadTrigger.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupDI(movie: DetailMovie) {
        movieRelay.accept(movie)
    }
    
    private func bind() {
        movieRelay.subscribe(onNext: { [weak self] movie in
            guard let `self` = self else { return }
            guard let movie = movie else { return }
            DispatchQueue.main.async {
                if let path = movie.poster_path, let url = URL(string: NetworkController.imageUrl + path) {
                    self.thumbNail.kf.setImage(with: url)
                }
                self.titleLabel.text = movie.title
                self.stickeyView?.titleLabel.text = movie.title
                self.navigationController?.navigationBar.topItem?.title = movie.title
                self.tagLabel.text = movie.tagline
                self.rateLabel.text = R.String.MovieDetail.average(movie.vote_average)
                self.runtimeLabel.text = R.String.MovieDetail.runtime(movie.runtime)
                self.releaseDateLabel.text = movie.release_date
                self.overviewLabel.text = movie.overview
                self.overviewLabel.isHidden = movie.overview == ""
                
                if movie.genres.count == 0 { return }
                var cnt = 0
                for genre in movie.genres {
                    if cnt == 6 { break }
                    guard let view = self.createTagView(id: genre.id) else { continue }
                    self.genreStack.addArrangedSubview(view)
                    cnt += 1
                }
                self.genreStack.addArrangedSubview(UIView())
            
            }
        }).disposed(by: disposeBag)
        
        guard let reactor = reactor else { return }
        stickeyView?.backButton.rx
            .tap.map{ .back }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
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
    
    var stickeyView: StickeyScrollView?
    
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
    
    lazy var genreStack = UIStackView().then {
        $0.spacing = 5
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        stickeyView = StickeyScrollView(contentView: contentStack)
        
        guard let stickeyView = stickeyView else { return }
        
        view.addSubview(stickeyView)
        
        contentStack.addArrangedSubviews([thumbNail,
                                          titleLabel,
                                          tagLabel,
                                          infoStack,
                                          genreStack,
                                          overviewLabel,
                                          UIView()])
        
        infoStack.addArrangedSubview(rateLabel)
        createDivider(infoStack)
        infoStack.addArrangedSubview(runtimeLabel)
        createDivider(infoStack)
        infoStack.addArrangedSubviews([releaseDateLabel, UIView()])
        
        stickeyView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.bottom.equalToSuperview()
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
