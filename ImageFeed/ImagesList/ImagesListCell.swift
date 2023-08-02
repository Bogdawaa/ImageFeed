//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 01.08.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {
    static let reusedIdentifier = "ImagesListCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var favouritesImageView: UIImageView!
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.gradientView.bounds
        
        self.gradientView.layer.insertSublayer(gradientLayer, at:0)
        cardImageView.addSubview(gradientView)
    }
}
