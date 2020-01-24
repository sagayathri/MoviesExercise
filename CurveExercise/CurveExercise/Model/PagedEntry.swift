//
//  PagedEntry.swift
//  CurveExercise
//

import Foundation

//MARK:- PagedEntry
struct PagedEntry: Codable {
    let page: Int
    let results: [Movie]
    let total_results, total_pages: Int
}

//MARK:- Result
struct Movie: Codable {
    let popularity: Double
    let vote_count: Int
    let video: Bool
    let poster_path: String?
    let id: Int
    let adult: Bool
    let backdrop_path: String?
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let title: String
    let vote_average: Double
    let overview, release_date: String
}

//MARK:- CoreMovies
struct CoreMovies: Codable {
    let id: Int
    let voteAvg: Double
    let name: String
    let isFav: Bool
    let date: String
}
