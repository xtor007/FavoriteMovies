//
//  ListVC.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 31.08.2022.
//

import UIKit
import RxSwift

class ListVC: UIViewController {
    
    private enum AddMoviePanelStatus {
        case open, close
    }
    
    let model: ListViewModel
    let disposeBag = DisposeBag()
    
    private var addMoviePanelStatus = AddMoviePanelStatus.close {
        didSet {
            changeAddMoviePanel(toStatus: addMoviePanelStatus)
        }
    }
    
    @IBOutlet weak var addMovieView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var openPanelButton: UIButton!
    
    @IBOutlet weak var moviesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        yearTextField.delegate = self
        //for init value
        changeAddMoviePanel(toStatus: .close)
        //get data
        model.getAllMovies { message in
            self.showError(message: message)
        }
    }
    
    init(model: ListViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///Change add movie panel status
    private func changeAddMoviePanel(toStatus status: AddMoviePanelStatus) {
        switch status {
        case .open:
            UIView.animate(withDuration: 0.2, delay: 0.05, options: .curveEaseIn) {
                self.addMovieView.transform = .identity
                self.openPanelButton.alpha = 0
            }
        case .close:
            addMovieView.transform = CGAffineTransform(translationX: 0, y: -250)
            self.openPanelButton.alpha = 1
            //close keyboard
            self.titleTextField.text = ""
            self.titleTextField.endEditing(true)
            self.yearTextField.text = ""
            self.yearTextField.endEditing(true)
        }
    }
    
    @IBAction func addMovieAction(_ sender: Any) {
        guard let title = titleTextField.text, let year = yearTextField.text else {
            showError(message: "All fields must be filled")
            return
        }
        model.addMovie(title: title, yearString: year) {
            self.addMoviePanelStatus = .close
        } onError: { message in
            self.showError(message: message)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        addMoviePanelStatus = .close
    }
    
    @IBAction func openPanelAction(_ sender: Any) {
        addMoviePanelStatus = .open
    }
    
    @IBAction func tapAction(_ sender: Any) {
        titleTextField.endEditing(true)
        yearTextField.endEditing(true)
    }
    
}

extension ListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 { //is title
            yearTextField.becomeFirstResponder()
        } else if textField.tag == 1 { //is year
            addMovieAction(0)
        }
        return true
    }
    
}
