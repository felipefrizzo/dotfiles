echo ""
echo "Set OsX system defaults"
# ==============================================
# Set energy preferences
# ==============================================
IS_LAPTOP=`/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book"`
if [[ "$IS_LAPTOP" != "" ]]; then
    pmset -b sleep 20 disksleep 10 displaysleep 5 halfdim 1
    pmset -c sleep 0 disksleep 15 displaysleep 10 halfdim 1

    # Menu bar: show remaining battery time (on pre-10.8); hide percentage
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"
    defaults write com.apple.menuextra.battery ShowTime -string "YES"
else
    pmset sleep 0 disksleep 0 displaysleep 15 halfdim 1
fi

# ==============================================
# Login window
# ==============================================
# Don't show any password hints
defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

# ==============================================
# Set keyboard preferences
# ==============================================
# Enable key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
