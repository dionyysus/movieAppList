//
//  SearchViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 7.07.2023.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate{


    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibSearch = UINib(nibName: SearchCollectionViewCell.identifier, bundle: nil)
        searchCollectionView.register(nibSearch, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)

        let nibMovie = UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil)
        movieCollectionView.register(nibMovie, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self

    }
    
}

extension SearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        return cell
        
    }
}
