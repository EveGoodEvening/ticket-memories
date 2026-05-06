import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @ScaledMetric(relativeTo: .largeTitle) private var pageIconSize: CGFloat = 72

    var body: some View {
        TabView(selection: $currentPage) {
            welcomePage.tag(0)
            privacyPage.tag(1)
            getStartedPage.tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "ticket.fill")
                .font(.system(size: pageIconSize))
                .foregroundStyle(.accent)

            Text(String(localized: "onboarding.welcome.title", defaultValue: "Your Events, Your Story"))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)

            Text(String(localized: "onboarding.welcome.subtitle",
                         defaultValue: "Turn your tickets into a personal timeline of memories."))
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            Button {
                withAnimation { currentPage = 1 }
            } label: {
                Text(String(localized: "onboarding.welcome.next", defaultValue: "Next"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    private var privacyPage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "lock.shield.fill")
                .font(.system(size: pageIconSize))
                .foregroundStyle(.green)

            Text(String(localized: "onboarding.privacy.title", defaultValue: "Your Privacy Matters"))
                .font(.system(.title, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 16) {
                privacyRow(icon: "iphone", text: String(localized: "onboarding.privacy.local", defaultValue: "Your memories stay on your device."))
                privacyRow(icon: "hand.raised", text: String(localized: "onboarding.privacy.choose", defaultValue: "You choose what to import and share."))
                privacyRow(icon: "eye.slash", text: String(localized: "onboarding.privacy.noUpload", defaultValue: "Nothing is uploaded without your action."))
            }
            .padding(.horizontal, 40)

            Spacer()

            Button {
                withAnimation { currentPage = 2 }
            } label: {
                Text(String(localized: "onboarding.privacy.next", defaultValue: "Next"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    private func privacyRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 28)
                .foregroundStyle(.secondary)
            Text(text)
                .font(.body)
        }
    }

    private var getStartedPage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: pageIconSize))
                .foregroundStyle(.accent)

            Text(String(localized: "onboarding.start.title", defaultValue: "Get Started"))
                .font(.system(.title, design: .rounded, weight: .bold))

            Text(String(localized: "onboarding.start.subtitle",
                         defaultValue: "Create your first memory or import a ticket file."))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    hasCompletedOnboarding = true
                } label: {
                    Label(
                        String(localized: "onboarding.start.create", defaultValue: "Create Memory"),
                        systemImage: "plus"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button {
                    hasCompletedOnboarding = true
                } label: {
                    Label(
                        String(localized: "onboarding.start.import", defaultValue: "Import .pkpass"),
                        systemImage: "doc.badge.plus"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Button {
                    hasCompletedOnboarding = true
                } label: {
                    Text(String(localized: "onboarding.start.skip", defaultValue: "Skip for Now"))
                        .font(.subheadline)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}
