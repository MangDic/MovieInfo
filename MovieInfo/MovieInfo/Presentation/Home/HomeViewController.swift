//
//  HomeViewController.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Kingfisher
import ReactorKit

class HomeViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    var currentPage = 1
    let loadTrigger = PublishRelay<Void>()
    
    let movieRelay = BehaviorRelay<[Movie]>(value: [])
    let isScrollingRelay = BehaviorRelay<Bool>(value: false)
    
    let flowLayout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.id)
    }
    
    init(reactor: HomeReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        loadTrigger.accept(())
    }
    
    private func setupLayout() {
        view.backgroundColor = .lightGray
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = collectionView.frame.height / 3
        
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("End")
    }
}

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: HomeReactor) {
        loadTrigger
            .map { .load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset.withUnretained(self)
            .filter { $0.0.collectionView.isNearBottomEdge() }
            .map { _ in HomeReactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(Movie.self)
            .map { Reactor.Action.detail(movie: $0) }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
        reactor.state
            .compactMap { $0.movies }
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCell.id)) { row, item, cell in
                guard let cell = cell as? MovieCell else { return }
                
                cell.configure(data: item)
            }.disposed(by: disposeBag)
    }
}
