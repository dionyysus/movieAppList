//
//  HomeViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 27.04.2023.
//

import UIKit

// movie api: https://api.themoviedb.org/3/discover/movie?api_key=d0cb5f9ae1c996d1bd22dc17e287debd

class HomeViewController: UIViewController, UITextFieldDelegate {

    private var movies = [Movie]()
    private var genres = [Genre]()
    
    var searching = false
    var filteredMovies = [Movie]() // Arama sonucu listesi
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    //@IBOutlet var favoriteMoviesCollectionView: UICollectionView!
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
        //searchTextField.delegate = self
  
        APIManager.shared.fetchMovies(url: APIManager.shared.apiURL) { (data: MovieResponse?) in
            self.movies = data!.results!
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
            //print("ggwp data \(data)")
        }
        APIManager.shared.fetchMovies(url: APIManager.shared.genreApiURL) { (data: GenreResponse?) in
            self.genres = data!.genres!
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
        }
       
    }
    
    @IBAction func searchHandler(_ sender: UITextField) {
        if let searchText = sender.text{
            filteredMovies = searchText.isEmpty ? movies : movies.filter {$0.title!.lowercased().contains(searchText.lowercased())}
            searching = true
        }
        if sender.text!.isEmpty {
            searching = false
        }
        moviesCollectionView.reloadData()
    }
    
}
extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == moviesCollectionView{
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            
            let gotoViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            let movie = movies[indexPath.row]
            gotoViewController.movieId = indexPath.row
            gotoViewController.prepare(movie: movie)
            navigationController?.pushViewController(gotoViewController, animated: true)

        }else if  collectionView == categoryCollectionView{
            
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == moviesCollectionView {
            if searching {
                return filteredMovies.count
            }else{
                return movies.count
            }
        } else if collectionView == categoryCollectionView {
            return genres.count
        } else {
            return 0
        }
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == moviesCollectionView {
            guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            if searching{
                cell.movieNameLabel.text = filteredMovies[indexPath.row].title
                cell.movieVoteLabel.text = String(filteredMovies[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = filteredMovies[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                cell.movieImageView.loadImg(url: imgFullPath!)
                filteredMovies[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}
                
            }else{
                cell.movieNameLabel.text = movies[indexPath.row].title
                cell.movieVoteLabel.text = String(movies[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = movies[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                cell.movieImageView.loadImg(url: imgFullPath!)
                
                var genreName = ""
                for genre in genres {
                    if ((movies[indexPath.row].genreIDS?.contains(genre.id!)) == true) {
                        genreName +=  genre.name ?? ""
                        genreName += ","
                    }
                }
                
                cell.movieCategoryNameLabel.text = genreName
                
//                let movieGenres = movie?.genreIDS?.compactMap { genreID in
//                    movies.first { $0.id == genreID}?.id
//                }
//                
//                for movie in movies{
//                    cell.movieCategoryNameLabel.text = movieGenres
//                }
//                if movies[indexPath.row].genreIDS!.contains(genres[indexPath.row].id!){
//                    cell.movieCategoryNameLabel.text = genres[indexPath.row].name
//                }
                
                movies[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}

                
            }
           
            return cell
        }

        else if collectionView == categoryCollectionView {
                    guard let catecoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                        return UICollectionViewCell()
                    }
            catecoryCell.categoryNameLabel.text = genres[indexPath.row].name
                    return catecoryCell
                }
        
        return UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

           if searchString.isEmpty {
               filteredMovies = movies
           } else {
               filteredMovies = (movies.filter { movie in
                   return (movie.title?.lowercased().contains(searchString.lowercased()))!
                   searching = true
               })
           }
           moviesCollectionView.reloadData()
           return true
       }
}

//extension ViewControllerA: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        /// Get the item selected at indexPath row
//        let movie = Movie.[indexPath.row]
//
//        /// Do something with the data @ indexPath.row that user has selected.
//
//        let vc = ViewControllerB()
//        vc.dataItem = i
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
