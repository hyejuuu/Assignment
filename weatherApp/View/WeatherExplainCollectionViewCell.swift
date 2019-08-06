//
//  WeatherExplainCollectionViewCell.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class WeatherExplainCollectionViewCell: UICollectionViewCell {
    let explainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "오늘: 현재날씨 어쩌구. 현재 기온은 29도이며 오늘 예상 최고 기온은 34도입니당."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(explainLabel)
        
        explainLabel.topAnchor.constraint(
            equalTo: topAnchor,
            constant: 15).isActive = true
        explainLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: 15).isActive = true
        explainLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -15).isActive = true
        explainLabel.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
