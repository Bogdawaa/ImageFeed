//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 01.08.2023.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

class ImagesListCell: UITableViewCell {
    
    static let reusedIdentifier = "imagesListCell"
    
    weak var delegate: ImageListCellDelegate?
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var likeButton: UIButton!
    
    private var isGradientSet = false
    private let dateFormatter = ImageFeedDateFormatter.shared
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardImageView.kf.cancelDownloadTask()
    }
    
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
    
    func configCell(for cell: ImagesListCell, with index: IndexPath, thumbURL: String, createdAt: Date?) {
        if isGradientSet == false {
            cell.setGradientBackground()
            isGradientSet = true
        }
        cell.cardImageView.backgroundColor = .ypWhite.withAlphaComponent(0.5)
        cell.likeButton.setTitle("", for: .normal)
        
        if let createdAt = createdAt {
            cell.dateLabel.text = dateFormatter.dateString(from: createdAt)
        } else {
            cell.dateLabel.text = ""
        }
    }
    
    func setIsLike(_ isFavourite: Bool) {
        let favouriteImage = isFavourite ? UIImage(named: "active") : UIImage(named: "noActive")
        likeButton.setImage(favouriteImage, for: .normal)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
