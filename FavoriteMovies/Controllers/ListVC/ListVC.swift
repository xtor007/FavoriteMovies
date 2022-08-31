//
//  ListVC.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 31.08.2022.
//

import UIKit
import RxSwift

class ListVC: UIViewController {
    
    let model: ListViewModel
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var addMovieView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var openPanelButton: UIButton!
    
    @IBOutlet weak var moviesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        closeAddMoviePanel()
    }
    
    init(model: ListViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///Close add movie panel
    private func closeAddMoviePanel() {
        addMovieView.transform = CGAffineTransform(scaleX: 0, y: 1)
    }
    
    @IBAction func addMovieAction(_ sender: Any) {
    }
    
    @IBAction func openPanelAction(_ sender: Any) {
    }
    
}
