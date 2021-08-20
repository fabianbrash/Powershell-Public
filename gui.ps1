Clear-Host

Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
InitialDirectory = [Environment]::GetFolderPath('Desktop') 
Filter = 'Text_Files (*.txt)|*.txt'
#Filter = 'Documents (*.docx)|*.docx|SpreadSheet (*.xlsx)|*.xlsx'
}


$null = $FileBrowser.ShowDialog()

$chosenFilePath = $FileBrowser.FileName
$chosenFile = $FileBrowser.SafeFileName

$data = @(Get-Content -Path $chosenFilePath)

$data.GetType()
$data | ForEach-Object {

    $_
    
}