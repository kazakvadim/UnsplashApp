//
//  ViewController.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 22.10.21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let viewModel = PhotosViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        downloadData()
    }

    private func downloadData() {
        viewModel.downloadData(completion: {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        })
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PhotoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PhotoTableViewCell.identifier)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier) as! PhotoTableViewCell
        let photoModel = viewModel.dataSource[indexPath.row]
        cell.set(photoModel: photoModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let hit = viewModel.dataSource[indexPath.row]
        return tableView.frame.width / (CGFloat(hit.width / hit.height))
    }
}
