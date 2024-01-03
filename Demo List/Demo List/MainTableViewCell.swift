//
//  MainTableViewCell.swift
//  Demo List
//
//  Created by riyaswami on 21/12/23.
//

import UIKit

protocol CellDelegate: AnyObject{
    func deleteCell(id: UUID)
}

class MainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkBoxVIEW: UIView!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var label: UILabel!
    var vm: MainCellVM?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        label.text = ""
        vm = nil
    }
        
    func initializeVM(vm: MainCellVM){
        self.vm = vm
    }

    func updateLabel(){
        label.text = vm?.labelText
        checkBox.layer.borderColor = UIColor.black.cgColor
        checkBoxVIEW.layer.cornerRadius = checkBoxVIEW.bounds.height/2
        checkBox.layer.cornerRadius = checkBox.bounds.height/2
        checkBox.layer.borderWidth = 2
        let clicked = vm?.clicked ?? false
        if clicked{
            checkBox.backgroundColor = .green
        }
        else{
            checkBox.backgroundColor = .white
        }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        vm?.changeState()
        let clicked = vm?.clicked ?? false
        if clicked{
            checkBox.backgroundColor = .green
        }
        else{
            checkBox.backgroundColor = .white
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        vm?.deleteCell()
    }
    
}

class MainCellVM: HashableCells{
    var labelText: String
    var isDone: Bool
    weak var delegate: CellDelegate?
    var clicked: Bool = false
    init(labelText: String, isDone: Bool) {
        self.labelText = labelText
        self.isDone = isDone
    }
    
    func deleteCell(){
        delegate?.deleteCell(id: self.id)
    }
    func changeState(){
        clicked = !clicked
    }
}

