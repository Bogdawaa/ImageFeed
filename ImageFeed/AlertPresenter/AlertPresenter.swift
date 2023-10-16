//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 09.10.2023.
//

import UIKit

class AlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(in presenter: UIViewController, alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
                alertModel.completion()
            }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
