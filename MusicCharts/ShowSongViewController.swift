//
//  ShowSongViewController.swift
//  MusicCharts
//
//  Created by Austin Dotto on 7/26/18.
//  Copyright © 2018 Austin Dotto. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}



class ShowSongViewController: UIViewController {
    
    
        var songTitle : String = ""
        var songArtist : String = ""
        var songAlbum : String = ""
        var albumCover : UIImage? = nil
        var preview : String = ""
    
    var player = AVAudioPlayer()
 
    @IBAction func previewButton(_ sender: Any) {
        playSound(soundUrl: preview)
    }
    
    /*
    func prepareSong(){
        do{
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: preview, ofType: "m4a")!))
            player.prepareToPlay()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch let sessionError {
            print (sessionError)
        }
        }catch let playerError {
            print (playerError)
            }
            
    }
    
    */

    
        


    
  
    
    func playSound(soundUrl: String) {
        let sound = NSURL(fileURLWithPath: soundUrl)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: sound as URL)
            audioPlayer.delegate = self as? AVAudioPlayerDelegate
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var track: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    let newImage = albumCover?.resized(withPercentage: 2.0)
        
     print(preview)
    
        albumImageView.image = newImage
        album.text = songAlbum
        track.text = songTitle
        artist.text = songArtist
        
        // Do any additional setup after loading the view.
    }
    
   
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
