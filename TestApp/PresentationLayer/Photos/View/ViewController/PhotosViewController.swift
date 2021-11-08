//
//  PhotosViewController.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 7.11.21.
//

import Alamofire
import Combine
import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = PhotosViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        subscribeToNotifications()
        viewModel.downloadData()
    }

    private func subscribeToNotifications() {
        viewModel.contentChangesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PhotoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PhotoTableViewCell.identifier)
    }

    private func calculateHeight(for indexPath: IndexPath) -> CGFloat {
        let viewWidth = Float(tableView.frame.width)
        let height = CGFloat(viewModel.calculateHeight(for: indexPath.row, with: viewWidth))
        return height
    }
}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier) as! PhotoTableViewCell
        let photoModel = viewModel.dataSource[indexPath.row]
        cell.set(photoModel: photoModel)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.dataSource.count - 1 {
            viewModel.downloadNextItems()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        calculateHeight(for: indexPath)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        calculateHeight(for: indexPath)
    }
}
