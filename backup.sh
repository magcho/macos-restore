# mac backup script

function brewBackup(){
		brew list > ./lists/brew-list.txt
}
function brewTapBackup(){
		brew tap > ./lists/brewtap-list.txt
}

function brewCaskBackup(){
		brew cask list > ./lists/brewcask-list.txt
}

function masBackup(){
		mas list > ./lists/mas-list.txt
}

function backupDotsfiles(){
		dotz backup -p
}

brewTapBackup
brewBackup
brewCaskBackup
masBackup

