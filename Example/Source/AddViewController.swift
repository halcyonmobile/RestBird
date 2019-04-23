//
//  AddViewController.swift
//  iOS Example
//
//  Created by Botond Magyarosi on 23/04/2019.
//  Copyright © 2019 Botond Magyarosi. All rights reserved.
//

import UIKit
import RestBird

class AddViewController: UIViewController {

    let apiClient = AppDelegate.apiClient
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addTouched(_ sender: UIButton) {
        var request = Request.Beer.Create()
        request.parameters = CreateBeerDTO(name: "Test", brewedBefore: Date())
        apiClient.execute(request: request) { (result: Result<Void>) in
            print(result)
        }
    }

    @IBAction func cancelTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
