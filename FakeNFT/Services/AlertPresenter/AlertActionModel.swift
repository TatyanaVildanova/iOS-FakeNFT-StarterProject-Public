import UIKit

struct AlertActionModel {
    let buttonText: String
    let style: UIAlertAction.Style
    let completion: () -> Void
}
