//
//  ViewController.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/11.
//

import UIKit
import SnapKit

enum Section: Int, CaseIterable {
    case grid3
    case grid6
}

class ViewController: UIViewController {
  
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.showsHorizontalScrollIndicator = false
        view.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.Identifier)
        view.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.Identifier)
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
        
        // 👉 dataSource에서 Header, Footere들을 만들어 줍니다.
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.Identifier, for: indexPath) as? CustomHeaderView
            
            header?.setupTitle(text: "Section \(indexPath.section)")
            return header
        }
        
        
        
        // dataSource를 구성하기 위해 Snapshot으로 섹션 및 아이템의 정보를 업데이트
        var snapShot = NSDiffableDataSourceSnapshot<Section, Int>()
        Section.allCases.forEach {
            snapShot.appendSections([$0])
            switch $0 {
            case .grid3:
                snapShot.appendItems(Array(1...12))
            case .grid6:
                snapShot.appendItems(Array(13...24))
            }
        }
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // CompositionalLayout(sectionProvider:)
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) in
            
            // 👉 Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            )
            let header =  NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            // section에 따라 레이아웃 그리기 (첫 번째 section)
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            if section == .grid3 {
                // item
                let itmeSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itmeSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                // group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/7)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                
                return section
                
            // 두 번째 section
            } else {
                
                // item
                let itmeSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/6),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itmeSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                // group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/5)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
    
        return layout
    }
    
}




import SwiftUI

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif


// MARK: - PreView 읽기
import SwiftUI

#if DEBUG
struct PreView: PreviewProvider {
    static var previews: some View {
        // 사용할 뷰 컨트롤러를 넣어주세요
        ViewController()
            .toPreview()
    }
}
#endif


