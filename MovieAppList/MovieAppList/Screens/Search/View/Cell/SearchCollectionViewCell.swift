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
extension UIImageView {
    func loadImgTwo(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
