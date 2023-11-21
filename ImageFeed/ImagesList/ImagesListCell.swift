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
    
    private var isGradientSet = false
    private let dateFormatter = ImageFeedDateFormatter.shared
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.text = "fasfo"
        label.font = UIFont(name: "YS Regular", size: 13)
        return label
    }()
    
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let gradientView: UIView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 9_999_999_999_999, height: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 30)
        ])

        let bottomImageGradient = CAGradientLayer()
        let colorTop =  UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 0.2).cgColor
        bottomImageGradient.frame = view.bounds
        bottomImageGradient.colors = [colorTop, colorBottom]
        bottomImageGradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(bottomImageGradient, at: 0)
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.text = ""
        btn.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        btn.accessibilityIdentifier = "likeButton"
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .ypBlack
        contentView.addSubview(cardImageView)
        cardImageView.addSubview(gradientView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardImageView.kf.cancelDownloadTask()
    }
    
    func configCell(for cell: ImagesListCell, with index: IndexPath, thumbURL: String, createdAt: Date?) {
        cell.cardImageView.backgroundColor = .ypWhite.withAlphaComponent(0.5)
        cell.likeButton.setTitle("", for: .normal)
        cell.likeButton.isEnabled = true
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
    
    private func applyConstraints() {
        let cardImageViewConstraints = [
            cardImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            cardImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            cardImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ]
        let gradientViewConstraints = [
            gradientView.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor)
        ]
        let dateLabelConstraints = [
            dateLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: -8)
        ]
        let likeButtonConstraints = [
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cardImageView.topAnchor)
        ]
        NSLayoutConstraint.activate(cardImageViewConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(gradientViewConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
