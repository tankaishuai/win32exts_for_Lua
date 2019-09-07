VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3120
   ClientLeft      =   108
   ClientTop       =   432
   ClientWidth     =   9744
   LinkTopic       =   "Form1"
   ScaleHeight     =   3120
   ScaleWidth      =   9744
   StartUpPosition =   3  '´°¿ÚÈ±Ê¡
   Begin VB.CommandButton Command1 
      Caption         =   "Execute Lua"
      Height          =   492
      Left            =   2520
      TabIndex        =   1
      Top             =   2280
      Width           =   4572
   End
   Begin VB.TextBox Text1 
      Height          =   2052
      Left            =   0
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   0
      Width           =   9732
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Dim win32exts As New win32atlsexe
    Call win32exts.exec(Text1.Text, 0)
End Sub

Private Sub Form_Load()
    Text1.Text = "win32exts.load_sym([[*]], [[*]])" + Chr(13) + Chr(10) + _
        "win32exts.MessageBoxA(nil, [[Hello Win32exts for Lua!!]], [[called in Lua]], 1)"
End Sub
