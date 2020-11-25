//
//  HomeViewController.swift
//  iOSArchitectureMVC
//
//  Created by Juan Pablo on 25/11/2020.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: to test
        let request = PopularMoviesRequest()
        request.performRequest {
            request.performResponse { response in
                print(response.results?.count ?? 0 > 0 ? "success" : "error")
            }
        }
    }
}
