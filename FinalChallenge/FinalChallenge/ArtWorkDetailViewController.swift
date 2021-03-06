//
//  ArtWorkDetailViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 24/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ArtWorkCell: UICollectionViewCell {
    @IBOutlet weak var artworkImage: UIImageView!
}


class ArtWorkDetailViewController: UIViewController {

    var art: ArtWork!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var creatorNameLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.titleLbl.text = art.title
        self.creatorNameLbl.text = art.creatorName
        if let likes = art.totalLikes {
            self.likesLbl.text = String(likes) + " likes"
        } else {
            self.likesLbl.text = ""
        }
        
        if let value = art.value {
            if value != 0 {
                self.likesLbl.text = "R$ \(value)"
            }
        }
        
        
        self.descriptionLbl.text = art.descricao
        self.view.bringSubview(toFront: informationView)
        self.view.bringSubview(toFront: pageControl)

        self.informationView.alpha = 0
        self.pageControl.numberOfPages = self.art.urlPhotos.count
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

    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ArtWorkDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return art.urlPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtWorkCell", for: indexPath) as! ArtWorkCell
        cell.artworkImage.downloadedFrom(link: art.urlPhotos[indexPath.row], contentMode: .scaleAspectFit)
        cell.artworkImage.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: { 
            if self.informationView.alpha == 0 {
                self.informationView.alpha = 1
            } else {
                self.informationView.alpha = 0
            }
        }) { (success: Bool) in
            //tudo certo
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height - self.backButton.frame.maxY - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
}
