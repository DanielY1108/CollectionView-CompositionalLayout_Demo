//
//  CustomHeaderView.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/12.
//

import UIKit

class CustomHeaderView: UICollectionReusableView {
    
    static let Identifier = "Header"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupTitle(text: "")
    }
    
    func setupTitle(text: String) {
        titleLabel.text = text
    }
}
