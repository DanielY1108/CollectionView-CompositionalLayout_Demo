//
//  NestedItemController.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/13.
//

import UIKit

class NestedItemController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.showsHorizontalScrollIndicator = false
        view.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.Identifier)
        return view
    }()
    
    // dataSource 대신 DiffableDataSource로 직접 만들어 줬습니다.
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        configureDataSource()
    }
    
    // MARK: - Configurations
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.Identifier, for: indexPath) as? CustomCell else {
                fatalError("Faild to load CustomCell")
            }
            
            cell.setupTitle(text: "\(itemIdentifier)")
            return cell
        }
        
        // dataSource를 구성하기 위해 Snapshot으로 섹션 및 아이템의 정보를 업데이트
        var snapShot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapShot.appendSections([Section.main])
        snapShot.appendItems(Array(1...24))
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // CompositionalLayout(sectionProvider:)
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) in
            
            // 1번 Item
            let topItme = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1/2)))  // 절반 높이
            topItme.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10)
            
            // 2번 Item
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),   // 2/3 크기의 너비
                                                   heightDimension: .fractionalHeight(1)))  // 나중에 horizontalGroup에서 크기를 설정해줌
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 5)
            
            // 3 Item
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),       // 나중에 trailingGroup에서 너비를 설정
                                                   heightDimension: .fractionalHeight(1/3)))  //  1/3 높이
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 10)
            
            // 3 Item을 수직방향 Group을 통해 3번 반복하여 3, 4, 5 Item을 만들어준다.
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),   // trailingItem들은 1/3 너비
                                                   heightDimension: .fractionalHeight(1)),
                repeatingSubitem: trailingItem, count: 3)
            
            // 2 Item + (3, 4, 5) Item을 수평방향 Group으로 묶어준다.
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1/2)),  // 2번 item 및 trailingGroup은 절반 높이
                subitems: [leadingItem, trailingGroup]
            )
            
            // 1 Item 과 마지막에 묶은 Group(2, 3, 4, 5 Itme)을 수직방향 Group으로 묶어 준다.
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.5)),
                subitems: [topItme, horizontalGroup]
            )
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            return section
            
        }
        
        return layout
    }
    
    
}


// MARK: - PreView 읽기
import SwiftUI

#if DEBUG
struct PreView3: PreviewProvider {
    static var previews: some View {
        // 사용할 뷰 컨트롤러를 넣어주세요
        NestedItemController()
            .toPreview()
    }
}
#endif
