//
//  ViewController2.swift
//  spider_man
//
//  Created by Жанадил on 6/14/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import SDWebImage

protocol CheckDelegate: class{
    func checked()
}


class ViewController2: UIViewController {
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var mov: Movie?
    var k: Int?
    weak var checkDelegate: CheckDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aaa2(movie: mov!)
    }


    func aaa2(movie: Movie){
        img.sd_setImage(with: URL(string: movie.movieImage))
        rating.text = String(round(Double(movie.rating)! * 100)/100)
        lbl.text = "\(movie.title)\n \(movie.release_date)"
        overview.text = movie.overview
        bbb(checked: movie.checked, button: checkButton)
    }
    
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        arr[k!].checked = !arr[k!].checked
        bbb(checked: arr[k!].checked, button: sender)
        checkDelegate?.checked()
    }
}
