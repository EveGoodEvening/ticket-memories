import SwiftUI
import SwiftData

struct ImportPassView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingFilePicker = false
    @State private var importResult: PassImportResult?
    @State private var importError: PassImportError?
    @State private var showingError = false

    @State private var title = ""
    @State private var category: EventCategory = .concert
    @State private var startDate = Date()
    @State private var hasStartDate = false
    @State private var venueName = ""
    @State private var city = ""
    @State private var notes = ""

    @State private var isDuplicateWarning = false

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Group {
                if importResult != nil {
                    draftForm
                } else {
                    importPrompt
                }
            }
            .navigationTitle(String(localized: "import.title", defaultValue: "Import Pass"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "import.cancel", defaultValue: "Cancel")) {
                        dismiss()
                    }
                }

                if importResult != nil {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "import.save", defaultValue: "Save")) {
                            saveMemory()
                        }
                        .disabled(!isValid)
                        .fontWeight(.semibold)
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.init(filenameExtension: "pkpass")].compactMap { $0 },
                allowsMultipleSelection: false
            ) { result in
                handleFileSelection(result)
            }
            .alert(
                String(localized: "import.error.title", defaultValue: "Import Failed"),
                isPresented: $showingError
            ) {
                Button(String(localized: "import.error.ok", defaultValue: "OK")) {}
            } message: {
                Text(importError?.errorDescription ?? String(localized: "import.error.unknown", defaultValue: "An unknown error occurred."))
            }
        }
    }

    private var importPrompt: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "ticket")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text(String(localized: "import.prompt.title", defaultValue: "Import a .pkpass File"))
                .font(.title2.weight(.semibold))

            Text(String(localized: "import.prompt.description",
                         defaultValue: "Select a .pkpass file from your device. We'll extract the event details for you to review and edit before saving."))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                showingFilePicker = true
            } label: {
                Label(
                    String(localized: "import.prompt.select", defaultValue: "Select File"),
                    systemImage: "doc.badge.plus"
                )
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Spacer()
        }
    }

    private var draftForm: some View {
        Form {
            if isDuplicateWarning {
                Section {
                    Label(
                        String(localized: "import.duplicate.warning",
                               defaultValue: "A similar pass may have been imported before. You can still save this as a new memory."),
                        systemImage: "exclamationmark.triangle"
                    )
                    .foregroundStyle(.orange)
                    .font(.subheadline)
                }
            }

            Section(String(localized: "import.draft.details", defaultValue: "Event Details")) {
                TextField(String(localized: "import.draft.title", defaultValue: "Event Title"), text: $title)

                Picker(String(localized: "import.draft.category", defaultValue: "Category"), selection: $category) {
                    ForEach(EventCategory.allCases) { cat in
                        Label(cat.displayName, systemImage: cat.iconName)
                            .tag(cat)
                    }
                }

                Toggle(String(localized: "import.draft.hasDate", defaultValue: "Set Date"), isOn: $hasStartDate)
                if hasStartDate {
                    DatePicker(
                        String(localized: "import.draft.date", defaultValue: "Date"),
                        selection: $startDate,
                        displayedComponents: [.date]
                    )
                }
            }

            Section(String(localized: "import.draft.location", defaultValue: "Location")) {
                TextField(String(localized: "import.draft.venue", defaultValue: "Venue"), text: $venueName)
                TextField(String(localized: "import.draft.city", defaultValue: "City"), text: $city)
            }

            if let result = importResult {
                Section(String(localized: "import.draft.passInfo", defaultValue: "Pass Info")) {
                    if let org = result.organizationName {
                        HStack {
                            Text(String(localized: "import.draft.org", defaultValue: "Organizer"))
                            Spacer()
                            Text(org).foregroundStyle(.secondary)
                        }
                    }
                    if let desc = result.localizedDescription {
                        HStack {
                            Text(String(localized: "import.draft.desc", defaultValue: "Description"))
                            Spacer()
                            Text(desc).foregroundStyle(.secondary).lineLimit(2)
                        }
                    }
                }
            }

            Section(String(localized: "import.draft.notesSection", defaultValue: "Notes")) {
                TextField(
                    String(localized: "import.draft.notes", defaultValue: "Add notes..."),
                    text: $notes,
                    axis: .vertical
                )
                .lineLimit(3...6)
            }
        }
    }

    private func handleFileSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            do {
                let parsed = try PassImportService.importPass(from: url)
                importResult = parsed
                prefillFromResult(parsed)
                checkDuplicate(parsed)
            } catch let error as PassImportError {
                importError = error
                showingError = true
            } catch {
                importError = .invalidFile
                showingError = true
            }
        case .failure:
            break
        }
    }

    private func prefillFromResult(_ result: PassImportResult) {
        title = result.title ?? result.organizationName ?? ""
        if let date = result.relevantDate {
            startDate = date
            hasStartDate = true
        }
    }

    private func checkDuplicate(_ result: PassImportResult) {
        guard let hash = PassImportService.computeDuplicateHash(result: result) else { return }

        let descriptor = FetchDescriptor<PassSnapshot>(
            predicate: #Predicate<PassSnapshot> { snapshot in
                snapshot.serialNumberHash != nil
            }
        )

        if let existing = try? modelContext.fetch(descriptor) {
            let combinedHash = hash
            isDuplicateWarning = existing.contains { snapshot in
                guard let sHash = snapshot.serialNumberHash,
                      let pHash = snapshot.passTypeIdentifierHash else { return false }
                let existingCombined = sHash + ":" + pHash
                return existingCombined == combinedHash || (sHash == result.serialNumberHash && pHash == result.passTypeIdentifierHash)
            }
        }
    }

    private func saveMemory() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let event = MemoryEvent(
            title: trimmedTitle,
            category: category,
            startDate: hasStartDate ? startDate : nil,
            venueName: venueName.isEmpty ? nil : venueName,
            city: city.isEmpty ? nil : city,
            notes: notes.isEmpty ? nil : notes,
            source: .pkpassFile
        )
        modelContext.insert(event)

        if let result = importResult {
            var thumbnailPath: String?
            if let thumbData = result.thumbnailData {
                thumbnailPath = try? saveThumbnail(data: thumbData)
            }

            let snapshot = PassSnapshot(
                event: event,
                organizationName: result.organizationName,
                localizedName: result.title,
                localizedDescription: result.localizedDescription,
                serialNumberHash: result.serialNumberHash,
                passTypeIdentifierHash: result.passTypeIdentifierHash,
                relevantDate: result.relevantDate,
                passURL: result.passURL,
                thumbnailImagePath: thumbnailPath,
                foregroundColor: result.foregroundColor,
                backgroundColor: result.backgroundColor,
                labelColor: result.labelColor
            )
            modelContext.insert(snapshot)
        }

        dismiss()
    }

    private func saveThumbnail(data: Data) throws -> String {
        try MediaStorageService.ensureDirectoriesExist()
        let filename = "\(UUID().uuidString)_pass.png"
        let url = MediaStorageService.mediaDirectory.appending(path: filename)
        try data.write(to: url)
        return filename
    }
}
