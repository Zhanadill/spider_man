//
//  Movie.swift
//  spider_man
//
//  Created by Жанадил on 6/14/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit

struct Movie{
    var title: String
    var movieImage: String
    var rating: String
    var release_date: String
    var overview: String
    var checked = false
}


var arr: [Movie] = []

func bbb(checked: Bool, button: UIButton){
    if checked {
        button.setImage(UIImage(named: "star.fill"), for: .normal)
    }else{
        button.setImage(UIImage(named: "star"), for: .normal)
    }
}
