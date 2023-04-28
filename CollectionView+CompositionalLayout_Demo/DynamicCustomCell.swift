//
//  DynamicCustomCell.swift
//  CollectionView+CompositionalLayout_Demo
//
//  Created by JINSEOK on 2023/04/28.
//

import UIKit

protocol DynamicCustomCellDelegate: AnyObject {
    func showHideButtonTapped(_ cell: DynamicCustomCell, sender: UIButton)
}

class DynamicCustomCell: UICollectionViewCell {
    
    static let Identifier = "DynamicCustomCell"
    
    weak var delegate: DynamicCustomCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    lazy var showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showHideButtonHandler), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.contentView.backgroundColor = .lightGray
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(showHideButton)
        showHideButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showHideButtonHandler(_ sender: UIButton) {
        delegate?.showHideButtonTapped(self, sender: sender)
    }
}
