//
//  DynamicViewController.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/28.
//

import UIKit

class DynamicViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.showsHorizontalScrollIndicator = false
        view.register(DynamicCustomCell.self, forCellWithReuseIdentifier: DynamicCustomCell.Identifier)
        view.dataSource = self
        return view
    }()

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Configurations
   
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(100))
        let itme = NSCollectionLayoutItem(layoutSize: itemSize)
        // estimated를 사용하게 되면 contentInsets으로 조절하면 값이 무시가 됩니다.
        itme.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(20), trailing: nil, bottom: nil)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [itme])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

extension DynamicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicCustomCell.Identifier, for: indexPath) as? DynamicCustomCell else {
            fatalError("Faild to load CustomCell")
        }
        
        cell.delegate = self
        
        let text = "엄청 긴 글 \n엄청 긴 글 \n엄청 긴 글 \n엄청 긴 글 \n엄청 긴 글 \n엄청 긴 글 \n엄청 긴 글 \n엄청 긴 글 \n엄청 긴 글 \n마지막"
        
        cell.titleLabel.text = text
        
        return cell
    }
}

extension DynamicViewController: DynamicCustomCellDelegate {
    func showHideButtonTapped(_ cell: DynamicCustomCell, sender: UIButton) {
        switch sender.currentTitle {
        case "더보기":
            sender.setTitle("숨기기", for: .normal)
            cell.titleLabel.numberOfLines = 0
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        case "숨기기":
            sender.setTitle("더보기", for: .normal)
            cell.titleLabel.numberOfLines = 3
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        default: break
        }
    }
}



// MARK: - PreView 읽기
import SwiftUI

#if DEBUG
struct PreView4: PreviewProvider {
    static var previews: some View {
        // 사용할 뷰 컨트롤러를 넣어주세요
        DynamicViewController()
            .toPreview()
    }
}
#endif

