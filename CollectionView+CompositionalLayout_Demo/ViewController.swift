//
//  ViewController.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/11.
//

import UIKit
import SnapKit

enum Section: CaseIterable {
    case main
}

class ViewController: UIViewController {
    
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
        
        let numberOfRows = 1.0 / 4.0       // 행의 갯수
        let numberOfColumns = 1.0 / 6.0    // 열의 갯수
        let itemInset: CGFloat = 5.0
        
        // CompositionalLayout(sectionProvider:)
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            // item
            let itmeSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(numberOfRows),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itmeSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
            
            // group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(numberOfColumns)
            )
            // 정렬할 방향으로 그룹을 만들 수 있습니다. (horizontal, vertical)
            // nested 모양을 만들 때 horizontal, vertical를 조합해 subitems에 추가해서 사용하면 됩니다.
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            // 이렇게 직접 행의 갯수로 지정도 가능하지만 복잡합니다. (다만 값에 따라 셀이 화면에서 벗어날 수 있습니다.)
            // 이건 아마도 한 행 또는 한 열로 구성된 콜렉션뷰를 구현할 때 편하게 사용될 것 같습니다.
            // let group = NSCollectionLayoutGroup.horizontal(
            //     layoutSize: groupSize,
            //     repeatingSubitem: item,
            //     count: colunm
            // )
            
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            
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
        ViewController()
            .toPreview()
    }
}
#endif
