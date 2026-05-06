import SwiftUI
import SwiftData

struct CreateMemoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var category: EventCategory = .concert
    @State private var startDate = Date()
    @State private var hasStartDate = true
    @State private var endDate = Date()
    @State private var hasEndDate = false
    @State private var venueName = ""
    @State private var city = ""
    @State private var country = ""
    @State private var notes = ""
    @State private var isFavorite = false

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                requiredSection
                dateSection
                locationSection
                notesSection
                optionsSection
            }
            .navigationTitle(String(localized: "create.title", defaultValue: "New Memory"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "create.cancel", defaultValue: "Cancel")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "create.save", defaultValue: "Save")) {
                        save()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var requiredSection: some View {
        Section {
            TextField(String(localized: "create.titleField", defaultValue: "Event Title"), text: $title)

            Picker(String(localized: "create.category", defaultValue: "Category"), selection: $category) {
                ForEach(EventCategory.allCases) { cat in
                    Label(cat.displayName, systemImage: cat.iconName)
                        .tag(cat)
                }
            }
        }
    }

    private var dateSection: some View {
        Section(String(localized: "create.dateSection", defaultValue: "Date")) {
            Toggle(String(localized: "create.hasDate", defaultValue: "Set Date"), isOn: $hasStartDate)
            if hasStartDate {
                DatePicker(
                    String(localized: "create.startDate", defaultValue: "Start Date"),
                    selection: $startDate,
                    displayedComponents: [.date]
                )

                Toggle(String(localized: "create.hasEndDate", defaultValue: "End Date"), isOn: $hasEndDate)
                if hasEndDate {
                    DatePicker(
                        String(localized: "create.endDate", defaultValue: "End Date"),
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: [.date]
                    )
                }
            }
        }
    }

    private var locationSection: some View {
        Section(String(localized: "create.locationSection", defaultValue: "Location")) {
            TextField(String(localized: "create.venue", defaultValue: "Venue"), text: $venueName)
            TextField(String(localized: "create.city", defaultValue: "City"), text: $city)
            TextField(String(localized: "create.country", defaultValue: "Country"), text: $country)
        }
    }

    private var notesSection: some View {
        Section(String(localized: "create.notesSection", defaultValue: "Notes")) {
            TextField(
                String(localized: "create.notesPlaceholder", defaultValue: "Add notes about this memory..."),
                text: $notes,
                axis: .vertical
            )
            .lineLimit(3...8)
        }
    }

    private var optionsSection: some View {
        Section {
            Toggle(String(localized: "create.favorite", defaultValue: "Favorite"), isOn: $isFavorite)
        }
    }

    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let event = MemoryEvent(
            title: trimmedTitle,
            category: category,
            startDate: hasStartDate ? startDate : nil,
            endDate: hasEndDate ? endDate : nil,
            timezoneIdentifier: TimeZone.current.identifier,
            venueName: venueName.isEmpty ? nil : venueName,
            city: city.isEmpty ? nil : city,
            country: country.isEmpty ? nil : country,
            locationConfidence: (!venueName.isEmpty || !city.isEmpty || !country.isEmpty) ? .manual : nil,
            notes: notes.isEmpty ? nil : notes,
            source: .manual,
            isFavorite: isFavorite
        )

        modelContext.insert(event)
        dismiss()
    }
}
