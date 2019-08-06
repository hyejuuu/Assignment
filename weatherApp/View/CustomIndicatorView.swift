//
//  CustomIndicatorView.swift
//  weatherApp
//
//  Created by 이혜주 on 06/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class CustomIndicatorView: UIView {

    private lazy var indicator: UIActivityIndicatorView = {
        let activityIndicator
            = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: 40,
                                                    height: 40))
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        activityIndicator.backgroundColor = .white
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .white
        addSubview(indicator)
        
        indicator.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        indicator.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        indicator.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        indicator.bottomAnchor.constraint(
            equalTo: bottomAnchor).isActive = true
        
    }

    func indicatorStartAnimating() {
        indicator.startAnimating()
        isHidden = false
    }
    
    func indicatorStopAnimating() {
        indicator.stopAnimating()
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
