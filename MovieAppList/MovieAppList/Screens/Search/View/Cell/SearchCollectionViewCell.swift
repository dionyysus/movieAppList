//
//  SearchCollectionViewCell.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 6.07.2023.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    static let identifier = "SearchCollectionViewCell"
    @IBOutlet weak var searchTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func searchButton(_ sender: Any) {
    }
    
}

