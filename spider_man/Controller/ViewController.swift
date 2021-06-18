//
//  ViewController.swift
//  spider_man
//
//  Created by Жанадил on 6/14/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let url = "https://api.themoviedb.org/3/movie/550/similar?"
    var k: IndexPath?
    var t = 0
    var aaa = false
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1136245802, green: 0.1930128038, blue: 0.3314402401, alpha: 1)
        self.collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        loadItems()
        requestInfo()
        //print(dataFilePath)
    }

    
    //Function that's responsible for Data Extraction
    func requestInfo(){
        let parameters: [String: String] = [
            "api_key":"6bcdd11fee2e662ba70b0c7d272cec4c"
        ]
        if (aaa || arr.count==0){
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
                       (response) in
                       if response.result.isSuccess{
                           //print(response)
                           let movieJSON: JSON = JSON(response.result.value!)
                           for i in self.t..<self.t+10{
                               let title =  movieJSON["results"][i]["title"].stringValue
                               let rating = movieJSON["results"][i]["vote_average"].stringValue
                               let release_date = movieJSON["results"][i]["release_date"].stringValue
                               let overview = movieJSON["results"][i]["overview"].stringValue
                               let img = "https://image.tmdb.org/t/p/w500\(movieJSON["results"][i]["backdrop_path"].stringValue)"
                               let item = Movie(title: title, movieImage: img, rating: rating, release_date: release_date, overview: overview)
                               arr.append(item)
                           }
                           
                           if(self.t + 10 < movieJSON["results"].count){
                               self.t += 10
                           }else{
                               self.t = 0
                           }
                           
                           print(arr.count)
                           self.saveItems()
                       }
                   }
        }
    }
    
    
    //Function that allows us save data
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(arr)
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding item array \(error)")
        }
        self.collectionView.reloadData()
    }
    
    
    //Here we load data from plist
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                arr = try decoder.decode([Movie].self, from: data)
            }catch{
                print("error is \(error)")
            }
        }
    }
}




//MARK: -ViewController DataSource Methods
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.buttonAction = { sender in
            arr[indexPath.row].checked = !arr[indexPath.row].checked
            self.saveItems()
            bbb(checked: arr[indexPath.row].checked, button: cell.checkButton)
        }
        bbb(checked: arr[indexPath.row].checked, button: cell.checkButton)
        cell.aaa(movie: arr[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           if (indexPath.row == arr.count - 1 ) {
               aaa = true
               requestInfo()
           }
       }
}




//MARK: -ViewController DataFlowLayout Methods
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}




//MARK: -ViewController Delegate Methods
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        k = indexPath
        performSegue(withIdentifier: "segue1", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1"{
            let destinationVC = segue.destination as! ViewController2
            destinationVC.mov = arr[k!.row]
            destinationVC.k = k!.row
            destinationVC.checkDelegate = self
            destinationVC.title = arr[k!.row].title
        }
    }
}




extension ViewController: CheckDelegate{
    func checked() {
        saveItems()
        collectionView.reloadData()
    }
}
