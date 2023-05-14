//
//  HomeViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 27.04.2023.
//

import UIKit

// movie api: https://api.themoviedb.org/3/discover/movie?api_key=d0cb5f9ae1c996d1bd22dc17e287debd

class HomeViewController: UIViewController, UITextFieldDelegate{

    private var movies: [Movie]?
    private var genres: [Genre]?
    
    //var baseApiURL = "https://api.themoviedb.org/3/"
    var apiURL = "https://api.themoviedb.org/3/discover/movie?api_key=d0cb5f9ae1c996d1bd22dc17e287debd"
    var genreApiURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=d0cb5f9ae1c996d1bd22dc17e287debd"
    let imgUrl = "http://image.tmdb.org/t/p/w500"
   

    var filteredMovies = [Movie]() // Arama sonucu listesi
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet var favoriteMoviesCollectionView: UICollectionView!
    @IBOutlet var searchTextField: UITextField!

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        let nib = UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil)
        moviesCollectionView.register(nib, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        searchTextField.delegate = self
        

//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 5
//        categoryCollectionView.setCollectionViewLayout(layout, animated: true)
        
        APIManager.shared.fetchMovies(url: apiURL) { (data: MovieResponse?) in
            self.movies = data?.results
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
            //print("ggwp data \(data)")
        }
        APIManager.shared.fetchMovies(url: genreApiURL) { (data: GenreResponse?) in
            self.genres = data?.genres
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
            //print("ggwp data \(data)")
        }
    }
}

extension HomeViewController: UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == moviesCollectionView {
            return movies?.count ?? 00
        } else if collectionView == categoryCollectionView {
            return genres?.count ?? 00
        } else {
            return 0
        }
        
        /*if searchTextField.text!.isEmpty {
            return movies?.count ?? 00
        }
        return filteredMovies.count*/
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == moviesCollectionView {
            guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.movieNameLabel.text = movies?[indexPath.row].title
            cell.movieVoteLabel.text = String(movies?[indexPath.row].voteAverage ?? 0.0)

            let imgPosterPath = movies?[indexPath.row].posterPath ?? ""
            let imgFullPath = URL(string: "\(imgUrl + imgPosterPath)")

            cell.movieImageView.loadImg(url: imgFullPath!)
          
            movies?[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}
          
            return cell
            
        }

        else if collectionView == categoryCollectionView {
                    guard let catecoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                        return UICollectionViewCell()
                    }
            catecoryCell.categoryNameLabel.text = genres?[indexPath.row].name
                    return catecoryCell
                }
        
        return UICollectionViewCell()
        
        
//        if searchTextField.text!.isEmpty {
//            
//            if collectionView == moviesCollectionView {
//                guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else {
//                    return UICollectionViewCell()
//                }
//                cell.movieNameLabel.text = movies?[indexPath.row].title
//                cell.movieVoteLabel.text = String(movies?[indexPath.row].voteAverage ?? 0.0)
//
//                let imgPosterPath = movies?[indexPath.row].posterPath ?? ""
//                let imgFullPath = URL(string: "\(imgUrl + imgPosterPath)")
//
//                cell.movieImageView.loadImg(url: imgFullPath!)
//              
//                movies?[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}
//              
//                return cell
//                
//            }
//
//            else if collectionView == categoryCollectionView {
//                        guard let catecoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
//                            return UICollectionViewCell()
//                        }
//                catecoryCell.categoryNameLabel.text = genres?[indexPath.row].name
//                        return catecoryCell
//                    }
//            
//            return UICollectionViewCell()
//        } else {
//            if collectionView == moviesCollectionView {
//                guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else {
//                    return UICollectionViewCell()
//                }
//                cell.movieNameLabel.text = filteredMovies[indexPath.row].title
//                cell.movieVoteLabel.text = String(filteredMovies[indexPath.row].voteAverage ?? 0.0)
//                
//                let imgPosterPath = filteredMovies[indexPath.row].posterPath ?? ""
//                let imgFullPath = URL(string: "\(imgUrl + imgPosterPath)")
//                
//                cell.movieImageView.loadImg(url: imgFullPath!)
//                
//                cell.movieCategoryNameLabel.text = "\(filteredMovies[indexPath.row].genreIDS)"
//  
//                return cell
//                
//                    }
//            
//            else if collectionView == categoryCollectionView {
//                        guard let catecoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
//                            return UICollectionViewCell()
//                        }
//                
//                catecoryCell.categoryNameLabel.text = "\(genres?[indexPath.row].name)"
//                
//                        return catecoryCell
//                    }
//            return UICollectionViewCell()
//        }
//        
        
    }
}
extension HomeViewController: UICollectionViewDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
           if searchString.isEmpty {
               filteredMovies = movies!
           } else {
               filteredMovies = (movies?.filter { movie in
                   return (movie.title?.lowercased().contains(searchString.lowercased()))!
               })!
           }
           moviesCollectionView.reloadData()
           return true
       }
}

//extension HomeViewController: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing
//        return CGSize(width:widthPerItem, height:100)
//    }
//}
