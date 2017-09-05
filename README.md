# Intellex

[![N|Solid](https://0.s3.envato.com/files/133274193/intellex%20mascot.png)](https://intellex.rs/)

Wrapper for Firebase authorization.

## Features
- Facebook and Firebase authorizaation
- Google and Firebase authorization
- Phone authorization and phone verification
- Email authorization

## Requirements

- Swift 3
- min iOS 9 
- **Cocoa pods** 
-  Firebase pods :
pod 'Firebase/Auth'

pod 'FirebaseUI/Phone'

pod 'FirebaseUI/Google'

pod 'FirebaseUI/Facebook'

pod 'FirebaseUI/Auth'

> Facebook app is required before authorization.

> Google required creting configuration file and importing in app.

> conact Facebook and Google sign in documentation

## Installation

Download files and drag in into project. Install required pods files.

## Usage
**Facebook/Google**

GoogleClient.authorize(from: self, isFirebaseAuth: true) { (success) in }

FacebookClient.authorize(from: self, isFirebaseAuth: true) { (success) in }


**Email Authorization**

FirebaseAuthClient.auth(email: emailTextField.text!, password: passwordTextField.text!, success: { (success) in }


**Phone Authorization and verification**

FirebaseAuthClient.phoneAuth(phoneNumber: phoneNumber, success: { (success) in }

FirebaseAuthClient.verifyPhone(verifyCode: conformationCodeTextField.text!, success: { (success) in }


