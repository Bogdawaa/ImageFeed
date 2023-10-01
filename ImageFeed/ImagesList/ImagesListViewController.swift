//
//  ViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 30.07.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let ShowSingleImageSegueIdentifier = "ShowImage"
    private let photoName: [String] = Array(0..<20).map{ "\($0)" }
    private var imageListService: ImageListService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController  = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photoName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reusedIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.configCell(for: cell, with: indexPath, photoName: photoName[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageListService = ImageListService()
        guard let imageListService = imageListService else { return }
        if indexPath.row + 1 == imageListService.photos.count {
            imageListService.fetchPhotosNextPage { [weak self] result in
                guard let self = self else { return }
                //
            }
        }
    }
}
