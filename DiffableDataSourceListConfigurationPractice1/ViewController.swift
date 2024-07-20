//
//  ViewController.swift
//  DiffableDataSourceListConfigurationPractice1
//
//  Created by 권대윤 on 7/19/24.
//

import UIKit

import SnapKit

final class ViewController: UIViewController {
    
    //MARK: - Properties
    
    enum Section: CaseIterable {
        case general
        case personal
        case other
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! //섹션 타입, 데이터 타입
    
    let list: [[String]] = [
        ["전체 설정", "공지사항", "실험실", "버전 정보"],
        ["개인 설정", "개인/보안", "알림", "채팅", "멀티프로필"],
        ["기타", "고객센터/도움말"],
    ]
    
    //MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfig.headerMode = .firstItemInSection
        listConfig.backgroundColor = .clear
        listConfig.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: listConfig)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        updateSnapshot()
        configureLayout()
        configureUI()
    }
    
    //MARK: - Configurations
    
    private func configureDataSource() {
        //register Cell
        var registration: UICollectionView.CellRegistration<UICollectionViewListCell, String>! //셀 타입, 데이터 타입
        registration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            if indexPath.row == 0 {
                //Header
                content.textProperties.font = .systemFont(ofSize: 16)
                content.textProperties.color = .systemGray
            } else {
                //Body
                content.textProperties.font = .systemFont(ofSize: 13)
            }
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .clear
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.general, .personal, .other])
        snapshot.appendItems(list[0], toSection: .general)
        snapshot.appendItems(list[1], toSection: .personal)
        snapshot.appendItems(list[2], toSection: .other)
        dataSource.apply(snapshot)
    }
    
    private func setupNavi() {
        navigationItem.title = "설정"
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
}

