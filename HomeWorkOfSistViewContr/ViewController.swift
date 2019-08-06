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
import MessageUI
class ViewController: UIViewController{
    
    //MARK: - Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    
    //MARK: - Propertys
     var dataManadger = DataManager()
     var stopIndex = 0{
        didSet{
            stopAddImage()
        }
    }
    
    
    var loadData = [Data](){
        didSet{
            
           print("tttttttt")
        }
    }
    
    var arrayData = [Data](){
        didSet{
            dataManadger.saveData(arrayData)
            print("появились данные")
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
            imageToData(imageToSend)
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
        loadData = dataManadger.loadDataImage() ?? []
        dataToImage(loadData)
        print(loadData)
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
    
    //MARK: - Create Image Of Data
    
    
    func createImageArray(data: [Data]){
        
    }


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
                let alert = UIAlertController(title: "это тестовое приложение - последнее Image добавлено не будет", message: nil, preferredStyle: .actionSheet)
                
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
            print("cann't to send")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["sergey.cosilov@gmail.com"])
        mailComposer.setSubject("Ошибка \(Date())")
        mailComposer.setMessageBody("Пожалуйста помогите с Massage composer'ом", isHTML: false)
        
        var archiveUrl: URL? {
            guard  let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{ return  nil}
            return documentDirectory.appendingPathComponent("DataImage").appendingPathExtension("data") }
        
        
        do {
            let attachmentData = try Data(contentsOf: archiveUrl!)
            mailComposer.addAttachmentData(attachmentData, mimeType: "dataf", fileName: "DataImage")
            mailComposer.mailComposeDelegate = self
            present(mailComposer, animated: true)
        } catch let error {
            print("We have encountered error \(error.localizedDescription)")
        }
        
    }
    
    
    
//        present(mailComposer,animated: true)
    
  
    
    @IBAction func infoButton(_ sender: Any) {
        labelText.isHidden = !labelText.isHidden
        
    }
    
    
    
    
    // MARK: - Function to save
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK: - ConvertImage
    
    func imageToData(_ array: [UIImage]){
        let image = array.last
        if image != nil{
            
            if image!.pngData() != nil{
                      self.arrayData.append(image!.pngData()!)
            }
        }
    }
    
    func dataToImage(_ array: [Data]){
        for data in array{
            let image = UIImage(data: data)
            if image != nil{
                imageToSend.append(image!)
            }
        }
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
    
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        dismiss(animated: true)
//    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
            break
            
        case .saved:
            print("Mail is saved by user")
            break
            
        case .sent:
            print("Mail is sent successfully")
            break
            
        case .failed:
            print("Sending mail is failed")
            break
        default:
            break
        }
        
        controller.dismiss(animated: true)
        
    }

}
//мой контроллер получился слишком большим - можно просто в extension выполнять какие то функции связанные с определенными дейвствиями?

