//
//  HomeViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 27.04.2023.
//

import UIKit

// TODO: search yap
class HomeViewController: UIViewController, UITextFieldDelegate {

    private var movies: [Movie]? //all movies
    private var genres: [Genre]? //all categories
    
    var searching = false
    var filteredMovies: [Movie]? // searching
    
    var isFiltered = true
    var categoryMovies: [Movie]? // filter categories
    
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
  
        // TODO: network istekleri viewModel'e alınacak
        APIManager.shared.execute(url: APIManager.shared.apiURL) { (data: MovieResponse?) in
            self.movies = data?.results ?? []
            self.categoryMovies = data?.results ?? []
            // TODO: main async değişimi servis isteğinde response alındığı yerde yapılacak
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
        }
        APIManager.shared.execute(url: APIManager.shared.genreApiURL) { (data: GenreResponse?) in
            self.genres = data?.genres ?? []
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func searchHandler(_ sender: UITextField) {
        if let searchText = sender.text{
            filteredMovies = searchText.isEmpty ? movies : movies?.filter { movie in
                if let title = movie.title?.lowercased() {
                    return title.contains(searchText.lowercased())
                }
                return false
            }
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
}

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == moviesCollectionView {
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            let movie = categoryMovies?[indexPath.row] //save index-collections
            let firstGenre = genres?.filter { $0.id == (movie?.genreIDS?.first ?? 0) }.first
            gotoDetailController.movieId = indexPath.row
            
            if let movie, let firstGenre {
                gotoDetailController.prepare(movie: movie, firstGenre: firstGenre) // TODO: İsim değiştir
                navigationController?.pushViewController(gotoDetailController, animated: true)
            }
            return
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == moviesCollectionView {
            if searching {
                return filteredMovies?.count ?? 0
            }else if isFiltered {
                return categoryMovies?.count ?? 0
            }else{
                return movies?.count ?? 0
            }
        } else if collectionView == categoryCollectionView {
            return genres?.count ?? 0
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
                cell.movieNameLabel.text = filteredMovies?[indexPath.row].title
                cell.movieVoteLabel.text = String(filteredMovies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = filteredMovies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                if let imageFullPath = imgFullPath {
                    cell.movieImageView.loadImg(url: imageFullPath)
                    filteredMovies?[indexPath.row].genreIDS?.forEach{print("filtered movie:\($0)")}
                }
                
            }else if isFiltered{
                cell.movieNameLabel.text = categoryMovies?[indexPath.row].title
                cell.movieVoteLabel.text = String(categoryMovies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = categoryMovies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")
                               

                if let imageFullPath = imgFullPath{
                    cell.movieImageView.loadImg(url: imageFullPath)
                }
             
                let movieGenres = categoryMovies?[indexPath.row].genreIDS ?? []
                let genreName = genres?.filter { genre in
                    movieGenres.contains(genre.id ?? 0)
                }.map { $0.name ?? "" }.joined(separator: ",")
                                
                cell.movieCategoryNameLabel.text = genreName
                
            }else{
                cell.movieNameLabel.text = movies?[indexPath.row].title
                cell.movieVoteLabel.text = String(movies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = movies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                cell.movieImageView.loadImg(url: imgFullPath!)
                
                let movieGenres = movies?[indexPath.row].genreIDS ?? []
                let genreName = genres?.filter { genre in
                    movieGenres.contains(genre.id ?? 0)
                }.map { $0.name ?? "" }.joined(separator: ",")
                
//                var genreName = ""
//                for genre in genres ?? [] {
//                    if ((movies?[indexPath.row].genreIDS?.contains(genre.id!)) == true) {
//                        genreName +=  genre.name ?? ""
//                        genreName += ","
//                    }
//                }
                cell.movieCategoryNameLabel.text = genreName
                movies?[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}
            }

            return cell
        }

        else if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            categoryCell.categoryNameLabel.text = genres?[indexPath.row].name

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
               filteredMovies = (movies?.filter { movie in
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
   
        categoryMovies = movies?.filter{ $0.genreIDS?.contains(genres?[indexPath.row].id ?? 0) ?? false }
        moviesCollectionView.reloadData()
    }
}
