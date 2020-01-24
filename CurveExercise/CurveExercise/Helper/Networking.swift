//
//  Networking.swift
//  CurveExercise
//

import Foundation
import UIKit

class NetworkSession {
    //MARK:- Creates a shared instance for NetworkSession class
    static let sharedInstance = NetworkSession()
    
    let contant = Constants()
    let checkInternet = CheckInternet()
    let persistence = Persistance.sharedInstance
    var parentEntry: PagedEntry?
    var movies: [Movie] = []
    var coreMovie: [CoreMovies] = []
    var posterPath = ""
    var statusCode = 0
    var urlString = ""
    var viewModel: MovieViewModel? = nil
    var isSuccess = false

    func fetchDataFromAPI(pageNum: Int) {

        self.viewModel = MovieViewModel.sharedInstance
        
        urlString = contant.baseURLString+"\(contant.api_key)&language=\(contant.language)&page=\(pageNum)"
        
        //MARK:- Create the url with NSURL
        let url = URL(string: urlString)!
        //MARK:- Create a Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if checkInternet.Connection() {
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    self.statusCode = httpResponse.statusCode
                }
                
                do {
                    if self.statusCode == 200 {
                        self.isSuccess = true
                        self.parentEntry = try JSONDecoder().decode(PagedEntry.self, from: data)
                        self.movies = self.parentEntry!.results
                        if self.parentEntry?.page == 1 {
                            self.persistence.clearAllMovies()
                            self.persistence.clearAllImages()
                        }
                        //MARK:- Updates coredata
                        for item in self.movies {
                            self.coreMovie.append(CoreMovies(id: item.id,
                                                                    voteAvg: item.vote_average,
                                                                    name: item.original_title,
                                                                    isFav: false,
                                                                    date: item.release_date))
                        }
                        self.persistence.saveToCoreData(moviesToStore: self.coreMovie)
                        for item in self.movies {
                            if item.backdrop_path != nil {
                                self.LoadImage(imagePath: item.backdrop_path!)
                            }
                            else if item.poster_path != nil {
                                self.LoadImage(imagePath: item.poster_path!)
                            }
                            else {
                                self.LoadImage(imagePath: "noImage")
                            }
                        }
                    }
                    else {
                        self.isSuccess = false
                    }
                }
                catch {
                    print("Failed to parse JSON from URL")
                }
            })
            task.resume()
        }
        else {
            print("No or poor internet connection")
        }
    }
    
    func LoadImage(imagePath: String) {

        self.viewModel = MovieViewModel.sharedInstance
        
        urlString = contant.imageURL+imagePath
        
        //MARK:- Create the url with NSURL
        let url = URL(string: urlString)!
        //MARK:- Create a Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if checkInternet.Connection() {
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    self.statusCode = httpResponse.statusCode
                }
                
                if self.statusCode == 200 {
                    self.isSuccess = true
                    self.persistence.saveImage(imageData: data as NSData)
                }
                else {
                    self.isSuccess = false
                }
                
                if self.persistence.fetchImage()?.count == self.persistence.fetchMoviesFromCoreData()?.count {
                    self.viewModel?.reloadUI()
                }
            })
            task.resume()
        }
        else {
            print("No or poor internet connection")
        }
    }
}

