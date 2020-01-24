//
//  MovieViewModel.swift
//  CurveExercise
//

import Foundation
import UIKit

//MARK:- An inteface to load table view
protocol MovieViewModelDelegate {
    func loadTable()
}

class MovieViewModel {
    static let sharedInstance = MovieViewModel()
    let networkSession = NetworkSession.sharedInstance
    var constant = NetworkSession.sharedInstance.contant
    
    var pagedEntry: PagedEntry? = nil

    var isSuccess = false
    var dispatchGroup = DispatchGroup()
    var delegate: MovieViewModelDelegate? = nil
    var movie: [CoreMovies] = []
    var images: [NSData] = []
    
    func getMoviesFromServer() {
        constant.pageNum = constant.pageNum + 1
        networkSession.fetchDataFromAPI(pageNum: constant.pageNum)
    }
    
    func reloadUI() {
        self.movie = self.networkSession.persistence.fetchMoviesFromCoreData()!
        self.images = self.networkSession.persistence.fetchImage()!
        DispatchQueue.main.async {
            self.delegate?.loadTable()
        }
    }
    
    //MARK:- Updates coredata with favourite variable
    func updateCoreMovies(id: Int, isFav: Bool) {
        for i in 0 ..< self.movie.count {
            let changedMovie = CoreMovies(id: id,
                                          voteAvg: self.movie[i].voteAvg,
                                          name: self.movie[i].name,
                                          isFav: isFav,
                                          date: self.movie[i].date)
            if self.movie[i].id == id {
                self.movie.remove(at: i)
                self.movie.insert(changedMovie, at: i)
            }
        }
        self.networkSession.persistence.clearAllMovies()
        self.networkSession.persistence.saveToCoreData(moviesToStore: self.movie)
    }
}
