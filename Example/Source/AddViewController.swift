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
        let data = CreateBeerDTO(name: "Test", brewedBefore: Date())
        let imageData = Data(repeating: 1, count: 1024)
        var request = Request.Beer.Create(parameters: data, parts: [Multipart.data(data: imageData, name: "image", fileName: "image.jpg", mimeType: "image/jpeg")])
        apiClient.execute(request: request, uploadProgress: nil) { (result: Result<EmptyResponse, Error>) in
            print(result)
        }
    }

    @IBAction func cancelTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
