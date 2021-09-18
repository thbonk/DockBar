//
//  GrantAccessWindowController.swift
//  DockBar
//
//  Created by Thomas Bonk on 26.07.21.
//

import Cocoa

class GrantAccessWindowController: NSWindowController {

  // MARK: - Private Properties

  private var folderUrl: URL? = nil {
    didSet {
      grantAccessViewController?.pathUrl = folderUrl
    }
  }
  private var checkClosure: ((URL) -> (String?))? = nil {
    didSet {
      grantAccessViewController?.checkClosure = checkClosure
    }
  }
  private var completedClosure: ((URL?) -> ())? = nil {
    didSet {
      grantAccessViewController?.completedClosure = grantAccessCompleted(url:)
    }
  }

  private var grantAccessViewController: GrantAccessViewController? {
    return contentViewController as? GrantAccessViewController
  }


  // MARK: - Class Methods

  @discardableResult
  class func grantAccess(
    to folderUrl: URL,
           check: ((URL) -> (String?))? = nil,
       completed: ((URL?) -> ())? = nil) -> GrantAccessWindowController {

    let windowController = StoryboardScene.Main.grantAccessWindowController.instantiate()

    DispatchQueue.main.async {
      windowController.folderUrl = folderUrl
      windowController.checkClosure = check
      windowController.completedClosure = completed
    }

    DispatchQueue.main.async {
      windowController.showWindow(folderUrl)
      windowController.window?.makeKeyAndOrderFront(folderUrl)
    }

    return windowController
  }


  // MARK: Private Methods

  private func grantAccessCompleted(url: URL?) {
    self.close()
    completedClosure?(url)
  }
}

class GrantAccessViewController: NSViewController {

  // MARK: - Private Properties

  fileprivate var pathUrl: URL? = nil {
    didSet {
      folderLabel.stringValue = pathUrl?.path ?? "<unknown>"
    }
  }
  fileprivate var checkClosure: ((URL) -> (String?))? = nil
  fileprivate var completedClosure: ((URL?) -> ())? = nil

  private var grantAccessWindowController: GrantAccessWindowController? {
    self.view.window?.windowController as? GrantAccessWindowController
  }

  @IBOutlet
  private var folderLabel: NSTextField!
  @IBOutlet
  private var errorLabel: NSTextField!


  // MARK: - Private Methods

  @IBAction
  private func openFolder(sender: NSButton) {
    let selectedFolderUrl = showFolderOpenPanel()

    guard let url = selectedFolderUrl else {
      showError("You haven't selected anything. Please try again!")
      return
    }

    guard url.path == pathUrl?.path else {
      showError("You have selected \(url.path) which is wrong. Please try again!")
      return
    }

    if let errorMessage = checkClosure?(url) {
      showError(errorMessage)
      return
    }

    do {
      _ = try url.bookmarkData()

      clearError()
      completedClosure?(url)
    } catch {
      showError("Error while granting access to '\(pathUrl!.path)'.\nError is \(error.localizedDescription)")
    }
  }

  private func showFolderOpenPanel() -> URL? {
    let dialog = NSOpenPanel()
    var isDirectory = ObjCBool(false)

    FileManager.default.fileExists(atPath: pathUrl!.path, isDirectory: &isDirectory)

    dialog.title = "Please select \(pathUrl!.path)"
    dialog.message = "Please select \(pathUrl!.path)"
    dialog.canChooseDirectories = isDirectory.boolValue
    dialog.canChooseFiles = !isDirectory.boolValue
    dialog.canHide = false
    dialog.isAccessoryViewDisclosed = false
    dialog.showsTagField = false
    dialog.canCreateDirectories = false
    dialog.directoryURL = pathUrl
    dialog.allowsMultipleSelection = false

    switch dialog.runModal() {
      case .OK:
        return dialog.url!

      default:
        return nil
    }
  }

  private func showError(_ message: String) {
    self.errorLabel.stringValue = message
    self.errorLabel.isHidden = false
  }

  private func clearError() {
    self.errorLabel.isHidden = true
    self.errorLabel.stringValue = ""
  }
}
