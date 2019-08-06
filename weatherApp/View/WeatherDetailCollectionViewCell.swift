//
//  WeatherDetailCollectionViewCell.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class WeatherDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var firstTitleLabel: UILabel!
    
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    @IBOutlet weak var firstValueLabel: UILabel!
    
    @IBOutlet weak var secondValueLabel: UILabel!
    
    var titleString: [String]? {
        didSet {
            guard let titleString = self.titleString else {
                return
            }
            
            firstTitleLabel.text = titleString[0]
            secondTitleLabel.text = titleString[1]
        }
    }
    
    var valueString: [String]? {
        didSet {
            guard let valueString = self.valueString else {
                return
            }
            
            firstValueLabel.text = valueString[0]
            secondValueLabel.text = valueString[1]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
