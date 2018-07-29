//
//  MusicChartsTableViewController.swift
//  MusicCharts
//
//  Created by Austin Dotto on 7/26/18.
//  Copyright © 2018 Austin Dotto. All rights reserved.
//

import UIKit
import WebKit
import CoreData
import StoreKit




class MusicChartsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var yourSearch : String = "LedZeppelin"
    var searchActive : Bool = false
    var offset : Int = 0
    
    struct Music {
        var title : String = ""
        var artist : String = ""
        var album : String = ""
        var albumCover : UIImage? = nil
        var preview : String = ""
    }
    
    var musics : [Music] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self as? UISearchBarDelegate
        searchController.delegate = self as? UISearchControllerDelegate
        
        
        
        apiSearch(yourSearch)
    }
    
    func apiSearch (_: String){
        offset = 0
        if yourSearch != "" {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            
            
        let url = URL (string:"https://itunes.apple.com/search?term=" + yourSearch.replacingOccurrences(of: " ", with: "+") + "&media=music" )!
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        var counter = 0
                     //   print(jsonResult)
                        self.musics.removeAll()
                        while counter < jsonResult["resultCount"] as! Int {
                            var newMusic : Music = Music()
                            if let artist = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["artistName"] as? String {
                                      newMusic.artist = artist
                            }
                            if let track = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["trackName"] as? String {
                                newMusic.title = track
                            }
                            if let album = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["collectionName"] as? String {
                                     newMusic.album = album
                            }
                            
                            if let url = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["previewUrl"] as? String{
                                newMusic.preview = url
                            }
                            
                            if let albumImage = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["artworkUrl100"] as? String {
                                
                                
                                let imageUrl = URL(string: albumImage)!
                                
                                let imageData = try! Data(contentsOf: imageUrl)
                                
                                let image = UIImage(data: imageData)
                                
                                newMusic.albumCover = image
                                
                   
                            }
                            self.musics.append(newMusic)
                            
                            counter = counter + 1
                        }
                        DispatchQueue.main.async {
                           
                         //   print(self.musics)
                            
                            self.tableView.reloadData()
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    } catch {
                        print("JSON Processing Failed")
                    }
                    
                    if(self.musics.count == 0){
                        let alert = UIAlertController(title: "No music found", message: "Try a different search.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
 
                }
            }
        }
        task.resume()
           
        }
    }
    

 
  
        
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("search active = true")
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("search active = false")
        searchActive = false
        updateSearchResults(for: searchController)
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard self.searchActive == false else {return}
        print("update search results called")
        yourSearch = searchController.searchBar.text!
        apiSearch(yourSearch)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musics.count
    }
    
    
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MusicTableViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
         
        cell.trackName.text = musics[indexPath.row].title
        cell.artistName.text = musics[indexPath.row].artist
        cell.albumImage.image = musics[indexPath.row].albumCover
   

     return cell
     }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Add to playlist") { (contextualAction, view, boolValue) in
            boolValue(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]{
        
            let favoriteButton = UITableViewRowAction(style: .default, title: "Favorite"){ACTION,IndexPath in
                tableView.dataSource?.tableView?(self.tableView,commit: .delete, forRowAt: IndexPath)
            }
            favoriteButton.backgroundColor = UIColor.blue
            return [favoriteButton]
       
    }
    */
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = musics.count - 1
        if indexPath.row == lastElement {
            
            offset = offset + 25
            var myString = String(offset)
            // handle your logic here to get more items, add it to dataSource and reload tableview
            
            
            if yourSearch != "" {
                
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                activityIndicator.center = self.view.center
                
                activityIndicator.hidesWhenStopped = true
                
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                

                let url = URL (string:"https://itunes.apple.com/search?term=" + yourSearch.replacingOccurrences(of: " ", with: "+") + "&offset=" + myString + "&limit=25=&media=music" )!
                
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        if let urlContent = data {
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                var counter = 0
                                print(jsonResult)
                                while counter < jsonResult["resultCount"] as! Int {
                                    var newMusic : Music = Music()
                                    if let artist = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["artistName"] as? String {
                                        newMusic.artist = artist
                                    }
                                    if let track = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["trackName"] as? String {
                                        newMusic.title = track
                                    }
                                    if let album = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["collectionName"] as? String {
                                        newMusic.album = album
                                    }
                                    
                                    if let url = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["previewUrl"] as? String{
                                        newMusic.preview = url
                                    }
                                    
                                    if let albumImage = ((jsonResult["results"] as? NSArray)?[counter] as? NSDictionary)?["artworkUrl100"] as? String {
                                        
                                        
                                        let imageUrl = URL(string: albumImage)!
                                        
                                        let imageData = try! Data(contentsOf: imageUrl)
                                        
                                        let image = UIImage(data: imageData)
                                        
                                        newMusic.albumCover = image
                                        
                                        
                                    }
                                    self.musics.append(newMusic)
                                    
                                    counter = counter + 1
                                }
                                DispatchQueue.main.async {
                                    
                                    print(self.musics)
                                    
                                    self.tableView.reloadData()
                                    activityIndicator.stopAnimating()
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                }
                            } catch {
                                print("JSON Processing Failed")
                            }
                            
                            if(self.musics.count == 0){
                                let alert = UIAlertController(title: "No music found", message: "Try a different search.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                    }
                }
                task.resume()
                
            }
            
            
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //  guard let vc = segue.destination as? ShowCosmeticViewController else { return}
        if segue.identifier == "detailSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ShowSongViewController
                vc.songAlbum = musics[indexPath.row].album
                vc.songArtist = musics[indexPath.row].artist
                vc.songTitle = musics[indexPath.row].title
                vc.albumCover = musics[indexPath.row].albumCover
                vc.preview = musics[indexPath.row].preview
                
                
            }
        }
    }
 

    
}
