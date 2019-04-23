//
//  ViewController.swift
//  iOS Example
//
//  Created by Botond Magyarosi on 09/10/2018.
//  Copyright © 2018 Botond Magyarosi. All rights reserved.
//

import UIKit
import RestBird

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let apiClient = AppDelegate.apiClient

    var beers: [Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadBeers()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func loadBeers() {
        var request = Request.Beer.GetAll()
        request.parameters = FilterBeerDTO(brewedBefore: Date())
        apiClient.execute(request: request) { result in
            switch result {
            case .success(let data):
                self.beers = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc private func refresh() {
        tableView.refreshControl?.endRefreshing()
        loadBeers()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = beers[indexPath.row].name
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
