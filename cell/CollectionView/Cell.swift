import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bringSubviewToFront(textLabel)
        self.contentView.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = nil
    }
}
