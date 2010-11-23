GO_EASY_ON_ME=1
export SDKVERSION=4.0
FW_DEVICE_IP=AppleTV.local
include theos/makefiles/common.mk


CPPFLAGS = -fnested-functions 
BUNDLE_NAME = Groovy
Groovy_FILES = Classes/GroovyAppliance.mm Classes/PlayerMenuController.m Classes/SongListController.m Classes/SongAsset.m Classes/Groovy.m Classes/NSObject+SBJSON.m Classes/NSString+SBJSON.m Classes/SBJsonBase.mm Classes/SBJsonParser.mm Classes/SBJsonWriter.mm Classes/AboutController.m Classes/User.m Classes/Playlist.m Classes/PlaylistController.m Classes/NSArray-Shuffle.m Classes/AccountController.m
Groovy_INSTALL_PATH = /Applications/Lowtide.app/Appliances
Groovy_BUNDLE_EXTENSION = frappliance
Groovy_LDFLAGS =  -undefined dynamic_lookup #-L$(FW_PROJECT_DIR) -lBackRow
Groovy_RESOURCE_FILES = Resources/groovy.png Resources/ABOUT.txt Resources/Account.plist Resources/login.png Resources/music.png Resources/search.png Resources/favorite.png
include $(FW_MAKEDIR)/bundle.mk

after-install::
	install.exec "killall -9 Lowtide"
