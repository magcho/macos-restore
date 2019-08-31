# mac restore shell script 

function installHomeBrew(){
		# homebrewのインストール過程でxcode command line toolsもインストールされるため、xcode単体のインストールは不要
		cd ~
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}
function restoreBrewTap(){
		while read line
		do
				brew tap $line
		done < ./lists/brewcask-list.txt
}
function restoreBrew () {
		while read line
		do
				brew install $line
		done < ./lists/brew-list.txt
}

function restoreBrewCask () {
		while read line
		do
				brew cask install $line
 		done < ./lists/brewcask-list.txt
}
function restoreAppstore () {
		while read line
		do
				mas install $(awk '{print $1}' <<<${line})
				
		done < ./lists/mas-list.txt
}

function restoreMacOSConfig(){
		# 隠しファイルを表示させる
		defaults write com.apple.finder AppleShowAllFiles -bool true
		
		# ウィンド単位のスクリーンショットで影をデフォルトでなくす
		defaults write com.apple.screencapture disable-shadow -boole true

		# dockに表示されるショートカットを起動中のみにする(要killall Dock)
		defaults write com.apple.dock static-only -bool true
}


function restoreDotfiles(){
 		dotz restore
}




# execute restore function
installHomebrew
restoreBrewTap
restoreBrew
restoreBrewCask
restoreAppstore

