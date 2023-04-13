//
//  ViewController.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/11.
//

import UIKit
import SnapKit

enum Section: Int, CaseIterable {
    case main
    case grid3
    case grid6
}

class OneSectionViewController: UIViewController {
  
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
            
            return section
            
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
        OneSectionViewController()
            .toPreview()
    }
}
#endif


