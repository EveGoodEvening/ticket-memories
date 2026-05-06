import SwiftUI
import SwiftData

struct EditMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var event: MemoryEvent

    @State private var title: String
    @State private var category: EventCategory
    @State private var startDate: Date
    @State private var hasStartDate: Bool
    @State private var endDate: Date
    @State private var hasEndDate: Bool
    @State private var venueName: String
    @State private var city: String
    @State private var country: String
    @State private var notes: String
    @State private var isFavorite: Bool

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(event: MemoryEvent) {
        self.event = event
        _title = State(initialValue: event.title)
        _category = State(initialValue: event.category)
        _startDate = State(initialValue: event.startDate ?? Date())
        _hasStartDate = State(initialValue: event.startDate != nil)
        _endDate = State(initialValue: event.endDate ?? Date())
        _hasEndDate = State(initialValue: event.endDate != nil)
        _venueName = State(initialValue: event.venueName ?? "")
        _city = State(initialValue: event.city ?? "")
        _country = State(initialValue: event.country ?? "")
        _notes = State(initialValue: event.notes ?? "")
        _isFavorite = State(initialValue: event.isFavorite)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(String(localized: "edit.titleField", defaultValue: "Event Title"), text: $title)

                    Picker(String(localized: "edit.category", defaultValue: "Category"), selection: $category) {
                        ForEach(EventCategory.allCases) { cat in
                            Label(cat.displayName, systemImage: cat.iconName)
                                .tag(cat)
                        }
                    }
                }

                Section(String(localized: "edit.dateSection", defaultValue: "Date")) {
                    Toggle(String(localized: "edit.hasDate", defaultValue: "Set Date"), isOn: $hasStartDate)
                    if hasStartDate {
                        DatePicker(
                            String(localized: "edit.startDate", defaultValue: "Start Date"),
                            selection: $startDate,
                            displayedComponents: [.date]
                        )
                        Toggle(String(localized: "edit.hasEndDate", defaultValue: "End Date"), isOn: $hasEndDate)
                        if hasEndDate {
                            DatePicker(
                                String(localized: "edit.endDate", defaultValue: "End Date"),
                                selection: $endDate,
                                in: startDate...,
                                displayedComponents: [.date]
                            )
                        }
                    }
                }

                Section(String(localized: "edit.locationSection", defaultValue: "Location")) {
                    TextField(String(localized: "edit.venue", defaultValue: "Venue"), text: $venueName)
                    TextField(String(localized: "edit.city", defaultValue: "City"), text: $city)
                    TextField(String(localized: "edit.country", defaultValue: "Country"), text: $country)
                }

                Section(String(localized: "edit.notesSection", defaultValue: "Notes")) {
                    TextField(
                        String(localized: "edit.notesPlaceholder", defaultValue: "Add notes about this memory..."),
                        text: $notes,
                        axis: .vertical
                    )
                    .lineLimit(3...8)
                }

                Section {
                    Toggle(String(localized: "edit.favorite", defaultValue: "Favorite"), isOn: $isFavorite)
                }
            }
            .navigationTitle(String(localized: "edit.title", defaultValue: "Edit Memory"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "edit.cancel", defaultValue: "Cancel")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "edit.save", defaultValue: "Save")) {
                        save()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        event.title = trimmedTitle
        event.category = category
        event.startDate = hasStartDate ? startDate : nil
        event.endDate = hasEndDate ? endDate : nil
        event.venueName = venueName.isEmpty ? nil : venueName
        event.city = city.isEmpty ? nil : city
        event.country = country.isEmpty ? nil : country
        event.notes = notes.isEmpty ? nil : notes
        event.isFavorite = isFavorite
        event.updatedAt = Date()

        dismiss()
    }
}
