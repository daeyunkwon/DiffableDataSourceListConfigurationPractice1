//
//  SecondViewController.swift
//  DiffableDataSourceListConfigurationPractice1
//
//  Created by 권대윤 on 7/20/24.
//

import UIKit

import SnapKit

struct User: Identifiable, Hashable {
    let id = UUID().uuidString
    let username: String
    let message: String
    let date: String
    let imageName: String
}

final class SecondViewController: UIViewController {
    
    //MARK: - Properties
    
    enum Section: CaseIterable {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    
    let users: [User] = [
        User(username: "Hue", message: "왜요? 요즘 코딩이 대세인데", date: "24.01.12", imageName: "Hue"),
        User(username: "Jack", message: "깃허브는 푸시하셨나요?", date: "24.01.12", imageName: "Jack"),
        User(username: "Bran", message: "과제 화이팅!", date: "24.01.11", imageName: "Bran"),
        User(username: "Den", message: "벌써 퇴근하세요?ㅎㅎㅎㅎ", date: "24.01.10", imageName: "Den"),
        User(username: "내옆의앞자리에개발잘하는친구", message: "내일 모닝콜 해주실분~~", date: "24.01.09", imageName: "내옆자리의앞자리에개발잘하는친구"),
        User(username: "심심이", message: "아닛 주말과제라닛", date: "24.01.08", imageName: "심심이"),
    ]
    
    //MARK: - UI Components
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "친구 이름을 검색해보세요"
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: listConfig)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    //MARK: - Configurations
    
    private func configureDataSource() {
        var registration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
        
        registration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.cell()
            
            //이미지
            content.image = UIImage(named: itemIdentifier.imageName)
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            content.imageProperties.reservedLayoutSize = .init(width: 50, height: 50)
            content.imageProperties.cornerRadius = (content.image?.size.height ?? 0) / 2
            content.imageToTextPadding = 10
            
            //텍스트
            content.text = itemIdentifier.username
            content.textProperties.font = .boldSystemFont(ofSize: 15)
            content.secondaryText = itemIdentifier.message
            content.secondaryTextProperties.color = .darkGray
            content.textToSecondaryTextVerticalPadding = 10
            content.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            cell.contentConfiguration = content
            
            //액세사리
            var labelOption = UICellAccessory.LabelOptions()
            labelOption.font = .systemFont(ofSize: 12)
            cell.accessories = [.label(text: itemIdentifier.date, options: labelOption)]
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(self.users, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    private func setupNavi() {
        navigationItem.title = "TRAVEL TALK"
    }
    
    private func configureLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0.2)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
}