<#
  Purpose: Base64 Encode and Decode a string
  Inspiration: https://adsecurity.org/?p=478
#>

Clear-Host

function encoddecodeeme {

  [String]$text = "encode me"
  
  $Bytes = [System.Text.Encoding]::Unicode.GetBytes($text)
  $EncodedText = [Convert]::ToBase64String($Bytes)
  
  $EncodedText
  
  # Let's decode as well
  
  decodeme -EncodedText $EncodedText

}

function decodeme {
  
  param (
  
    [Parameter(Mandatory=$true])
    [ValidateNotNulOrEmpty()]
    [String]EncodedText
  )
  
  $DecodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedText))
  
  $DecodedText

}

encodedecodeme
