//
//  LoginControllerDelegate.swift
//  MVC
//
//  Created by alok subedi on 06/08/2021.
//

protocol LoginControllerDelegate {
    func errorOnLogin(_ message: String)
    func loggedIn()
}
