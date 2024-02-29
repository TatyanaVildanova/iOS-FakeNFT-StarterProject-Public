import UIKit

protocol AlertPresenterProtocol {
    func injectDelegate(viewController: UIViewController)
    func didTapSortButton(models: [AlertActionModel])
}
