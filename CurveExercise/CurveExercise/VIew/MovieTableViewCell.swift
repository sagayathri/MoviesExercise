//
//  MovieTableViewCell.swift
//  CurveExercise
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var MovieName: UILabel!
    @IBOutlet weak var ReleasedYear: UILabel!
    @IBOutlet weak var VoteAvg: UILabel!
    @IBOutlet weak var FavButton: UIButton!
    
    let constant = Constants()
    var viewModel: MovieViewModel?
    var data: NSData?
    var isFav = false
    
    var movie: CoreMovies? {
        didSet {
            self.configureCells()
        }
    }
    
    func configureCells() {
        MovieName.text = movie!.name
        VoteAvg.text = "\(String(describing: movie!.voteAvg))%"
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        let date: NSDate? = dateFormatterGet.date(from: movie!.date) as NSDate?
        ReleasedYear.text = dateFormatterPrint.string(from: date! as Date)
        
        self.posterImageView.image = UIImage(named: "no_image")
        let imageData = data! as NSData
        self.posterImageView.image = UIImage(data: imageData as Data)
       
        isFav = movie!.isFav
        setFavMovie()
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        isFav = !isFav
        setFavMovie()
        self.viewModel?.updateCoreMovies(id: movie!.id, isFav: isFav)
    }
    
    func setFavMovie() {
        if isFav {
            FavButton.setImage(UIImage(named: "Selected"), for: .normal)
        }
        else {
            FavButton.setImage(UIImage(named: "NotSelected"), for: .normal)
        }
    }
}
