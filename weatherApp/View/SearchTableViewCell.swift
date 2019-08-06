//
//  SearchTableViewCell.swift
//  weatherApp
//
//  Created by 이혜주 on 03/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

protocol TouchButtonDelegate: class {
    func presentSearchController()
}

class SearchTableViewCell: UITableViewCell {

    weak var delegate: TouchButtonDelegate?
    
    lazy var addCityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Add"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(presentSearchViewController),
                         for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(addCityButton)
        
        addCityButton.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        addCityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        addCityButton.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -20).isActive = true
        addCityButton.widthAnchor.constraint(
            equalToConstant: 45).isActive = true
        addCityButton.heightAnchor.constraint(
            equalTo: addCityButton.widthAnchor).isActive = true
    }
    
    @objc private func presentSearchViewController() {
        delegate?.presentSearchController()
    }

}
