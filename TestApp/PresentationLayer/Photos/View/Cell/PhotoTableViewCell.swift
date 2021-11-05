//
//  PhotoTableViewCell.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 22.10.21.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    static let identifier = "PhotoTableViewCell"

    @IBOutlet private weak var photoImageView: UIImageView!
    
    private let placeholder = UIImage(named: "placeholder")

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.backgroundColor = .clear
        photoImageView.cancelLoad()
    }

    func set(photoModel: PhotoModel) {
        photoImageView.backgroundColor = photoModel.color.withAlphaComponent(0.6)
        photoImageView.setImage(url: photoModel.imageURL)
    }
}
