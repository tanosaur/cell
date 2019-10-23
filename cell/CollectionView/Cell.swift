import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bringSubviewToFront(button)
//        self.contentView.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.button.setTitle(nil, for: .normal)
    }
}
