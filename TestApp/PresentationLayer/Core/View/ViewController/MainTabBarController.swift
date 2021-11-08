//
//  MainTabBarController.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 7.11.21.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    enum TabItem: Int, CaseIterable {
        case photos

        var viewController: UIViewController {
            switch self {
            case .photos: return PhotosViewController()
            }
        }

        var image: UIImage? {
            switch self {
            case .photos: return UIImage(named: "photos")
            }
        }

        var title: String {
            switch self {
            case .photos: return "Photos"
            }
        }

        func createViewController() -> UIViewController {
            let viewController = self.viewController
            viewController.tabBarItem = UITabBarItem(title: title, image: image?.withRenderingMode(.alwaysOriginal), selectedImage: image)
            viewController.tabBarItem.tag = rawValue
            viewController.title = title
            return viewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        initializeViewControllers()
    }

    private func initializeViewControllers() {
        let viewControllers = TabItem.allCases.map {
            $0.createViewController()
        }
        setViewControllers(viewControllers, animated: false)
        selectedIndex = TabItem.photos.rawValue
    }
}
