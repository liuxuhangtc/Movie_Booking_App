//
//  MovieDetailViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var mov: Movie?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var releaseField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!
    var path: String?
    var isUpdate: Bool = false
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        
        title = "Movie Detail"
        view.addTapToCloseEditing()
        
        [titleField, releaseField, typeField, quantityField].forEach({$0?.addPaddingLeft(10)})
        releaseField.delegate = self
        
        let rec = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        imgView.addGestureRecognizer(rec)
        
        if let info = mov {
            titleField.text = info.title
            releaseField.text = info.m_release
            typeField.text = info.type
            quantityField.text = String(info.quantity)
            
            path = info.cover
            imgView.image = UIImage(contentsOfFile: info.cover!)
            
        } else {
            deleteButton.isHidden = true
        }
        
    }
    
    @objc func selectPhoto() {
        let pickerCamera = UIImagePickerController()
        pickerCamera.delegate = self
        self.present(pickerCamera, animated: true, completion: nil)
    }
    
    func photoEvent() {
        let pickerPhoto = UIImagePickerController()
        pickerPhoto.sourceType = .camera
        pickerPhoto.delegate = self
        self.present(pickerPhoto, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagePickerc = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgView.image = imagePickerc
        isUpdate = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit() {
        if var info = mov {
            guard let title = titleField.text, title.count > 0 else {
                return showTips("Please enter movie name ")
            }
            guard let release = releaseField.text , release.count > 0 else {
                return showTips("Please enter movie release date ")
            }
            guard let _ = release.date("MM-dd-YYYY") else {
                return showTips("release date must be 'MM-dd-YYYY'")
            }
            guard let type = typeField.text, type.count > 0 else {
                return showTips("Please enter movie type ")
            }
            guard let quantity = quantityField.text , let q = Int(quantity), q > 0 else {
                return showTips("Please enter movie quantity ")
            }

            if isUpdate {
                guard let img = imgView.image else {
                    return showTips("Please choose movie cover ")
                }
                
                guard let p = img.saveToDoc() else {return}
                info.cover = p
            }
            
            info.title = title
            info.m_release = release
            info.type = type
            info.quantity = Int16(q)
            
            DBManager.default.updateMovie(info)
            
            popBack()
        } else {
            guard let title = titleField.text, title.count > 0 else {
                return showTips("Please enter movie name ")
            }
            guard let release = releaseField.text , release.count > 0 else {
                return showTips("Please enter movie release date ")
            }
            guard let _ = release.date("MM-dd-YYYY") else {
                return showTips("release date must be 'MM-dd-YYYY'")
            }
            guard let type = typeField.text, type.count > 0 else {
                return showTips("Please enter movie type ")
            }
            guard let quantity = quantityField.text , let q = Int(quantity) else {
                return showTips("Please enter movie quantity ")
            }
            
            guard let img = imgView.image else {
                return showTips("Please choose movie cover ")
            }
            
            guard let p = img.saveToDoc() else {return}

            DBManager.default.addMovie(title, type: type, quantity: q, m_release: release, cover: p)
            popBack()
        }
    }
    
    @IBAction func delete() {
        let alertController = UIAlertController(title: "Tips", message: "Delete movie detail?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Delete", style: .default) { _ in
            
            DBManager.default.deleteMovie(self.mov!.title!)
            
            print("Delete Success")
            self.popBack()
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.navigationController?.present(alertController, animated: true, completion: nil)
        
    }
}

extension MovieDetailViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == releaseField {
            RPicker.selectDate(title: "Select Date", didSelectDate: { (selectedDate) in
                // TODO: Your implementation for date
                textField.text = selectedDate.dateString("MM-dd-YYYY")
            })
            return false
        }
        return true
    }
}


