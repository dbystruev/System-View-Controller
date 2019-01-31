//
//  ViewController.swift
//  System View Controller
//
//  Created by Denis Bystruev on 31/01/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import MessageUI
import SafariServices
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func action() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            share()
        case 1:
            safari()
        case 2:
            photo()
        case 3:
            mail()
        default:
            print(#function)
        }
    }
    
    func mail() {
        guard MFMailComposeViewController.canSendMail() else {
            print(#function, "Can't send mail")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        
        composer.setToRecipients(["support@learnSwift.ru"])
        composer.setSubject("Сообщение об ошибке")
        composer.setMessageBody("Хотел сообщить о том, что тиграм не докладывают мяса...", isHTML: false)
        
        present(composer, animated: true, completion: nil)
    }
    
    func photo() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let controller = UIAlertController(title: "Выберите источник изображения", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        controller.addAction(cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: "📸", style: .default) { action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
            controller.addAction(camera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let library = UIAlertAction(title: "🖼", style: .default) { action in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
            controller.addAction(library)
        }
        
        
        controller.popoverPresentationController?.sourceView = segmentedControl
        
        present(controller, animated: true, completion: nil)
    }
    
    func safari() {
        let url = URL(string: "http://apple.ru")!
        
        let controller = SFSafariViewController(url: url)
        
        present(controller, animated: true, completion: nil)
    }
    
    func share() {
        guard let image = imageView.image else { return }
        
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.popoverPresentationController?.sourceView = segmentedControl
        
        present(controller, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        action()
    }

    @IBAction func controlSelected(_ sender: UISegmentedControl) {
        action()
    }
}


extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print(#function, error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
}
