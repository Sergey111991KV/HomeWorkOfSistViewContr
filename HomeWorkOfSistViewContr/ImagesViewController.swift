//
//  ImagesViewController.swift
//  HomeWorkOfSistViewContr
//
//  Created by Сергей Косилов on 04.08.2019.
//  Copyright © 2019 Сергей Косилов. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {

    @IBOutlet var imagesArray: [UIImageView]!
    
    @IBOutlet weak var pageControlImage: UIPageControl!
  
    
    var arrayImages = [UIImage](){
        didSet{
            print("изменение массива контейнера\(arrayImages.count)")
            updateImageWithArray()
            sendDataToVc()
            
        }
    }
        

    
    
    override func viewDidLoad() {
        
      print("массив контейнера\(arrayImages.count)")
       gesterImage()
    }
  
  
    

    func gesterImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
       
    
    }
    
    func allertImage(){
        let index = pageControlImage.currentPage
        if self.imagesArray![index].image! != UIImage(named: "фотоаппарат")!{
        
        let alert = UIAlertController(title: "Хотите удалить выбранное изображение?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAlert = UIAlertAction(title: "Удалить", style: .default){ action in
            self.destroyImage(index: index)}
        alert.addAction(deleteAlert)
        let cancelAlert = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAlert)
        //alert.popoverPresentationController?.sourceView = sender
       self.present(alert, animated: true, completion: nil)
        
        }
        
    }
   
    func destroyImage(index: Int){
        self.imagesArray[index].image! = UIImage(named: "фотоаппарат")!
        self.arrayImages.remove(at: index)
        
        let Vc = parent as! ViewController
        Vc.imageToSend.remove(at: index)
    }
    @objc func doubleTapped(){
        print("Двойное нажатие")
        allertImage()
    }
    
    func updateImageWithArray(){
        
        for index in 0..<arrayImages.count{
            if   index < imagesArray.count {
                imagesArray[index].image! = arrayImages[index]
                print(index)
            }
        }
      
    }

    //MARK: - Send MainVC
    
    func sendDataToVc() {
        
        let Vc = parent as! ViewController
        Vc.stopIndex = imagesArray.count
    }
}
    
    

extension ImagesViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        pageControlImage.currentPage = Int(scrollView.contentOffset.x / pageWidth)
    }
}
// как!! как привязать нажатое на телефоне изображение в коде, из массива изображений??
// небольшой косяк в порядке удаления изображений из массива - нужно доработать логику
