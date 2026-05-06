import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(String(localized: "settings.about", defaultValue: "About")) {
                HStack {
                    Text(String(localized: "settings.appName", defaultValue: "App"))
                    Spacer()
                    Text("Ticket Memories")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text(String(localized: "settings.version", defaultValue: "Version"))
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(.secondary)
                }
            }

            Section(String(localized: "settings.privacy", defaultValue: "Privacy")) {
                Text(String(localized: "settings.privacyExplanation",
                             defaultValue: "Your memories are stored locally on your device. Nothing is uploaded unless you explicitly export and share."))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(String(localized: "settings.title", defaultValue: "Settings"))
    }
}
