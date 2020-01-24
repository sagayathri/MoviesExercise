//
//  MovieViewController.swift
//  CurveExercise
//

import UIKit
import RxSwift

class MovieViewController: UIViewController, MovieViewModelDelegate {
  
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel: MovieViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
        
        viewModel = MovieViewModel.sharedInstance
        viewModel!.delegate = self
        viewModel!.getMoviesFromServer()
        
    }

    func loadTable() {
        self.movieTableView.reloadData()
    }
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel!.movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 140
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MovieTableViewCell
        
        if spinner.isAnimating {
            spinner.stopAnimating()
            spinner.isHidden = true
            movieTableView.isHidden = false
            tableView.isScrollEnabled = true
        }
        
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        
        cell.viewModel = self.viewModel
        cell.data = self.viewModel!.images[indexPath.row]
        cell.movie = self.viewModel!.movie[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel!.movie.count - 1 {
            viewModel!.getMoviesFromServer()
            tableView.isScrollEnabled = false
             DispatchQueue.main.async {
                self.spinner.isHidden = false
                self.spinner.startAnimating()
             }
        }
    }
}

