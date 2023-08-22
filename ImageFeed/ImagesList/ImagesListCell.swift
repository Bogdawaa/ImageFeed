//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 01.08.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {
    
    static let reusedIdentifier = "ImagesListCell"
    private var isGradientSet = false
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cardImageView: UIImageView!  
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var favouritesButton: UIButton!
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 0.2).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.gradientView.bounds
        
        self.gradientView.layer.insertSublayer(gradientLayer, at:0)
        cardImageView.addSubview(gradientView)
    }
    
    func configCell(for cell: ImagesListCell, with index: IndexPath, photoName: String) {
        guard let image = UIImage(named: photoName) else {
            return
        }
        if isGradientSet == false {
            cell.setGradientBackground()
            isGradientSet = true
        }
        cell.cardImageView.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isFavourite = index.row % 2 == 0
        let favouriteImage = isFavourite ? UIImage(named: "noActive") : UIImage(named: "active")
        
        cell.favouritesButton.setImage(favouriteImage, for: .normal)
        cell.favouritesButton.setTitle("", for: .normal)
    }
}
