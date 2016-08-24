echo ""
echo "Set OsX user defaults"

# ==============================================
# Trackpad
# ==============================================
# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Tap with two fingers to emulate right click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false
# Secondary click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool false


defaults write com.apple.dock showMissionControlGestureEnabled -bool true
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.dock showDesktopGestureEnabled -bool true
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

# ==============================================
# Archive Utility
# ==============================================
# Move archives to trash after extraction
defaults write com.apple.archiveutility "dearchive-move-after" -string "~/.Trash"

# Don't reveal extracted items
defaults write com.apple.archiveutility "dearchive-reveal-after" -bool false

# ==============================================
# Finder
# ==============================================
# Expand the "Open with" and "Sharing & Permissions" panes
defaults write com.apple.finder FXInfoPanesExpanded -dict OpenWith -bool true Privileges -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show all files
defaults write com.apple.finder AppleShowAllFiles -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Use column view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# ==============================================
# Dock
# ==============================================
defaults write com.apple.dock showAppExposeGesture -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 25
defaults write com.apple.dock minimize-to-application -bool true

# ==============================================
# Safari & WebKit
# ==============================================
# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true

# Show favorites bar
defaults write com.apple.Safari ShowFavoritesBar -bool true
defaults write com.apple.Safari "ShowFavoritesBar-v2" -bool true

# New tabs open with: Empty Page
defaults write com.apple.Safari NewTabBehavior -int 4

# Homepage
defaults write com.apple.Safari HomePage -string "about:blank"

# Open pages in tabs instead of windows: automatically
defaults write com.apple.Safari TabCreationPolicy -int 1

# Command-clicking a link creates tabs
defaults write com.apple.Safari CommandClickMakesTabs -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# ==============================================
# Terminal
# ==============================================
# Set the "Pro" as the default
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

# ==============================================
# Sound
# ==============================================
# Disable user interface sound efects
defaults write NSGlobalDomain "com.apple.sound.beep.feedback" -bool true
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -bool false

# ==============================================
# Screen Capture
# ==============================================
defaults write com.apple.screencapture location -string "$HOME/Downloads"

# ==============================================
# Time Machine
# ==============================================
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ==============================================
# Applications
# ==============================================
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ==============================================
# User
# ==============================================
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
