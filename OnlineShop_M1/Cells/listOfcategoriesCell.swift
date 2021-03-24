
import UIKit

class listOfcategoriesCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUp(){
        backView.layer.cornerRadius = 20
        
    }

}
