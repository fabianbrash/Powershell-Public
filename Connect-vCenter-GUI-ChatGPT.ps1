# Load the Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms

# Create form and add elements
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(300,200)
$form.Text = "vCenter Login"

$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,20)
$label1.Size = New-Object System.Drawing.Size(100,20)
$label1.Text = "vCenter Server:"
$form.Controls.Add($label1)

$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(120,20)
$textBox1.Size = New-Object System.Drawing.Size(150,20)
$form.Controls.Add($textBox1)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,50)
$label2.Size = New-Object System.Drawing.Size(100,20)
$label2.Text = "Username:"
$form.Controls.Add($label2)

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(120,50)
$textBox2.Size = New-Object System.Drawing.Size(150,20)
$form.Controls.Add($textBox2)

$label3 = New-Object System.Windows.Forms.Label
$label3.Location = New-Object System.Drawing.Point(10,80)
$label3.Size = New-Object System.Drawing.Size(100,20)
$label3.Text = "Password:"
$form.Controls.Add($label3)

$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = New-Object System.Drawing.Point(120,80)
$textBox3.Size = New-Object System.Drawing.Size(150,20)
$textBox3.PasswordChar = "*"
$form.Controls.Add($textBox3)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100,120)
$button.Size = New-Object System.Drawing.Size(75,23)
$button.Text = "Login"
$button.Add_Click({
    try {
        Connect-VIServer -Server $textBox1.Text -User $textBox2.Text -Password $textBox3.Text -ErrorAction Stop
        $form.Close()
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Login failed, check credentials and try again.","Error",0,[System.Windows.Forms.MessageBoxButtons]::OK)
    }
})
$form.Controls.Add($button)

# Show form
$form.ShowDialog()
