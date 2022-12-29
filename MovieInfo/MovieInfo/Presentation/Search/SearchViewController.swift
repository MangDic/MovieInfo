//
//  SearchViewController.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import ReactorKit

class SearchViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    var resultRelay = BehaviorRelay<[ResultMovie]>(value: [])
    
    init(reactor: SearchReactor) {
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
    }
    
    private func bind() {
        inputField.rx.text
            .subscribe(onNext: { [weak self] query in
                guard let `self` = self else { return }
                guard let query = query else { return }
                
                self.searchMovie(query: query)
            }).disposed(by: disposeBag)
        
        resultRelay
            .map { $0.count == 0 }.subscribe(onNext: { [weak self] flag in
                guard let `self` = self else { return }
                self.noDataLabel.text = self.inputField.text == "" ? "영화를 검색해 보세요!" : "앗, 검색된 영화가 없어요!"
                
                self.tableView.isHidden = flag
                self.noDataLabel.isHidden = !flag
            })
            .disposed(by: disposeBag)
        
//        resultRelay
//            .asDriver(onErrorJustReturn: [])
//            .drive(tableView.rx.items(cellIdentifier: SearchResultCell.id)) { row, item, cell in
//                guard let cell = cell as? SearchResultCell else { return }
//                
//                cell.configure(data: item)
//            }.disposed(by: disposeBag)
        
//        tableView.rx
//            .modelSelected(DetailMovie.self)
//            .subscribe(onNext: { [weak self] item in
//                guard let `self` = self else { return }
//                
//            }).disposed(by: disposeBag)
    }
    
    private func searchMovie(query: String) {
        NetworkService.getSearchList(query: query)
            .subscribe(onSuccess: { data in
                var arr = [ResultMovie]()
                if let results = data.results {
                    for result in results {
                        guard let result = result else { continue }
                        guard let _ = result.poster_path else { continue }
                        arr.append(result)
                    }
                }
                self.resultRelay.accept(arr)
            }).disposed(by: disposeBag)
    }
    
    lazy var noDataLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.isHidden = true
    }
    
    lazy var inputField = UITextField().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.addLeftInset(inset: 10)
    }
    
    lazy var tableView = UITableView().then {
        $0.register(SearchResultCell.self
                    , forCellReuseIdentifier: SearchResultCell.id)
        $0.backgroundColor = .black
        $0.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setupLayout() {
        view.addSubview(inputField)
        view.addSubview(tableView)
        view.addSubview(noDataLabel)
        
        inputField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(inputField.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        noDataLabel.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
    }
}

extension SearchViewController: View {
    func bind(reactor: SearchReactor) {
        inputField.rx.text
            .filter { $0 != nil }
            .map { query in .search(query: query!)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(ResultMovie.self)
            .map { $0.id }
            .map { id in .detail(id: id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { _ in reactor.currentState.movies }
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchResultCell.id,
                cellType: SearchResultCell.self)
            ) { index, item, cell in
                guard let item = item else { return }
                cell.configure(data: item)
            }
            .disposed(by: disposeBag)
    }
}
