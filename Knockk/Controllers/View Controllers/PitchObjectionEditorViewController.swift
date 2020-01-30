//
//  PitchObjectionEditorViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/15/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import RealmSwift

class PitchObjectionEditorViewController: UIViewController {

    // MARK: - Properties
    
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    // MARK: - Landing Pads
    var objection: Objection? {
        didSet {
            loadViewIfNeeded()
            // Update Views
            updateViews()
        }
    }
    
    var pitch: Pitch? {
        didSet {
            loadViewIfNeeded()
            // Update Views
            updateViews()
        }
    }
    
    func updateViews() {
        //guard let objection = objection else { return }
//        titleTextField.text = objection.title
//        bodyTextView.text = objection.body
        
        if let objection = objection {
            self.navigationItem.title = "Objection Editor"
            titleTextField.text = objection.title
            bodyTextView.text = objection.body
        }
        
        if let pitch = pitch {
            self.navigationItem.title = "Pitch Editor"
            titleTextField.text = pitch.title
            bodyTextView.text = pitch.body
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func updateButtonTapped(_ sender: Any) {

        if let objection = objection,
            let title = titleTextField.text,
            let body = bodyTextView.text {
            let realm = try! Realm()
            try! realm.write {
                objection.title = title
                objection.body = body
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        if let pitch = pitch,
            let title = titleTextField.text,
            let body = bodyTextView.text {
            let realm = try! Realm()
            try! realm.write {
                pitch.title = title
                pitch.body = body
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
}
