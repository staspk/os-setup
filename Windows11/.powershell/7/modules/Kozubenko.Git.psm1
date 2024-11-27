$USER_MAIL = "staspk@gmail.com"
$USER_NAME = "Stanislav Kozubenko"


function Push ($msg = "Automatic Push w/ No Message", $email = $USER_MAIL, $username = $USER_NAME) {
    git config --global user.email $email
    git config --global user.name $username
    Write-Host "works"
}






Export-ModuleMember Push