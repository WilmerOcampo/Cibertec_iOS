//
//  MovieViewController.swift
//  Cibertec
//
//  Created by Wilmer Ocampo on 11/12/24.
//

import UIKit

struct Movie {
    var name: String
}

class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var moviesList: [Movie] = []
    
    let itemRow: CGFloat = 3
    let sectionsInsets = UIEdgeInsets(top: 25, left: 15, bottom: 0, right: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        moviesList.append(Movie(name: "Pelicula 1"))
        moviesList.append(Movie(name: "Pelicula 2"))
        moviesList.append(Movie(name: "Pelicula 3"))
        moviesList.append(Movie(name: "Pelicula 4"))
        moviesList.append(Movie(name: "Pelicula 5"))
        moviesList.append(Movie(name: "Pelicula 6"))
        moviesList.append(Movie(name: "Pelicula 7"))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = moviesList[indexPath.row]
        cell.nameLabel.text = movie.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionsInsets.left + sectionsInsets.right
        let widthFree = collectionView.frame.width - paddingSpace - (itemRow - 1) * 10
        let widthItem = widthFree / itemRow
        
        return CGSize(width: widthItem, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInsets
    }
    

}
