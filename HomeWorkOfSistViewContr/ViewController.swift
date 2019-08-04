//
//  ViewController.swift
//  HomeWorkOfSistViewContr
//
//  Created by Сергей Косилов on 04.08.2019.
//  Copyright © 2019 Сергей Косилов. All rights reserved.
//
import MessageUI
import SafariServices
import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelText: UILabel!
    
    
    
  
    
    //MARK: - Propertys
    
    var stopIndex = 0{
        didSet{
            stopAddImage()
        }
    }
    
    var imageMainArray : [UIImage] = [UIImage(named:"sietl")!]{
        didSet{
           
            print("изменение главного массива")
        }
       
    }
    
    var imageToSend = [UIImage](){
        didSet{
            
            sendData()
            print("изменение  массива for send")
            print("index\(stopIndex)!!!!")
        }
        
    }
    
    func sendData() {
        
        let CVC = children.last as! ImagesViewController
        CVC.arrayImages = imageToSend
        print( "передадача данных\(CVC.arrayImages.count)")
    }
    
    
     //MARK: - UIViewController Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(with: view.bounds.size)
        labelText.isHidden = true
 
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(with: size)
    }

    
    //MARK: - UI Method
    
    func updateUI(with size: CGSize){
        let isVertical = size.width < size.height
        stackView.axis = isVertical ? .vertical : .horizontal
    }
    
//    //MARK: - Segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "InfoSegue" {
//            let infoImageVC = segue.destination as? ImagesViewController
//            infoImageVC?.arrayImages = imageMainArray
//            print("изначальная передача")
//        }
//    }
    


    //MARK: - Gesture
 
    @IBAction func longPress(_ sender: UIImage) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        allertImage()
    }
    
    func allertImage(){
   //     if self.imageToSend.count == stopIndex

        let alert = UIAlertController(title: "Добавить изображение для отправки?", message: nil, preferredStyle: .actionSheet)
            let addAlert = UIAlertAction(title: "Добавить", style: .default){ action in
                self.addImage(image: self.imageView.image!)
                
        }
            alert.addAction(addAlert)
            let cancelAlert = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alert.addAction(cancelAlert)
        
            self.present(alert, animated: true, completion: nil)
    }
    
    func addImage(image: UIImage){
        imageToSend.append(image)
        print(imageToSend.count)
    }
    
    //MARK: - Stop Allert
    
    func stopAddImage(){
        
        if self.imageToSend.count == stopIndex{

            let alert = UIAlertController(title: "это тестовое приложение - достигнуто максимальное количество image, удалите фото двойным нажатием на массиве фото", message: nil, preferredStyle: .actionSheet)

            let cancelAlert = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alert.addAction(cancelAlert)
           
            self.present(alert, animated: true, completion: nil)}
        else{
            if self.imageToSend.count > stopIndex{
                let alert = UIAlertController(title: "это тестовое приложение - последнее Image добавлено не будет(но по правде говоря я не реализовал пока удаление из массива - просто времени нет)", message: nil, preferredStyle: .actionSheet)
                
                let cancelAlert = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                alert.addAction(cancelAlert)
                self.present(alert, animated: true, completion: nil)}
            
        }
        }

    
    
    //MARK: - Action
    
    @IBAction func shareButtonPressed(_ sender: UIButton){
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true)
    }
    
    @IBAction func safaryButtonPressed(_ sender: UIButton){
        let url = URL(string: "http://www.apple.com")!
        let safary = SFSafariViewController(url: url)
        present(safary, animated: true)
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton){
        let alert = UIAlertController(title: "Пожалуйста выберите изображение", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let cancelAlert = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAlert)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Камера", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibrary = UIAlertAction(title: "Галерея", style: .default) {action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alert.addAction(photoLibrary)}
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true)
        
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton){
        guard MFMailComposeViewController.canSendMail() else{
            return  //!!!!
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["sergey.cosilov@yandex.ru"])
        mailComposer.setSubject("Ошибка \(Date())")
        mailComposer.setMessageBody("Пожалуйста помогите с Massage composer'ом", isHTML: false)
        present(mailComposer,animated: true)
        
    }
  
    
    @IBAction func infoButton(_ sender: Any) {
        labelText.isHidden = !labelText.isHidden
        
    }
}



 //MARK: - Extension
extension ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#line,#function)
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        imageView.image = selectedImage
        dismiss(animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate{}

extension ViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
    
    func addAttachmentData(){
        
    }
}
