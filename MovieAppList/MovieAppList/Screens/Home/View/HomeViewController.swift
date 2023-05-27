//
//  HomeViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 27.04.2023.
//

import UIKit


class HomeViewController: UIViewController, UITextFieldDelegate {

    private var movies = [Movie]()
    //private var viewMovies = [Movie]()
    private var genres = [Genre]()
    
    var searching = false
    var filteredMovies = [Movie]() // Arama sonucu listesi
    
    var isFiltered = true
    var categoryMovies = [Movie]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
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
  
        APIManager.shared.fetchMovies(url: APIManager.shared.apiURL) { (data: MovieResponse?) in
            self.movies = data!.results!
            //self.viewMovies = data!.results!
            self.categoryMovies = data!.results!
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
                //self.viewMovies = self.movies.filter {($0.genreIDS?.first ?? 0) == (self.genres.first?.id ?? 0)}
            }
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
    
    @objc func labelTapped() {
        print("category lapel tapped")
    }

//    func labelClicked(indexPath: IndexPath) {
//            let selectedCategory = genres[indexPath.row]
//            let filteredMovies = movies.filter { movie in
//                return movie.genreIDS?.contains(selectedCategory.id ?? 0) ?? false
//            }
//
//            updateCollectionView(with: filteredMovies)
//        }
//    func updateCollectionView(with movies: [Movie]) {
//        self.filteredMovies = movies
//        moviesCollectionView.reloadData()
//    }
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
            }else if isFiltered {
                return categoryMovies.count
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
                
            }else if isFiltered{
                cell.movieNameLabel.text = categoryMovies[indexPath.row].title
                cell.movieVoteLabel.text = String(categoryMovies[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = categoryMovies[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                cell.movieImageView.loadImg(url: imgFullPath!)
                
                var genreName = ""
                for genre in genres {
                    if ((categoryMovies[indexPath.row].genreIDS?.contains(genre.id!)) == true) {
                        genreName +=  genre.name ?? ""
                        genreName += ","
                    }
                }
                cell.movieCategoryNameLabel.text = genreName
                movies[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}
                
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
                movies[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}
            }

            return cell
        }

        else if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            categoryCell.categoryNameLabel.text = genres[indexPath.row].name

            categoryCell.delegate = self
            categoryCell.indexPath = indexPath
            return categoryCell
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
extension HomeViewController: CategoriesCellDelegate{
    
    func labelClicked(indexPath: IndexPath) {
   
        categoryMovies = movies.filter{ $0.genreIDS?.contains(genres[indexPath.row].id ?? 0) ?? false }
        moviesCollectionView.reloadData()
        
        
//         let selectedCategory = genres[indexPath.row]
//        let filteredMovies = movies.filter { movie in
//            return movie.genreIDS?.contains(genres[indexPath.row].id ?? 0) ?? false }
//        updateCollectionView(with: filteredMovies)
        
    }
//    func updateCollectionView(with movies: [Movie]) {
//
//            filteredMovies = movies
//            moviesCollectionView.reloadData()
//    }
       
}

//    func labelClicked(indexPath: IndexPath) {
//            let selectedCategory = genres[indexPath.row]
//            let filteredMovies = movies.filter { movie in
//                return movie.genreIDS?.contains(selectedCategory.id ?? 0) ?? false
//            }
//
//            updateCollectionView(with: filteredMovies)
//        }
//    func updateCollectionView(with movies: [Movie]) {
//        self.filteredMovies = movies
//        moviesCollectionView.reloadData()
//    }
//}
