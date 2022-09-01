//
//  ListVC.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 31.08.2022.
//

import UIKit

class ListVC: UIViewController {
    
    private enum AddMoviePanelStatus {
        case open, close
    }
    
    enum Section {
        case first
    }
    
    let model: ListViewModel
    
    private var addMoviePanelStatus = AddMoviePanelStatus.close {
        didSet {
            changeAddMoviePanel(toStatus: addMoviePanelStatus)
        }
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Movie>!
    
    @IBOutlet weak var addMovieView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var openPanelButton: UIButton!
    
    @IBOutlet weak var moviesTable: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleTextField.delegate = self
        yearTextField.delegate = self
        
        //table
        moviesTable.register(UINib(nibName: MovieCell.nibName, bundle: nil), forCellReuseIdentifier: MovieCell.cellId)
        moviesTable.delegate = self
        dataSource = UITableViewDiffableDataSource(tableView: moviesTable, cellProvider: { tableView, indexPath, model in
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellId, for: indexPath) as? MovieCell {
                cell.initData(movie: model)
                return cell
            } else {
                self.showError(message: "Error in cell init")
                return UITableViewCell()
            }
        })
        
        //for init value
        changeAddMoviePanel(toStatus: .close)
        
        //get data
        model.getAllMovies { message in
            self.showError(message: message)
        }
        updateDatasource()
        
    }
    
    init(model: ListViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func addMovieAction(_ sender: Any) {
        guard let title = titleTextField.text, let year = yearTextField.text else {
            showError(message: "All fields must be filled")
            return
        }
        model.addMovie(title: title, yearString: year) {
            self.addMoviePanelStatus = .close
            self.updateDatasource()
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
    
    private func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.first])
        snapshot.appendItems(model.data)
        dataSource.apply(snapshot, animatingDifferences: true)
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

extension ListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "DELETE") { _, _, _ in
            self.model.deleteMovie(movieIndex: indexPath.row) { message in
                self.showError(message: message)
            }
            self.updateDatasource()
        }
        swipeDelete.backgroundColor = .systemRed
        let actions = [swipeDelete]
        let res = UISwipeActionsConfiguration(actions: actions)
        res.performsFirstActionWithFullSwipe = true
        return res
    }
    
}
