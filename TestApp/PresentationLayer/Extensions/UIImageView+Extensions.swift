//
//  UIImageView+Extensions.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 22.10.21.
//

import AlamofireImage

extension UIImageView {

    func setImage(url: URL?, placeHolder: UIImage?, completion: ((UIImage?) -> Void)? = nil) {
        af.cancelImageRequest()

        guard let url = url else {
            self.image = placeHolder
            completion?(self.image)
            return
        }

        af.setImage(withURL: url, placeholderImage: placeHolder, completion: { [weak self] result in
            if result.error != nil {
                self?.image = placeHolder
            }
            completion?(self?.image)
        })
    }
}
