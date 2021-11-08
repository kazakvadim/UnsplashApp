//
//  RootViewController.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 7.11.21.
//

import UIKit

class RootViewController: UIViewController {

    private var currentViewController: UIViewController

    init() {
        currentViewController = MainTabBarController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        setCurrentViewController()
    }

    private func setCurrentViewController() {
        addChild(currentViewController)
        currentViewController.view.frame = view.bounds
        view.addSubview(currentViewController.view)
        currentViewController.didMove(toParent: self)
    }
}
