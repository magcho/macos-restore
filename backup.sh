# mac backup script

function brewBackup(){
		brew list >> ./lists/brew-list.txt
}

function brewCaskBackup(){
		brew cask list >> ./lists/brewcask-list.txt
}

function masBackup(){
		mas list >> ./lists/mas-list.txt
}

brewBackup
brewCaskBackup
masBackup

