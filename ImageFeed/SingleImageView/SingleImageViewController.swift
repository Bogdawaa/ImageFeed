//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 15.08.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var photo: Photo?
    
    private var image: UIImage?
    private let imageListService = ImageListService.shared
    
    @IBOutlet private var singleImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = photo else {return}
        setupImage(photo: photo)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        
        guard let image = image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = image else { return }
        
        let ac = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupImage(photo: Photo) {
        UIBlockingProgressHUD.show()
        let imageURL = URL(string: photo.largeImageURL)
        singleImageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать еще раз?",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "Не надо",
            style: .default,
            handler: nil)
        
        let tryAgainAction = UIAlertAction(
            title: "Повторить",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                if let photo = photo {
                    self.setupImage(photo: photo)
                }
            }
        alert.addAction(cancelAction)
        alert.addAction(tryAgainAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView
    }
}

