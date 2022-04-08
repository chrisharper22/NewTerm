//
//  SettingsView.swift
//  NewTerm (iOS)
//
//  Created by Adam Demasi on 3/4/21.
//

import SwiftUI

struct SettingsView: View {

	@Environment(\.presentationMode)
	var presentationMode

	@ObservedObject var preferences = Preferences.shared

	var windowScene: UIWindowScene?

	var body: some View {
		let list = List() {
			Section(header: Text("Interface")) {
				NavigationLink(
					destination: SettingsFontView(),
					label: {
						KeyValueView(
							title: Text("Font"),
							value: Text("\(preferences.fontName), \(Int(preferences.fontSize))")
						)
					}
				)
				NavigationLink(
					destination: SettingsThemeView(),
					label: {
						KeyValueView(
							title: Text("Theme"),
							value: Text(preferences.themeName)
						)
					}
				)
			}

			#if !targetEnvironment(macCatalyst)
			Section {
				NavigationLink(
					destination: SettingsAdvancedView(),
					label: { Text("Advanced") }
				)
			}

			Section {
				NavigationLink(
					destination: SettingsAboutView(),
					label: { Text("About") }
				)
			}
			#endif
		}
			.listStyle(InsetGroupedListStyle())

#if targetEnvironment(macCatalyst)
		let finalList = list
			.navigationBarTitle("SETTINGS_MAC", displayMode: .inline)
			.navigationBarHidden(true)
#else
		let finalList = list
			.navigationBarTitle("SETTINGS", displayMode: .large)
			.navigationBarItems(trailing:
														Button(
															action: {
																if let windowScene = windowScene {
																	UIApplication.shared.requestSceneSessionDestruction(windowScene.session, options: nil, errorHandler: nil)
																} else {
																	// TODO: presentationMode seems useless when UIKit is presenting
																	// the view controller rather than SwiftUI? Ugh
																	//																	presentationMode.wrappedValue.dismiss()
																	NotificationCenter.default.post(name: RootViewController.settingsViewDoneNotification, object: nil)
																}
															},
															label: { Text(verbatim: .done).bold() }
														)
			)
#endif

		return NavigationView {
			finalList
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
