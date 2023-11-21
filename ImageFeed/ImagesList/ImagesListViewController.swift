//
//  ViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 30.07.2023.
//

import UIKit
import Kingfisher

protocol ImageListViewProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func presentPhotos(photos: [Photo])
    func updateRow(indexPath: IndexPath)
    func updateTableViewAnimated(indexes: Range<Int>)
    func showAlert(alertModel: AlertModel)
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController & ImageListViewProtocol {
    
    // MARK: - public
    var alertPresenter: AlertPresenter?
    var presenter: ImageListPresenterProtocol?
    
    
    // MARK: - private
    private var imageListServiceObserver: NSObjectProtocol?
    private let ShowSingleImageSegueIdentifier = "singleImage"
    private let imageListService = ImageListService.shared
    private var photos = [Photo]()
    private var isTableInit = false
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reusedIdentifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .ypBlack
        return table
    }()
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // alert
        alertPresenter = AlertPresenter(viewController: self)
        
        // presenter
        presenter?.didLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == ShowSingleImageSegueIdentifier,
            let viewController  = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath else {
                super.prepare(for: segue, sender: sender)
                return
        }
        viewController.photo = photos[indexPath.row]
    }
    
    // MARK: - public methods
    func presentPhotos(photos: [Photo]) {
        self.photos = photos
    }
    
    func updateRow(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showAlert(alertModel: AlertModel) {
        alertPresenter?.show(in: self, alertModel: alertModel)
    }
    
    func updateTableViewAnimated(indexes: Range<Int>) {
        if !isTableInit { return }
        tableView.performBatchUpdates {
            let indexPath = indexes.map { item in
                IndexPath(row: item, section: 0)
            }
            tableView.insertRows(at: indexPath, with: .automatic)
        } completion: { _ in }
    }
}

// MARK: - table delegate
extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTableInit = true
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
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: ShowSingleImageSegueIdentifier) as! SingleImageViewController
        viewController.photo = photos[indexPath.row]
        self.present(viewController, animated: true)
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
        if indexPath.row + 1 == presenter?.photosInStorageCount {
            presenter?.fetchPhotosNextPage()
        }
    }
}
// MARK: - cell delegate
extension ImagesListViewController: ImageListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = self.photos[indexPath.row]
        
        presenter?.setIndex(indexPath: indexPath)
        presenter?.setPhoto(photo: photo)
        presenter?.imageListCellDidTapLike(cell)
    }

}
