//
//  CustomCell.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/11.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    static let Identifier = "CustomCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        // 랜덤으로 배경색 지정
        self.contentView.backgroundColor = UIColor(
            red: drand48(),
            green: drand48(),
            blue: drand48(),
            alpha: drand48()
        )
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
