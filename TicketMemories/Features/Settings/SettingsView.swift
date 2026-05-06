import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @State private var showingDeleteConfirmation = false

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
                HStack {
                    Text(String(localized: "settings.build", defaultValue: "Build"))
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                        .foregroundStyle(.secondary)
                }
            }

            Section(String(localized: "settings.privacy", defaultValue: "Privacy")) {
                Text(String(localized: "settings.privacyExplanation",
                             defaultValue: "Your memories are stored locally on your device. Nothing is uploaded unless you explicitly export and share. You choose which passes to import and which content to include in exports."))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section(String(localized: "settings.data", defaultValue: "Data")) {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Label(
                        String(localized: "settings.deleteAll", defaultValue: "Delete All Data"),
                        systemImage: "trash"
                    )
                }
            }

            #if DEBUG
            Section("Debug") {
                Button("Reset Onboarding") {
                    hasCompletedOnboarding = false
                }
            }
            #endif
        }
        .navigationTitle(String(localized: "settings.title", defaultValue: "Settings"))
        .confirmationDialog(
            String(localized: "settings.deleteConfirm.title", defaultValue: "Delete All Data?"),
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: "settings.deleteConfirm.action", defaultValue: "Delete Everything"), role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text(String(localized: "settings.deleteConfirm.message",
                         defaultValue: "This will permanently delete all memories, photos, and exports. This cannot be undone."))
        }
    }

    private func deleteAllData() {
        do {
            try modelContext.delete(model: MemoryEvent.self)
            try modelContext.delete(model: PassSnapshot.self)
            try modelContext.delete(model: MediaAsset.self)
            try modelContext.delete(model: SpotifyPlaylistLink.self)
            try modelContext.delete(model: AnnualRecap.self)
            try modelContext.delete(model: ExportArtifact.self)

            let fm = FileManager.default
            try? fm.removeItem(at: MediaStorageService.mediaDirectory)
            try? fm.removeItem(at: MediaStorageService.thumbnailDirectory)

            let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            let exportsDir = documentsURL.appending(path: "Exports")
            try? fm.removeItem(at: exportsDir)
        } catch {}
    }
}
