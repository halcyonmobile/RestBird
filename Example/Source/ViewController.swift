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

    let apiClient = NetworkClient(configuration: MainAPIConfiguration())

    var beers: [Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.register(RequestLoggerMiddleware())

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadBeers()
    }

    private func loadBeers() {
        let request = Request.Beer.GetAll()
        apiClient.execute(request: request) { (result: Result<[Beer]>) in
            switch result {
            case .success(let data):
                self.beers = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
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
