//
//  UserSettings.swift
//  Helium
//
//  Created by Christian Hoffmann on 10/31/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Foundation

internal class Setting<T> {
	let key: String
	let defaultValue: T

	init(_ userDefaultsKey: String, defaultValue: T) {
		self.key = userDefaultsKey
		self.defaultValue = defaultValue
	}

	var value: T {
		get {
			return self.get()
		}
		set (value) {
			self.set(value)
		}
	}

	private func get() -> T {
		if let value = UserDefaults.standard.object(forKey: self.key) as? T {
			return value
		} else {
			// Sets default value if failed
			set(self.defaultValue)
			return self.defaultValue
		}
	}

	private func set(_ value: T) {
		UserDefaults.standard.set(value as Any, forKey: self.key)
	}
}

internal struct UserSettings {
	static let disabledMagicURLs = Setting<Bool>("disabledMagicURLs", defaultValue: false)
	static let disabledFullScreenFloat = Setting<Bool>("disabledFullScreenFloat", defaultValue: false)
	static let opacityPercentage = Setting<Int>("opacityPercentage", defaultValue: 40)
	static let homePageURL = Setting<String>("homePageURL", defaultValue: "https://cdn.rawgit.com/JadenGeller/Helium/master/helium_start.html")
}
