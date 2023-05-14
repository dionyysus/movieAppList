//
//  DetailViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 28.04.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieDetailImageView: UIImageView!
    @IBOutlet weak var movieDetailNameLabel: UILabel!
    @IBOutlet weak var movieDetailCategoryLabel: UILabel!
    @IBOutlet weak var movieDetailDescriptionLabel: UILabel!
    @IBOutlet weak var movieVoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

