//
//  ViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 30.07.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var imageListServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter?
    
    private var photos: [Photo] = []
    private let ShowSingleImageSegueIdentifier = "ShowImage"
    private let photoName: [String] = Array(0..<20).map{ "\($0)" }
    private let imageListService = ImageListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(viewController: self)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        ImageListService.shared.fetchPhotosNextPage()
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController  = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.photo = photos[indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated() {
        let photosCount = photos.count
        let imageListServicePhotosCount = imageListService.photos.count
        photos = imageListService.photos
        if photosCount != imageListServicePhotosCount {
            tableView.performBatchUpdates {
                let indexPath = (photosCount..<imageListServicePhotosCount).map { item in
                    IndexPath(row: item, section: 0)
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reusedIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configCell(
            for: cell,
            with: indexPath,
            thumbURL: photos[indexPath.row].thumbimageURL,
            createdAt: photos[indexPath.row].createdAt
        )
        
        cell.setIsLike(photos[indexPath.row].isLiked)
        
        let imageURL = URL(string: photos[indexPath.row].thumbimageURL)
        cell.cardImageView.kf.indicatorType = .activity
        cell.cardImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "stub")) { _ in
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageWidth = photos[indexPath.row].size.width
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let ratio = imageViewWidth / imageWidth
        let height = photos[indexPath.row].size.height * ratio + imageInsets.top + imageInsets.bottom
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imageListService.photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = self.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    self.photos = self.imageListService.photos
                    cell.setIsLike(photo.isLiked)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    let alertModel = AlertModel(
                        title: "Ошибка",
                        message: "Возникла ошибка: \(error.localizedDescription)",
                        buttonText: "Ok") { return }
                    alertPresenter?.show(in: self, alertModel: alertModel)
                    break
                }
            }
    }
}
