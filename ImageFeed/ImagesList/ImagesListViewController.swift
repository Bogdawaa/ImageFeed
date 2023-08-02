//
//  ViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 30.07.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    
    private let photoName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func configCell(for cell: ImagesListCell, with index: IndexPath) {
        guard let image = UIImage(named: photoName[index.row]) else {
            return
        }
        cell.setGradientBackground()
        cell.cardImageView.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isFavourite = index.row % 2 == 0
        let favouriteImage = isFavourite ? UIImage(named: "noActive") : UIImage(named: "active")
        
        cell.favouritesButton.setImage(favouriteImage, for: .normal)
        cell.favouritesButton.setTitle("", for: .normal)
    }
}

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reusedIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photoName[indexPath.row]) else {
            return 0
        }
        let imageWidth = image.size.width
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let ratio = imageViewWidth / imageWidth
        let height = image.size.height * ratio + imageInsets.top + imageInsets.bottom
        return height
    }
}
