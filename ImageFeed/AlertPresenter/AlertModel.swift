//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 09.10.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
