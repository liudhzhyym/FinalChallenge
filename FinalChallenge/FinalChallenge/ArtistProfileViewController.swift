//
//  ArtistProfileViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 27/10/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit
import iCarousel

class ArtistProfileViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var modelAccess : ModelAccessFacade!
    
    var artist: Artist!
    @IBOutlet weak var telefoneLblConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLblConstraint: NSLayoutConstraint!
    @IBOutlet weak var followButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topNameLblConstraint: NSLayoutConstraint!
    @IBOutlet weak var returnButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var telefoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var artWorkCarousel: iCarousel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    
    var firstTime: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTime = true
        modelAccess = ModelAccessFacade.init()
        
        profileImage.isHidden = true
        
        telefoneLbl.isHidden = true
        emailLbl.isHidden = true
        nameLbl.isHidden = true
        returnButton.isHidden = true
        
        telefoneLblConstraint.constant += view.bounds.width
        emailLblConstraint.constant += view.bounds.width
        followButtonConstraint.constant += view.bounds.width
        topNameLblConstraint.constant -= view.bounds.height
        returnButtonConstraint.constant -= view.bounds.height
        
        self.artWorkCarousel.alpha = 0
        
        print(artist.artWorks)
//        DatabaseAccess.sharedInstance.fetchArtWorksFor(artist: artist) { (success: Bool, response: String) in
//            if success {
//                self.artWorkCarousel.reloadData()
//            } else {
//                print("erro no fetchArtworks for artist")
//                //self.showAlert(title: "Erro", message: "Não foi possível carregar as informações do criador, tente novamente mais tarde")
//
//            }
//        }
        
        self.modelAccess.fetchArtWorksFor(artist: artist) { (success: Bool, response: String) in
            if success {
                self.artWorkCarousel.reloadData()
            } else {
                print("erro no fetchArtworks for artist")
                //self.showAlert(title: "Erro", message: "Não foi possível carregar as informações do criador, tente novamente mais tarde")
                
            }
        }
        
        emailButton.layer.shadowColor = UIColor.black.cgColor
        emailButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        emailButton.layer.shadowRadius = 3
        emailButton.isHidden = true
        
        followButton.layer.shadowColor = UIColor.black.cgColor
        followButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        followButton.layer.shadowRadius = 3
        self.followButton.setTitle("Follow", for: .normal)
        
        if modelAccess.getUserFavoriteArtistsIds().contains(artist.id){
//        if User.sharedInstance.favoriteArtistsIds.contains(artist.id) {
            followButton.setTitle("Unfollow", for: .normal)
        }
        
        
        //aqui preencher de acordo com a escolha do cara
        if let estilo = artist.getGalleryStyle() {
            artWorkCarousel.type = estilo
        } else {
            artWorkCarousel.type = .linear
        }
        nameLbl.text = artist.name
        emailLbl.text = artist.email
        
        //setar telefone OLENKA
        if let telefone = artist.tel1 {
            self.telefoneLbl.text = telefone
            self.telefoneLbl.isHidden = false
        } else {
            self.telefoneLbl.isHidden = true
        }
        
        if let picture = artist.profilePictureURL {
            if picture != "" {
                if self.artist.cachedImage != nil {
                    profileImage.image = self.artist.cachedImage
                } else {
                    profileImage.downloadedFrom(url: URL(string: picture)!, contentMode: .scaleAspectFill, callback: { (image: UIImage?) in
                        if image != nil {
                            self.artist.cachedImage = image
                        }
                    })
                }
            }
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if firstTime {
            telefoneLbl.isHidden = false
            emailLbl.isHidden = false
            nameLbl.isHidden = false
            returnButton.isHidden = false
            
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                self.telefoneLblConstraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                self.emailLblConstraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                self.followButtonConstraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                self.topNameLblConstraint.constant += self.view.bounds.height
                self.returnButtonConstraint.constant += self.view.bounds.height
                
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 1.65, delay: 0, options: .curveEaseIn, animations: {
                self.artWorkCarousel.alpha = 1
            }, completion: nil)
            firstTime = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapFollowArtist(_ sender: UIButton) {
        //fazer animação
        followButton.setTitle("Unfollow", for: .normal)
        
        
//        DatabaseAccess.sharedInstance.databaseAccessWriteFollowArtist(user: User.sharedInstance, artist: self.artist, callback: { (success: Bool, response: String) in
//            if success {
//                print(response)
//                User.sharedInstance.didFavoriteArtist = true
//            } else {
//                self.followButton.setTitle("Follow", for: .normal)
//                print(response)
//            }
//        })
        
        self.modelAccess.databaseAccessWriteFollowArtist(user: User.sharedInstance, artist: self.artist, callback: { (success: Bool, response: String) in
            if success {
                print(response)
                User.sharedInstance.didFavoriteArtist = true
            } else {
                self.followButton.setTitle("Follow", for: .normal)
                print(response)
            }
        })
    }

    @IBAction func didTapSendEmail(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return artist.artWorks.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
      //  label.text = "\(items[index])"
        
        //setar a view de acordo com a obra (será a foto inteira?) Esther
        let cellView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - self.headerView.frame.maxX))
        let artWorkImage = UIImageView(frame: CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: cellView.frame.height - 40))
        
            if artist.artWorks[index].urlPhotos.count > 0 {
                artWorkImage.downloadedFrom(link: artist.artWorks[index].urlPhotos[0], contentMode: .scaleAspectFill)
                artWorkImage.layer.masksToBounds = true

            }
        
        if let title = artist.artWorks[index].title {
            let artWorkTitle = UILabel(frame: CGRect(x: 15, y: artWorkImage.frame.maxY + 5, width: artWorkImage.frame.width, height: 30))
            artWorkTitle.textColor = .black
            artWorkTitle.textAlignment = .right
            artWorkTitle.text = title
            cellView.addSubview(artWorkImage)
            cellView.addSubview(artWorkTitle)
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap2.numberOfTapsRequired = 2
            
            cellView.addGestureRecognizer(tap2)
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
            tap1.numberOfTapsRequired = 1
            cellView.addGestureRecognizer(tap1)
        }
            
        
        
        return cellView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func doubleTapped() {
        //fazer Animação
//        DatabaseAccess.sharedInstance.databaseAccessWriteLikeArtWork(artwork: artist.artWorks[self.artWorkCarousel.currentItemIndex]) { (success: Bool, response: String) in
//            if success {
//                print("DEU CERTO PORRA")
//                User.sharedInstance.didLikeArtWork = true
//            } else {
//                print(response)
//            }
//        }
        
        
        self.modelAccess.databaseAccessWriteLikeArtWork(artwork: artist.artWorks[self.artWorkCarousel.currentItemIndex]) { (success: Bool, response: String) in
            if success {
                print("DEU CERTO PORRA")
                User.sharedInstance.didLikeArtWork = true
            } else {
                print(response)
            }
        }
    }
    
    func singleTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "ArtWorkDetail") as! ArtWorkDetailViewController
        modal.art = artist.artWorks[self.artWorkCarousel.currentItemIndex]
        self.present(modal, animated: true, completion: nil)
    }

}
