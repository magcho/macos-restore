#!/bin/zsh
# mac restore shell script

restoreBrewTap () {
		while read line
		do
				brew tap $line
		done < ./lists/brewtap-list.txt
}
restoreBrew () {
		while read line
		do
				brew install $line
		done < ./lists/brew-list.
}
restoreBrewCask () {
		while read line
		do
				brew cask install $line
 		done < ./lists/brewcask-list.txt
}
restoreAppstore () {
		while read line
		do
				mas install $(awk '{print $1}' <<<${line})
		done < ./lists/mas-list.txt
}

restoreMacOSConfig () {
		# 隠しファイルを表示させる
		defaults write com.apple.finder AppleShowAllFiles -bool true
		# ライブラリーディレクトリを表示させる
		chflags nohidden ~/Library
		# finderの初期表示ディレクトリをダウンロードにする
		defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"
		# finderのパスバーにフルパスを表示する
		defaults write com.apple.finder ShowPathbar -bool true
		
		killall Finder

		# ウィンド単位のスクリーンショットで影をデフォルトでなくす
		defaults write com.apple.screencapture disable-shadow -boole true

		# dockに表示されるショートカットを起動中のみにする(要killall Dock)
		defaults write com.apple.dock static-only -bool true
		# dockを自動的に隠す
		defaults write com.apple.dock autohide -bool true
		# dockのアイコンサイズ変更
		defaults write com.apple.dock tilesize -int 30
		# dockを左に
		defaults write com.apple.Dock orientation -string left
		
		killall Dock
}





main(){
		echo '# Start restore'
		
		DOTZ_REPO_URL='https://github.com/magcho/.dotz'
		DOTZ_ROOT_DIR=${DOTZ_ROOT:-"${HOME}/.dotz"}
		
		cd ${HOME}

		if  [ ! type zplug > /dev/null 2>&1 ] && [ $SHELL = '/bin/zsh' ]; then
				echo '# Install zplug'
				curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
		fi

		if [ "$(uname)" = 'Darwin' ]; then
				if ! ( type brew > /dev/null 2>&1 ); then
						echo '# Install homebrew'
						/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
				fi
				
				if  [ ! -d "${HOME}/.dotz" ] || [ ! -n "${DOTZ_ROOT}" ]; then
						echo '# Clone my dotfiles repo'
						git clone ${DOTZ_REPO_URL} ${DOTZ_ROOT_DIR}
				fi

				
				if [ type dotz > /dev/null 2>&1 ]; then
						echo '# Install Dotz'
						brew tap magcho/magcho
						brew install dotz
				fi
				
				if [ -d "${HOME}/.dotz" ] || [ -v DOTZ_ROOT ]; then
						echo '# Restore dotfiles'
						dotz restore
				fi
		fi

		if [ -f "${HOME}/brew-ist.txt" ]; then
				echo '# Restore brew comands'
				restoreBrew
		fi

		if [ -f "${HOME}/brewcask-list.txt" ]; then
				echo '# Restore brew cask apps'
				restoreBrewCask
		fi

		if [ -f "${HOME}/mas-list.txt" ]; then
				echo '# Restore mas apps'
				restoreAppstore
		fi

		if [ ! -f '/Users/bigsur/Library/Fonts/SFMonoSquare-Regular.otf' ]; then
				echo '# Generate programing font'
				brew tap delphinus/sfmono-square
				brew install sfmono-square
				echo "# Generated $(brew --prefix sfmono-square)/share/fonts"
				open "$(brew --prefix sfmono-square)/share/fonts"
		fi

		if [ "$(uname)" = 'Darwin' ]; then
				echo '# Set for system prefernces'
				restoreMacOSConfig
		fi
}

main
