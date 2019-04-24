//
//  IndexCell.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import UIKit

class IndexCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            //imageView.layer.borderWidth = isSelected ? 10 : 0
        }
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //imageView.layer.borderColor = themeColor.cgColor
        isSelected = false
        
        flagImageView.isHidden = true
    }
    
    
    func bind(_ info: TheMovie) {
        
        if let p = info.poster_path, let url = URL(string: imgUrl + p) {
            imageView.kf.setImage(with: url)
        }

        nameLabel.text = info.title
        

    }
    
}
