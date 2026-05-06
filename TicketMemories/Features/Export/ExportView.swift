import SwiftUI
import SwiftData

struct EventExportButton: View {
    let event: MemoryEvent
    @State private var exportedImage: UIImage?
    @State private var showingShareSheet = false
    @State private var exportError: String?

    var body: some View {
        Button {
            exportEventCard()
        } label: {
            Label(
                String(localized: "export.eventCard", defaultValue: "Export Card Image"),
                systemImage: "square.and.arrow.up"
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = exportedImage {
                ShareSheet(items: [image])
            }
        }
    }

    @MainActor
    private func exportEventCard() {
        guard let image = ExportRenderer.renderEventCard(event: event) else {
            exportError = "Failed to render card"
            return
        }
        exportedImage = image
        showingShareSheet = true
    }
}

struct RecapExportButtons: View {
    let year: Int
    let stats: RecapStats
    let highlights: [MemoryEvent]
    let allEvents: [MemoryEvent]

    @State private var showingImageShare = false
    @State private var showingPDFShare = false
    @State private var showingPrintPDFShare = false
    @State private var exportedImage: UIImage?
    @State private var exportedPDFURL: URL?
    @State private var exportError: String?
    @State private var showingError = false
    @State private var showingOptions = false
    @State private var pdfOptions = PDFExportOptions()

    var body: some View {
        Menu {
            Button {
                exportRecapImage()
            } label: {
                Label(
                    String(localized: "export.recapImage", defaultValue: "Export Recap Image"),
                    systemImage: "photo"
                )
            }

            Button {
                exportRecapPDF()
            } label: {
                Label(
                    String(localized: "export.recapPDF", defaultValue: "Export Recap PDF"),
                    systemImage: "doc.richtext"
                )
            }

            Button {
                showingOptions = true
            } label: {
                Label(
                    String(localized: "export.printPDF", defaultValue: "Export Print-Ready PDF"),
                    systemImage: "printer"
                )
            }
        } label: {
            Label(
                String(localized: "export.button", defaultValue: "Export"),
                systemImage: "square.and.arrow.up"
            )
        }
        .sheet(isPresented: $showingImageShare) {
            if let image = exportedImage {
                ShareSheet(items: [image])
            }
        }
        .sheet(isPresented: $showingPDFShare) {
            if let url = exportedPDFURL {
                ShareSheet(items: [url])
            }
        }
        .sheet(isPresented: $showingPrintPDFShare) {
            if let url = exportedPDFURL {
                ShareSheet(items: [url])
            }
        }
        .sheet(isPresented: $showingOptions) {
            printOptionsSheet
        }
        .alert(
            String(localized: "export.error.title", defaultValue: "Export Failed"),
            isPresented: $showingError
        ) {
            Button("OK") {}
        } message: {
            Text(exportError ?? "")
        }
    }

    @MainActor
    private func exportRecapImage() {
        guard let image = ExportRenderer.renderRecapImage(stats: stats, year: year, highlights: highlights) else {
            exportError = ExportError.renderingFailed.localizedDescription
            showingError = true
            return
        }
        exportedImage = image
        showingImageShare = true
    }

    @MainActor
    private func exportRecapPDF() {
        do {
            let url = try PDFExportService.generateRecapPDF(year: year, stats: stats, events: allEvents)
            exportedPDFURL = url
            showingPDFShare = true
        } catch {
            exportError = error.localizedDescription
            showingError = true
        }
    }

    @MainActor
    private func exportPrintReadyPDF() {
        do {
            let url = try PDFExportService.generatePrintReadyPDF(year: year, stats: stats, events: allEvents, options: pdfOptions)
            exportedPDFURL = url
            showingOptions = false
            showingPrintPDFShare = true
        } catch {
            exportError = error.localizedDescription
            showingError = true
        }
    }

    private var printOptionsSheet: some View {
        NavigationStack {
            Form {
                Section(String(localized: "export.options.pageSize", defaultValue: "Page Size")) {
                    Picker(String(localized: "export.options.size", defaultValue: "Size"), selection: $pdfOptions.pageSize) {
                        Text("A4").tag(PDFExportOptions.PageSize.a4)
                        Text("Letter").tag(PDFExportOptions.PageSize.letter)
                    }
                    .pickerStyle(.segmented)
                }

                Section(String(localized: "export.options.include", defaultValue: "Include")) {
                    Toggle(String(localized: "export.options.photos", defaultValue: "Photos"), isOn: $pdfOptions.includePhotos)
                    Toggle(String(localized: "export.options.notes", defaultValue: "Notes"), isOn: $pdfOptions.includeNotes)
                    Toggle(String(localized: "export.options.map", defaultValue: "Map"), isOn: $pdfOptions.includeMap)
                    Toggle(String(localized: "export.options.spotify", defaultValue: "Spotify Link"), isOn: $pdfOptions.includeSpotifyLink)
                }
            }
            .navigationTitle(String(localized: "export.options.title", defaultValue: "Print Options"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "export.options.cancel", defaultValue: "Cancel")) {
                        showingOptions = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "export.options.export", defaultValue: "Export")) {
                        exportPrintReadyPDF()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension PDFExportOptions.PageSize: Hashable {}
