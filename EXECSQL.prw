#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include "HBUTTON.CH"
#include 'apwizard.ch'
//#include 'apsdu.ch'

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//User Function Espnome()
//Return("U_EXECSQL")

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Funcao para executar um sql e apresentar na tela e salvar em excel
/*/
User Function EXECSQL()
//	SIGAESP(1)
//Return
//User Function SigaESP()
// prepara o ambiente para possiblitar chamar a funcao direto pelo smartclient

//Private oMainWnd  := NIL

Private _cNReg  := ""
Private _cNTime  := ""
Private _cTimeI  := "" // hora inicial 
Private _cTimeF  := "" // hora final

Private oMsgItem
Private oMsgVer
Private oMsgRec
Private oMsgRdd
Private oMsgSts

Private _cRdd := RddSetDefault()

Private oFCour14 := TFont():New("Courier New",,14,,.T.,,,,,.F.,.F.)

Private tela

Private cSelect := ""
Private aGridRes := {""}

Private oSelect
Private oSplit
Private oPanel1
Private oResultado
Private cResultado := ""

Private oGridRes
Private aoGridRes := {}
Private _cAlias := "ARQ_TRB_ZZZ" //GetNextAlias()
Private oTab
Private _oNReg
//Private _cNReg := ""

//Private _lFW := FindFunction("FWMsgRun")


Private oProcess  := NIL
Private _cVersao := GetSRVProfString("RPOVERSION", "INVALIDO")
Private _cDbExt := GetSRVProfString("localdbextension", ".dbf")

Private _lP11 := IIf(_cVersao >= "11" , .T. , .F.)

Private _aScrRes := GetScreenRes()
Private dDataBase := MsDate()

//SigaMDI( "par01", "par02" )

//Alert(_cRDD)

SetFlatControls(.F.)
//*/
MsApp():New('SIGAFAT')
//oApp:cInternet := Parameter01
oApp:CreateEnv()
oApp:bMainInit := {|| fMainApp() }
oApp:bAppStart := {|| fIniApp() }
//oApp:bMainInit := {|| oApp:lFlat := .T.,PtSetTheme("MDI"),FinalMessage(APSDU_BUILD),oMainWnd:bValid := bValid,SDUAbertura()}
//oApp:lMenu := .F.
//oApp:lMenuBmp := .F.
//oApp:lShortCut := .F.
//oApp:lMessageBar := .T.
//oApp:lMainToolBar := .F.
//oApp:lIBrowser := .F.
oApp:cModDesc	:= "Full_Name"
oApp:cModulo	:= "Module_name" 

//Alert(VarInfo("oApp", ClassMethArr(oApp) ))
//Aviso( "tst", fRetHTML(ClassMethArr(oApp)) ,{"ok"} , 3 )

ptSetTheme("MDI")
//Seta Atributos 
__lInternet := .T.

oApp:Activate()
//oApp:RunApp( .T. )
//*/

fMainApp()

SetKey(VK_F1, {||})
SetKey(VK_F2, {||})
SetKey(VK_F5, {||})
SetKey(K_ALT_F1, {||})

Return

/*/
@author: caiocrol
@data: 30/10/2015
@descricao: 
/*/
Static Function fMainApp()
	//oApp:lFlat := .T.
	
	If fConect()
		/*
		If ( lOpen := MyOpenSm0(.T.) )
			SM0->(dbGoTop())
			
			// se encontrar empresa teste utiliza ela pra setar o ambiente
			If !SM0->( dbSeek("9901") )
				SM0->(dbGoTop())
			EndIf
			Alert(SM0->M0_CODIGO)
			
			// RpcSetType( 3 )
			// RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
			//*/
			
			fMainFun()
		//EndIf
		
	EndIf
Return nil

/*/
@author: caiocrol
@data: 30/10/2015
@descricao: 
/*/
Static Function fIniApp()
Return nil


/*/
@author: caiocrol
@data: 05/10/2015
@descricao: funcao que conecta no banco
/*/
Static Function fConect()
Local oDlg
Local oOk
Local oCancel
Local oServer
Local oDatabase
Local cIniFile := GetADV97()
Local lReturn := .F.                                  
Local oPort

Local _cDataBase := GetPvProfString("TOPCONNECT","DATABASE","ERROR",cInIfile )
Local _cAlias    := GetPvProfString("TOPCONNECT","ALIAS","ERROR",cInIfile )
Local _cServer   := GetPvProfString("TOPCONNECT","SERVER","ERROR",cInIfile )
Local _nPort     := GetPvProfString("TOPCONNECT","PORT","ERROR",cInIfile )

If _cServer = "ERROR"
	_cServer   := GetPvProfString("DBACCESS","SERVER","ERROR",cInIfile)
	If _cServer = "ERROR"
		_cServer   := GetSrvProfString("TOPSERVER",_cServer)
		If _cServer = "ERROR"
			_cServer   := GetSrvProfString("DBSERVER",_cServer)
		EndIf
	EndIf
EndIf

If _cDataBase = "ERROR"
	_cDataBase   := GetPvProfString("DBACCESS","DATABASE","ERROR",cInIfile)
	If _cDataBase = "ERROR"
		_cDataBase   := GetSrvProfString("TOPDATABASE",_cDataBase)
		If _cDataBase = "ERROR"
			_cDataBase   := GetSrvProfString("DBDATABASE",_cDataBase)
		EndIf
	EndIf
EndIf

If _cAlias = "ERROR"
	_cAlias   := GetPvProfString("DBACCESS","ALIAS","ERROR",cInIfile)
	If _cAlias = "ERROR"
		_cAlias   := GetSrvProfString("ALIAS",_cAlias)
		If _cAlias = "ERROR"
			_cAlias   := GetSrvProfString("DBALIAS",_cAlias)
		EndIf
	EndIf
EndIf

If _nPort = "ERROR"
	_nPort   := GetPvProfString("DBACCESS","PORT","ERROR",cInIfile)
	If _nPort = "ERROR"
		_nPort   := GetSrvProfString("TOPPORT",_nPort)
		If _nPort = "ERROR"
			_nPort   := GetSrvProfString("DBPORT",_nPort)
		EndIf
	EndIf
EndIf

/*
	 := GetPvProfString("DBACCESS","DATABASE","ERROR",cInIfile)
	    := GetPvProfString("DBACCESS","ALIAS","ERROR",cInIfile )
	     := Val(GetPvProfString("DBACCESS","PORT","",cInIfile )) 

If _cServer = "ERROR"
	// Ajuste pelo Environment do Server
	_cDataBase := GetSrvProfString("TOPDATABASE",_cDataBase)
	_cAlias    := GetSrvProfString("ALIAS",_cAlias)
	_cServer   := GetSrvProfString("TOPSERVER",_cServer)
	_nPort     := Val(GetSrvProfString("TOPPORT",Str(_nPort)))
EndIf

If _cServer = "ERROR"
	// Ajuste pelo Environment do Server
	_cDataBase := GetSrvProfString("DBDATABASE",_cDataBase)
	_cAlias    := GetSrvProfString("DBALIAS",_cAlias)
	
	_nPort     := Val(GetSrvProfString("TOPPORT",Str(_nPort)))
EndIf
*/
_cDataBase += "/" + _cAlias
_cDatabase := Padr(_cDatabase,50)
_cServer	  := Padr(_cServer,50)

_nPort := Val(_nPort)

If _nPort == 0
	_nPort := 7890
EndIf

DEFINE MSDIALOG oDlg FROM 000,000 TO 170,316 PIXEL TITLE "Connect as..." OF oMainWnd STYLE DS_MODALFRAME

@ 003,005 SAY "Server" SIZE 060,007 OF oDlg PIXEL

@ 012,005 GET oServer VAR _cServer PICTURE "@!" SIZE 150,009 PIXEL

@ 024,005 SAY "DBMS/Data Base" SIZE 060,007 OF oDlg PIXEL

@ 033,005 GET oDatabase VAR _cDatabase PICTURE "@!" SIZE 150,009 OF oDlg PIXEL

@ 045,005 SAY "Port" SIZE 060,007 OF oDlg PIXEL

@ 054,005 GET oPort VAR _nPort SIZE 150,009 OF oDlg PIXEL

DEFINE SBUTTON oOk FROM 070,097 TYPE 1 ENABLE OF oDlg PIXEL;
	WHEN (!Empty(_cServer) .And. !Empty(_cDatabase));
	ACTION ( lReturn := fTcLink( _cDatabase , _cServer , _nPort ) , oDlg:End() )

DEFINE SBUTTON oCancel FROM 070,127 TYPE 2 ENABLE OF oDlg PIXEL;
	ACTION ( oDlg:End(), lReturn:=.F.)

ACTIVATE MSDIALOG oDlg CENTERED

Return lReturn

/*/
@author: caiocrol
@data: 05/10/2015
@descricao: tclink com a base
/*/
Static Function fTcLink( _cDBAlias , _cServer , _nPort )
	
	Local _lRet := .F.
	Local _ndbIni := AdvConnection()
	
	If ValType(_ndbIni) = "N" .and. _ndbIni >= 0
		TCUnLink(_ndbIni)
	EndIf
	
	_nLinkDB := TCLink( AllTrim(_cDBAlias) , AllTrim(_cServer) , _nPort)
	
	If !TCSetConn(_nLinkDB) // SETANDO CONEXAO COM BANCO DE DADOS
		Alert( "Sem Conexao com a base de dados, Erro: " + cValToChar(_nLinkDB) )
		Return _lRet
	Else
		_lRet := .T.
	EndIf
	
Return _lRet

/*/
@author: caiocrol
@data: 05/10/2015
@descricao: funcao principal
/*/
Static Function fMainFun()
//Local _nAltura := oMainWnd:nClientHeight
//Local _nLargura := oMainWnd:nClientWidth
//
//Local _nAltD  := _nAltura  * 0.9
//Local _nLargD := _nLargura * 0.93
//
//Local _nAltS  := _nAltura  * 0.413
//Local _nLargS := _nLargura * 0.457

Local _aCoor := MsAdvSize(.T.)

Local _nVSub := 90
Local _nHSub := 10

//Local _aCoor := { 0, 0 , (_aScrRes[1] - _nHSub) / 2 , (_aScrRes[2]- _nVSub) / 2, (_aScrRes[1]- _nHSub) , (_aScrRes[2]- _nVSub), 0 }

// 192 x 1080
//Local _aCoor := { 0, 0 , 929, 426, 1858, 875, 0 }
// 1600 x 900
//Local _aCoor := { 0, 0 , 769, 336, 1538, 695 , 0 }

Local _a1 := {_aCoor[1],_aCoor[2],_aCoor[3],_aCoor[4],3,3}
Local _a2 := { {37,12,.F.,.F.,.T.} , {200,200,.T.,.T.,.T.} }
Local _aObj := MsObjSize(_a1 , _a2 , .T. , .F. )

Local oMenu
Local oBClose
Local oBExcel
Local oBExCSV
Local oBExDBF
Local oOpeDBF
Local oBExec
Local oBLimpar
Local oBOpenSql
Local oBSalvSql
Local oBImpCSV
Local oBCpyFil
Local oBHelp
Local oBTCSQL

Local oFCour18 := TFont():New("Courier New",,018,,.T.,,,,,.F.,.F.)

//DEFINE MSDIALOG tela TITLE "SELECT" FROM 006, 000  TO _aCoor[6],_aCoor[5] COLORS 0, 16777215 OF oMainWnd STYLE nOR(WS_VISIBLE,WS_POPUP) pixel
/*/
oMenu := TMenu():New(0,0,0,0,.T.,,oMainWnd)

// Adiciona item ao menu principal   
oMenuDiv := TMenuItem():New2( oMenu:Owner(),'&Arquivo','',,,)
oMenu:Add( oMenuDiv )  

// Adiciona sub-Itens                
oMenuItem1 := TMenuItem():New2( oMenu:Owner(),'Executar (F5)',,,{|| PROCESSA( {|lFim| fExecSql(@lFim) }, "Aguarde" , "Executando select...", .T. ) })   
oMenuDiv:Add( oMenuItem1 )                             
oMenuItem2 := TMenuItem():New2( oMenu:Owner(),'Limpar',,, {|| fLimpar() })   
oMenuDiv:Add( oMenuItem2 )
/*/

//Private _lFW := FindFunction("FwStyleDialog")

//tela:lMaximized := .T.
//tela:SetColor(CLR_BLACK,CLR_WHITE) 
//oLayout1:= tFlowLayout():New(oMainWnd,CONTROL_ALIGN_ALLCLIENT,0,0)
//oLayout1:SetColor(,CLR_BLUE)

// diferenca de posicao horizontal entre cada botao: 40
@ _aObj[1,1], 005 BUTTON oBExec    PROMPT "Executar (F5)"      /*ACTION( fExecSql()  )*/ SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 045 BUTTON oBLimpar  PROMPT "Limpar"               ACTION( fLimpar()   )   SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 085 BUTTON oBSalvSql PROMPT "Salvar sql"           ACTION( fSalvSql()  )   SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 125 BUTTON oBOpenSql PROMPT "Abrir sql"            ACTION( fOpenSql()  )   SIZE 037, 012 OF oMainWnd PIXEL

@ _aObj[1,1], 165 BUTTON oBExcel   PROMPT "Salvar Excel (xml)" /*ACTION( fExcel()    )*/ SIZE 055, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 225 BUTTON oBExCSV   PROMPT "Salvar Excel (csv)" /*ACTION( fExcel()    )*/ SIZE 055, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 285 BUTTON oOpeDBF   PROMPT "Abrir "+_cDbExt         /*ACTION( fExcel()    )*/ SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 325 BUTTON oBExDBF   PROMPT "Salvar "+_cDbExt        /*ACTION( fExcel()    )*/ SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 365 BUTTON oBImpCSV  PROMPT "Import csv"           ACTION( fImpCSV()   )   SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 405 BUTTON oBCpyFil  PROMPT "Copiar Arquivo"       ACTION( fCopyFile() )   SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 445 BUTTON oBHelp    PROMPT "Help"                 ACTION( fHelp()     )   SIZE 037, 012 OF oMainWnd PIXEL
@ _aObj[1,1], 485 BUTTON oBTCSQL   PROMPT "TCSqlExec()"          ACTION( fTcSqlExec())   SIZE 037, 012 OF oMainWnd PIXEL

@ _aObj[1,1], _aObj[2,3] - 40 BUTTON oBClose   PROMPT "Fechar"               ACTION( oMainWnd:End() )   SIZE 037, 012 OF oMainWnd PIXEL

oBExec:SetCSS( CSSBOTAO )
oBLimpar:SetCSS( CSSBOTAO )
oBSalvSql:SetCSS( CSSBOTAO )
oBOpenSql:SetCSS( CSSBOTAO )
oBExcel:SetCSS( CSSBOTAO )
oBExCSV:SetCSS( CSSBOTAO )
oOpeDBF:SetCSS( CSSBOTAO )
oBExDBF:SetCSS( CSSBOTAO )
oBClose:SetCSS( CSSBOTAO )
oBImpCSV:SetCSS( CSSBOTAO )
oBCpyFil:SetCSS( CSSBOTAO )
oBHelp:SetCSS( CSSBOTAO )
oBTCSQL:SetCSS( CSSBOTAO )

@ _aObj[1,1], _aObj[2,3] - 120 MSGET _oNReg VAR _cNReg SIZE 120, 010 OF oMainWnd COLORS 0, 16777215 READONLY PIXEL

If _lP11
	oBImpCSV:bAction := {|| FWMsgRun( /* Obj_oMainWnd */ , {|oSay| fImpCSV() } , "Aguarde" , "Importando csv..." ) }
Else
	oBImpCSV:bAction := {|| MsgRun ( "Aguarde", "Importando csv..." , {|| fImpCSV() } ) }
EndIf

oBExec:bAction := {|| PROCESSA( {|lFim| fExecSql(@lFim) }, "Aguarde" , "Executando select...", .T. ) }
/*
If _lP11
	oBExec:bAction := {|| FWMsgRun(  , {|oSay| fExecSql() } , "Aguarde" , "Executando select..." ) }
Else
	oBExec:bAction := {|| MsgRun ( "Aguarde", "Executando select..." , {|| fExecSql() } ) }
EndIf
*/

SetKey(VK_F1, oBHelp:bAction )
SetKey(VK_F2, {||MapColor()} )
SetKey(VK_F5, oBExec:bAction )
SetKey(K_ALT_F1, {|| fAltF1() })

If _lP11
	oBExcel:bAction := {|| FWMsgRun( /* Obj_oMainWnd */ , {|oSay| fExcel() } , "Aguarde" , "Gerando Excel XML..." ) }
Else
	oBExcel:bAction := {|| MsgRun ( "Gerando Excel XML...", "Aguarde" , {|| fExcel() } ) }
EndIf

If _lP11
	oBExCSV:bAction := {|| FWMsgRun( /* Obj_oMainWnd */ , {|oSay| fExCSV()() } , "Aguarde" , "Gerando Excel CSV..." ) }
Else
	oBExCSV:bAction := {|| MsgRun ( "Gerando Excel CSV...", "Aguarde" , {|| fExCSV() } ) }
EndIf

If _lP11
	oBExDBF:bAction := {|| FWMsgRun( /* Obj_oMainWnd */ , {|oSay| fGerDBF() } , "Aguarde" , "Gerando "+_cDbExt ) }
Else
	oBExDBF:bAction := {|| MsgRun ( "Gerando "+_cDbExt, "Aguarde" , {|| fGerDBF() } ) }
EndIf

If _lP11
	oOpeDBF:bAction := {|| FWMsgRun( /* Obj_oMainWnd */ , {|oSay| fOpenDbf() } , "Aguarde" , "Abrindo "+_cDbExt ) }
Else
	oOpeDBF:bAction := {|| MsgRun ( "Abrindo "+_cDbExt, "Aguarde" , {|| fOpenDbf() } ) }
EndIf

/*
_aButtons := {}
Aadd(_aButtons, {"", {||  }, "Salvar Excel (xml)", } )
Aadd(_aButtons, {"", {||  }, "Salvar Excel (csv)", } )
Aadd(_aButtons, {"", {||  }, "Abrir dbf "        , } )
Aadd(_aButtons, {"", {||  }, "Salvar dbf "       , } )
Aadd(_aButtons, {"", {||  }, "Import csv"        , } )
Aadd(_aButtons, {"", {||  }, "Copiar Arquivo"    , } )
Aadd(_aButtons, {"", {||  }, "Help"              , } )
Aadd(_aButtons, {"", {||  }, "TCSqlExec()"       , } )

//EnchoiceBar(oMainWnd, {||  }, {|| oMainWnd:End() },,@_aButtons,,,.F.,.F.,.F.,.F.,.F.)
*/

// TTSplitter size: largura , altura
//@ 020, 003 SPLITTER oSplit SIZE _nLargS, _nAltS OF oMainWnd ORIENTATION 1 PIXEL
@ _aObj[2,1], _aObj[2,2] SPLITTER oSplit SIZE _aObj[2,3], _aObj[2,4] OF oMainWnd ORIENTATION 1 PIXEL

//TTMultiGet
//@ 000, 000 GET oSelect VAR cSelect OF oSplit MULTILINE SIZE 291, 082 COLORS 0, 16777215 FONT oFCour18 HSCROLL PIXEL
oSelect := TSimpleEditor():Create( oSplit )
oSelect:oFont := oFCour14
oSelect:TextFormat(1)
/* Rafael Karczevski 17/07/2020 */
//oSelect:bChanged := {|| MapColor() } 
// oSelect:TextFamily( "Courier New" )
// oSelect:TextSize( 8 )


//@ 000, 000 GET oSelect VAR cSelect1 OF oSplit MULTILINE SIZE 291, 082 COLORS 0, 16777215 FONT oFCour18 HSCROLL PIXEL
//@ 000, 000 GET oSelect VAR cSelect2 OF oSplit MULTILINE SIZE 291, 082 COLORS 0, 16777215 FONT oFCour18 HSCROLL PIXEL

@ 018, 003 MSPANEL oPanel1 SIZE 168, 122 OF oSplit COLORS 0, 16777215 RAISED 

//oSelect:EnableVScroll(.T.)
//oSelect:EnableHScroll(.T.)

oSelect:Align := CONTROL_ALIGN_ALLCLIENT
oPanel1:Align := CONTROL_ALIGN_ALLCLIENT

//ACTIVATE MSDIALOG tela centered

//SET MESSAGE OF oMainWnd TO GetVersao() NOINSET FONT AdvFont

/* ERRO P12
DEFINE MSGITEM oMsgVer	OF oMainWnd:oMsgBar PROMPT GetVersao()	SIZE 200
DEFINE MSGITEM oMsgRec	OF oMainWnd:oMsgBar PROMPT _cNReg	SIZE 100
DEFINE MSGITEM oMsgSts	OF oMainWnd:oMsgBar PROMPT "" 		SIZE 100
*/

//DEFINE MSGITEM oMsgRdd	OF oMainWnd:oMsgBar PROMPT '2' 		SIZE 170
//DEFINE MSGITEM oMsgItem	OF oMainWnd:oMsgBar PROMPT "teste" SIZE 080

Return

/*/{Protheus.doc} fAltF1
consulta campos da tabela selecionada
@author MainLegion
@since 22/10/2019
@return return, return_description
/*/
Static Function fAltF1()
	Local _cTab := ""
	Local _cAlTab := "ALT_F1_TAB"
	Local _aStruct := {}
	Local _oDlg
	Local oFiltro
	Local _cFiltro := Space(100)
	Local oOk
	Local _aCoor, _a1, _a2, _aObj, _oGridStr, oPesq
	
	Local oError
	Local bError         := { |e| oError := e , Break(e) }
	Local bErrorBlock
	Local _cError := ""
	
	Private _aStruBkp := {}
	
	If ValType(oError) = "O"
		oError:FreeChildren()
		FreeObj(oError)
	EndIf
	
	bErrorBlock    := ErrorBlock( bError )
	
	Begin Sequence
		oSelect:TextFormat(2) // FORMATA COMO TEXTO NORMAL
		If !Empty(oSelect:RetTextSel())
			_cTab := oSelect:RetTextSel()
		Else
			_cTab := oSelect:RetText()
		EndIf
		
		If ("six" $ Lower(_cTab) .OR. "sx" $ Lower(_cTab)) .and. (!".dbf" $ Lower(_cTab) .AND. !".dtc" $ Lower(_cTab))
			_cTab += _cDbExt
		EndIf

		Do Case
			Case (At(".dbf", Lower(_cTab)) > 0)
				_cRDD := "DBFCDX"
			Case (At(".dtc", Lower(_cTab)) > 0)
				_cRDD := "CTREECDX"
			OtherWise
				_cRDD := "TOPCONN"
				If !TCCanOpen(_cTab)
					MsgAlert("Tabela "+_cTab+" n�o encontrada.")
					Return
				EndIf
		EndCase
		
		If Select(_cAlTab) > 0
			(_cAlTab)->(dbClosearea())
		Endif
		
		DbUseArea(.T., _cRDD, _cTab , _cAlTab, .F., .F.)
		
		_aStruct := (_cAlTab)->(dbStruct())
		_aStruBkp := aClone(_aStruct)
		
		If Select(_cAlTab) > 0
			(_cAlTab)->(dbClosearea())
		Endif
		
		If !Empty(_aStruct)
			// primeiro parametro identifica se a janela tera ou  nao uma enchoice
			_aCoor := MsAdvSize(.F.)
			_aCoor[5] := 600
			_aCoor[6] := 500
			_aCoor[3] := _aCoor[5] / 2
			_aCoor[4] := _aCoor[6] / 2
			_a1 := {_aCoor[1],_aCoor[2],_aCoor[3],_aCoor[4],3,3}
			_a2 := { {37,12,.F.,.F.,.T.} , {200,200,.T.,.T.,.T.}, {37,12,.F.,.F.,.T.} }
			_aObj := MsObjSize(_a1 , _a2 , .T. , .F. ) // ultimo par: .T. -> Horizontal, .F.-> vertical
						
			
			DEFINE MSDIALOG _oDlg FROM 000,000 TO _aCoor[6],_aCoor[5] PIXEL TITLE "Estrutura" OF oMainWnd
			@ _aObj[1,1],_aObj[1,2] SAY "Filtrar" SIZE _aObj[1,3],_aObj[1,4] OF _oDlg PIXEL
			@ _aObj[1,1],_aObj[1,2] + _aObj[1,3] GET oFiltro VAR _cFiltro SIZE 150,009 PIXEL
			@ _aObj[1,1],_aObj[1,2] + _aObj[1,3] + 155 BUTTON oPesq PROMPT ">>" SIZE 014, 012 Action(fPesqStr(_aStruct, _cFiltro, _oGridStr)) OF _oDlg PIXEL
			
			_oGridStr := MsBrGetDBase():New( _aObj[2,1],_aObj[2,2],_aObj[2,3],_aObj[2,4],,/*_aHeader*/,/*_aSize*/, _oDlg,,,,,,,,,,,, .F., "", .T.,, .F.,,, )
			_oGridStr:SetArray(_aStruct)
			_oGridStr:bLDblClick := {|| CopytoClipboard(_aStruct[_oGridStr:nAt,1]), MsgInfo("Copiado para area de trabalho"), _oDlg:End() }
			
			_oGridStr:AddColumn(TCColumn():New("Campo"		, { || _aStruct[_oGridStr:nAt,1] } ,,,,"LEFT"/*,,.F.,.F.,,,,.F.,*/))
			_oGridStr:AddColumn(TCColumn():New("Tipo"		, { || _aStruct[_oGridStr:nAt,2] } ,,,,"LEFT"/*,,.F.,.F.,,,,.F.,*/))
			_oGridStr:AddColumn(TCColumn():New("Tamanho"	, { || _aStruct[_oGridStr:nAt,3] } ,,,,"LEFT"/*,,.F.,.F.,,,,.F.,*/))
			_oGridStr:AddColumn(TCColumn():New("Decimal"	, { || _aStruct[_oGridStr:nAt,4] } ,,,,"LEFT"/*,,.F.,.F.,,,,.F.,*/))
			
			DEFINE SBUTTON oOk FROM _aObj[3,1],_aObj[3,2] TYPE 1 ENABLE OF _oDlg PIXEL ACTION ( CopytoClipboard(_aStruct[_oGridStr:nAt,1]), MsgInfo("Copiado para area de trabalho"), _oDlg:End() )
			DEFINE SBUTTON oCancel FROM _aObj[3,1],_aObj[3,2] + 40 TYPE 2 ENABLE OF _oDlg PIXEL ACTION ( _oDlg:End(), lReturn:=.F.)
			ACTIVATE MSDIALOG _oDlg CENTERED
		EndIf
		
	Recover
		//_cError := oError:Description
		_cError := SubStr(oError:Description, RAt("Error :" , oError:Description ) , Len(oError:Description) ) // + CRLF + CRLF
		//_cError += oError:ErrorStack
		
		//cSelect1 := VarInfo("Prop" , oError)
		
		Aviso( "Erro", _cError ,{"OK"} , 3 )
	End Sequence
Return nil

/*/{Protheus.doc} fPesqStr
Pesquisa o campo no array de estrutura
@author MainLegion
@since 22/10/2019
@param _aStruct, , descricao
@param _cFiltro, , descricao
@param _oGridStr, , descricao
@return return, return_description
/*/
Static Function fPesqStr(_aStruct, _cFiltro, _oGridStr)
	Local _nx := 0
	Local _aResult := {} 
	
	If Empty(_cFiltro)
		_aStruct := aClone(_aStruBkp)
		_oGridStr:SetArray(_aStruct)
		_oGridStr:DrawSelect()
		_oGridStr:nAt := 1
		Return
	EndIf
	
	For _nx:= 1 to Len(_aStruBkp)
		If Upper(Alltrim(_cFiltro)) $ _aStruBkp[_nx,1]
			Aadd(_aResult, _aStruBkp[_nx])
		EndIf
	Next
	
	If Empty(_aResult)
		MsgAlert("N�o encontrado")
	Else
		_aStruct := _aResult
		_oGridStr:SetArray(_aStruct)
		_oGridStr:DrawSelect()
		_oGridStr:nAt := 1
	EndIf
Return

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Executa o sql
/*/
Static Function fExecSql(lFim)

	Local _nIniDbf := 0
	Local _nFimDbf := 0
	Local _cDbfFile := 0
	
	Local oError
	Local bError         := { |e| oError := e , Break(e) }
	Local bErrorBlock
	Local _cError := ""
	
	If ValType(oError) = "O"
		oError:FreeChildren()
		FreeObj(oError)
	EndIf
	
	bErrorBlock    := ErrorBlock( bError )
	
	_cTimeI := Time()
	
	// auto salva o sql toda vez que for executar o sql
	fAutoSave()
	
	Begin Sequence
	
		//If ValType(oGridRes) = "O"
			//oGridRes:DeActivate(.T.)
		//EndIf
		
		//Alert(cSelect)
		//_cSql := fConvSQL(cSelect)
		oSelect:TextFormat(2) // FORMATA COMO TEXTO NORMAL
		//Aviso( "SQL", oSelect:RetText() ,{"OK"} , 3 )
		//Aviso( "SQL", oSelect:RetText() ,{"OK"} , 3 )
		//Alert(oSelect:RetTextSel())
		
		If !Empty(oSelect:RetTextSel())
			_cSql := fConvSQL( StrTran( oSelect:RetTextSel() , "?" , " " ) )
		Else
			_cSql := fConvSQL(oSelect:RetText())
		EndIf
		
		oSelect:TextFormat(1)
		
		//Alert(_cSql)
		
		//_cSql += cSelect
		
		If Select(_cALias) > 0
			(_cALias)->(dbClosearea())
		Endif
		
		_cSql := StrTran(_cSql , Chr(10) , " ")
		_cSql := StrTran(_cSql , Chr(13) , " ")
		
		// trativa para abrir arquivo dbf
		_nIniDbf := At( "_DBF=" , Upper(_cSql) )
		If _nIniDbf > 0
			_cRDD := "DBFCDX"
			_nFimDbf := At( ".DBF" , Upper(_cSql) )
		Else
			SET AUTOPEN OFF
			SET DELETED OFF
			SET SOFTSEEK ON
			SET DATE BRITISH
			SET CENTURY ON
			SET EPOCH TO 1950
			
			_cRDD := "CTREECDX"
			_nIniDbf := At( "_DTC=" , Upper(_cSql) )
			_nFimDbf := At( ".DTC" , Upper(_cSql) )
		EndIf
		
		If _nIniDbf > 0 .AND. _nFimDbf > 0
			// nome do arquivo dbf
			
			_cDbfFile := SubStr( _cSql , _nIniDbf + 5 , _nFimDbf - _nIniDbf - 1 )
			//Alert(_cSql)
			
			//Alert(_cDbfFile)
			
			//Alert(_cRDD)
			
			// filtro a ser executado
			_cDbfFilt := SubStr( _cSql , _nFimDbf+4 )
			// retira enter
			//_cDbfFilt := StrTran( _cDbfFilt , Chr(10) ," " )
			//_cDbfFilt := StrTran( _cDbfFilt , Chr(13) ," " )
			//Alert(_cDbfFilt)
			
			DbUseArea(.T., _cRDD, _cDbfFile , _cALias, .F., .F.)
			
			dbSelectArea(_cALias)
			
			Set Filter to &(_cDbfFilt)
			
			dbGoTop()
			
		Else
			MemoWrite("D:\LOGSQL\ExecSQL.txt" , _cSql)
			
			DbUseArea(.T., "TOPCONN", TCGenQry(,,_cSql), _cALias, .F., .F.)
		EndIf
		
		if !lFim
			fGridRes(lFim)
		EndIf
	
	Recover
		//_cError := oError:Description
		_cError := SubStr(oError:Description, RAt("Error :" , oError:Description ) , Len(oError:Description) ) // + CRLF + CRLF
		//_cError += oError:ErrorStack
		
		//cSelect1 := VarInfo("Prop" , oError)
		
		Aviso( "Erro", _cError ,{"OK"} , 3 )
		
	End Sequence
	
Return nil

/*/{Protheus.doc} fCopyFile
funcao para copiar um arquivo do servidor para caminho local ou vice versa
@author caio.lima
@since 17/10/2018
/*/
Static Function fCopyFile()
	Local _nCpy := Aviso( "Copiar arquivo", "Selecione qual op��o de copia deseja utilizar" ,{"Local -> Servidor", "Serivodr -> Local", "cancelar"} , 3 )
	
	If _nCpy == 1 // local para servidor
		_cFileLoc := zChooseFile()
		_cFileSrv := cGetFile("Todos (*.*)|*.*","Selecione a pasta",2,"",.T.,GETF_RETDIRECTORY)
		
		_cFileLoc := StrTran(StrTran(_cFileLoc,Chr(13),""),Chr(10),"")
		
		//Alert(_cFileLoc)
		//Alert(_cFileSrv)
		If !Empty(_cFileSrv) .AND. !Empty(_cFileLoc)
			MsgRun("de: "+ _cFileLoc + CRLF + "para: " + _cFileSrv, "Copiar arquivo",{|| CpyT2S(_cFileLoc, _cFileSrv) })
		EndIf
		
	ElseIf _nCpy == 2 // servidor para local
		_cFileSrv := cGetFile("Todos (*.*)|*.*","Selecione o arquivo",2,"",.T.)
		_cFileLoc := cGetFile("Todos (*.*)|*.*","Selecione a pasta",2,"",.T., GETF_RETDIRECTORY + GETF_LOCALHARD)
		
		//Alert(_cFileSrv)
		//Alert(_cFileLoc)
		If !Empty(_cFileSrv) .AND. !Empty(_cFileLoc)
			MsgRun("de: "+ _cFileSrv + CRLF + "para: " + _cFileLoc, "Copiar arquivo",{|| CpyS2T(_cFileSrv, _cFileLoc) })
		EndIf
	EndIf
Return

/*/
@author: caiocrol
@data: 06/12/2015
@descricao: funcao que gera uma tabela a partir de um arquivo csv
/*/
Static Function fImpCSV()
	/*/
	Local oError
	Local bError         := { |e| oError := e , Break(e) }
	Local bErrorBlock
	Local _cError := ""
	/*/
	Local _aLinhas := {}
	Local _aLinha := {}
	
	Local _cTipo := "Arquivos csv (*.csv) |*.csv|Todos (*.*)|*.*"
	Local _cCamCSV := cGetFile(_cTipo ,"Selecione o arquivo csv", , "" ,.T.,GETF_LOCALHARD , .T.)
	
	//Local _cCamCSV := cGetFile("" ,"Selecione o arquivo csv", , "" ,.T.,GETF_LOCALHARD+GETF_RETDIRECTORY , .T.)
	Local _cCamDBF := cGetFile("" ,"Selecione o caminho do "+_cDbExt+" a ser gerado", , "" ,.T.,GETF_LOCALHARD+GETF_RETDIRECTORY , .T.)
	Local _cPthSrv := "\data\"
	Local _cFile := "Resultado_select_"+ DTOS(dDataBase) + "_" + StrTran(Time(),":","-") +_cDbExt
	Local _lContinua := .T.
	Local _cTrab := ""
	
	Local _aStruct := {}// (_cAlias)->(dbStruct())
	/*/
	If ValType(oError) = "O"
		oError:FreeChildren()
		FreeObj(oError)
	EndIf
	/*/
	_cTimeI := Time()
	/*/
	bErrorBlock    := ErrorBlock( bError )
	
	Begin Sequence
		/*/
		If Empty(_cCamCSV)
			Return nil
		EndIf
		
		// se nao encontrar o arquivo csv sai da rotina
		If !File(_cCamCSV)
			Alert("Arquivo: " + _cCamCSV + " n�o encontrado.")
			Return
			
			// verifica a extensao do arquivo
		ElseIf Upper(Right(_cCamCSV,4)) <> ".CSV"
			Alert("Arquivo invalido" )
			Return
		EndIf
		
		If Right(_cCamDBF , 1) = "\"
			// utiliza o mesmo nome do csv
			_cFile := SubStr(_cCamCSV , RAt("\" , _cCamCSV ) + 1 )
			_cFile := SubStr(_cFile   , 1 , Len(_cFile) - 3 ) + "dbf"
		Else
			// se a pessoa digitar o nome do arquivo
			// a rotina o utiliza, do contrario pega um valor default
			_cFile := SubStr(_cCamDBF , RAt("\" , _cCamDBF ) + 1 )
			_cCamDBF := SubStr(_cCamDBF , 1 , RAt("\" , _cCamDBF ) )
			
			If Upper(Right(_cFile , 4)) <> Upper(_cDbExt)
				_cFile += _cDbExt
			EndIf
			
			//_cPthSrv += _cFile
		EndIf
		
		If File(_cCamDBF + _cFile)
			If !MsgYesNo("Arquivo " + _cCamDBF + _cFile + CRLF + "J� existe, deseja sobrescrer?" )
				Return nil
			EndIf
		EndIf
		
		_cSeparador := ";"
		_aStruct := LeArq( _cCamCSV , .T. , @_cSeparador)
		
		_cTrab := CriaTrab( _aStruct , .T. )
		
		_aLinhas := LeArq( _cCamCSV , .F. , @_cSeparador)
		
		If Select(_cAlias) > 0
			(_cAlias)->(dbclosearea())
		EndIf
		
		dbUseArea(.T.,, _cTrab , _cAlias ,.F.,.F.)
		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())
		
		_cTrab := _cTrab + _cDbExt
		
		_nz := 0
		For _nz:= 1 to Len(_aLinhas)
			RecLock(_cAlias , .T.)
			
			_na := 0
			For _na:= 1 to Len(_aStruct)
				//Alert( cValToChar(_nz) + cValToChar(_na) )
				(_cAlias)->&(_aStruct[_na , 1]) := _aLinhas[_nz , _na]
			next
			
			(_cAlias)->(MsUnLock())
		next
		
		fGridRes()
		
		(_cAlias)->(dbclosearea())
		
		If SubStr(_cPthSrv,1,1) == SubStr(_cCamDBF,1,1)
			
			__CopyFile( _cTrab , _cCamDBF + _cTrab )
			
			frename(_cCamDBF + _cTrab , _cCamDBF + _cFile )
			
		Else
			
			CpyS2T( _cTrab , _cCamDBF , .T. )
			
			frename(_cCamDBF + _cTrab , _cCamDBF + _cFile )
		EndIf
		/*/
	Recover
		//_cError := oError:Description
		_cError := SubStr(oError:Description, RAt("Error :" , oError:Description ) , Len(oError:Description) ) // + CRLF + CRLF
		//_cError += oError:ErrorStack
		
		//cSelect1 := VarInfo("Prop" , oError)
		
		Aviso( "Erro", _cError ,{"OK"} , 3 )
		
	End Sequence
	/*/
Return

//����������������������������������������������������������������������������������������������������������������������������������������������������������
// funcao que le o arquivo e retorna um array com todos as linhas do arquivo
// se _lhead for true retorna um array apenas com a primeira linha
// a ser utilizada como a estrutura da tabela a ser criada
//����������������������������������������������������������������������������������������������������������������������������������������������������������
Static Function LeArq(_cArquivo , _lHead, _cSeparador)
	/*/
	Local oError
	Local bError         := { |e| oError := e , Break(e) }
	Local bErrorBlock
	Local _cError := ""
	/*/
	Local _aLinhas := {}
	Local _aLinha := {}
	Local _aCol := {}
	//Local _cSeparador := ";"
	Local _na := 0
	
	If _lHead
		Aviso( "Separador", @_cSeparador ,{"ok"} ,4,,,, .T.)
	EndIf
	//Alert(_cSeparador)
	
	/*/
	If ValType(oError) = "O"
		oError:FreeChildren()
		FreeObj(oError)
	EndIf
	
	bErrorBlock    := ErrorBlock( bError )
	
	Begin Sequence
	/*/
		// Abre o arquivo
		nHandle := FT_FUse(_cArquivo)
		
		// Se houver erro de abertura abandona processamento
		if nHandle = -1
			Alert("N�o foi possivel abrir o arquivo " + _cArquivo)
			return
		endif
		// Posiciona na primeria linha
		FT_FGoTop()
		
		If _lHead
			cLine  := FT_FReadLn()
			
			//_aLinha := StrTokArr2(cLine , _cSeparador , .T. )
			_aLinha := &("{'" + StrTran(cLine , _cSeparador , "','" ) + "'}")
			
			_nz := 0
			
			// para definicao do cabecalho existe duas opcoes
			// opc 1 - nome das colunas separadas por ponto e virgula (;)
			//  ex.: ACY_CODIGO;ACY_DESCRICAO;...
			
			// opc 2 - nome das colunas separadas por ponto e virgula (;) e virgula (,) com informacao de tipo e tamanho
			//  ex.: ACY_CODIGO,C,6,0;ACY_DESCRICAO,C,40,0;...
			// nome,tipo,tamanho,decimal;...
			
			// caso a linha possua apenas o nome sera importado como um campo caractere de 50 posicoes.
			
			For _nz := 1 to Len(_aLinha)
				If "," $ _aLinha[_nz]
					_aCol := StrTokArr2( _aLinha[_nz] , "," , .T. )
					_aCol := "{'" + StrTran( _aLinha[_nz] , "," , "','" ) + "'}"
					
					AAdd(_aLinhas ,  { _aCol[1], _aCol[2] , _aCol[3] , _aCol[4] } )
				Else
					AAdd(_aLinhas ,  {_aLinha[_nz], "C" , 50 , 0 } )
				EndIf
			next
			
			// Pula para pr�xima linha
			FT_FSKIP()
		Else
			// Pula para pr�xima linha
			FT_FSKIP()
			While !FT_FEOF()
				cLine  := FT_FReadLn()
				
				//_aLinha := StrTokArr2(cLine , _cSeparador , .T.)
				cLine := StrTran(cLine,"'","9878987")
				_aLinha := &("{'" + StrTran(cLine , _cSeparador , "','" ) + "'}")
				
				For _na:= 1 to Len(_aLinha)
					_aLinha[_na] := StrTran(_aLinha[_na],"9878987","'")
				Next
				
				Aadd(_aLinhas, _aLinha )
				// Pula para pr�xima linha
				FT_FSKIP()
			EndDo
		EndIf
		// Fecha o Arquivo
		FT_FUSE()
	/*/
	Recover
		//_cError := oError:Description
		_cError := SubStr(oError:Description, RAt("Error :" , oError:Description ) , Len(oError:Description) ) // + CRLF + CRLF
		//_cError += oError:ErrorStack
		
		//cSelect1 := VarInfo("Prop" , oError)
		
		Aviso( "Erro", _cError ,{"OK"} , 3 )
		
	End Sequence
	/*/
Return(_aLinhas)

/*/{Protheus.doc} fTcSqlExec
funcao que executa o sql update, insert ....
@author caio.lima
@since 27/12/2018
@return return, return_description
/*/
Static Function fTcSqlExec()
	Local _cSQL := ""
	Local _cAviso := "Confirma a execu��o do sql (digite abaixo)? essa op��o executa insert, update, delete, qualquer coisa, por sua conta em risco"
	
	If Aviso(_cAviso, @_cSQL, {"Confirmar", "Cancelar"}, 4,,,, .T.) == 1
		Alert(_cSQL)
		
		nStatus := TCSqlExec(_cSQL)
		
		if (nStatus < 0)
			MsgAlert("TCSQLError() " + TCSQLError())
		Else
			MsgInfo("Comando sql executado com sucesso, retorno: " + cValToChar(nStatus))
		endif
		
	EndIf
	
Return nil

/*/
@author: caiocrol
@data: 10/11/2015
@descricao: funcao com uma explicacao sobre funcionalidades
/*/
Static Function fHelp()
	
	Local _cMsgHelp := ""
	
	_cMsgHelp += "Essa tela permite executar string sql ou abrir arquivos "+_cDbExt + CRLF
	_cMsgHelp += "Sql" + CRLF
	_cMsgHelp += "  Bastar digitar o comando sql que ser� executado." + CRLF
	_cMsgHelp += "  Se for selecionado apenas parte do texto " + CRLF
	_cMsgHelp += "    ser� executado apenas a parte selecionada. " + CRLF + CRLF
	_cMsgHelp += Upper(_cDbExt) + CRLF
	_cMsgHelp += "  Para abrir um "+_cDbExt+" a sintaxe da consulta dever ser:" + CRLF
	_cMsgHelp += "  _"+Upper(SubStr(_cDbExt,2))+"=\system\sx3010"+_cDbExt+" X3_ARQUIVO='SA1' " + CRLF
	_cMsgHelp += "    _"+Upper(SubStr(_cDbExt,2))+" - comando que indica que se refere a um "+_cDbExt + CRLF
	_cMsgHelp += "    \system\sx3010"+_cDbExt+" - arquivo "+_cDbExt+" a ser aberto com o" + CRLF
	_cMsgHelp += "    caminho da pasta" + CRLF
	//_cMsgHelp += "    _DBF_ - fechamento do indicativo do nome do DBF" + CRLF
	_cMsgHelp += "    X3_ARQUIVO='SA1' - qualquer coisa depois do '"+_cDbExt+"' " + CRLF
	_cMsgHelp += "    ser� executado como filtro " + CRLF
	
	_cMsgHelp += CRLF
	_cMsgHelp += "Ex.:" + CRLF + CRLF
	_cMsgHelp += "_"+Upper(SubStr(_cDbExt,2))+"=\system\sx3010"+_cDbExt + CRLF
	_cMsgHelp += "X3_ARQUIVO='SA1'" + CRLF + CRLF
	
	_cMsgHelp += "Alt + F1 -> Mostra uma tela com a consulta dos campos da tabela" + CRLF
	_cMsgHelp += "Precisa estar com a tabela selecionada" + CRLF
	
	_cMsgHelp += CRLF
	_cMsgHelp += "Toda vez que o sql � executado um backup do sql � salvo no diretorio \sql_auto_save\" + CRLF
	_cMsgHelp += "da pasta protheus_data"
	
	Aviso( "ExecSQL", _cMsgHelp ,{"OK"} , 4,,,, .T.)
	
Return nil


/*/
@author: caiocrol
@data: 15/06/2015
@descricao: funcao que retirar comentario de uma string sql
/*/
Static Function fConvSQL(_cStrSQL)

	Local _cRet := _cStrSQL
	Local _cComent := "--"
	Local _cQbr := CRLF
	Local _nPIni := 0
	Local _nPFim := 0
	
	While _cComent $ _cRet
		
		_nPIni := At(_cComent , _cRet)
		_nPFim := At(_cQbr , SubStr(_cRet , _nPIni , Len(_cRet) ) )
		
		If _nPFim = 0 // elimina tudo
			_cRet := Stuff(_cRet , _nPIni , Len(_cRet) , "" )
		Else// elimina so o que precisar
			_nPFim += _nPIni
			_cRet := Stuff(_cRet , _nPIni , _nPFim - _nPIni , "" )
		EndIf
		
	EndDo
	
Return _cRet

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Limpa a tela
/*/
Static Function fLimpar()

If MsgYesNo("Isso ir� limpar seu select sem salvar, confirma?")
	//cSelect := ""
	oSelect:Load("")
EndIf

Return nil

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
AUTO Salva o sql
/*/
Static Function fAutoSave()

Local _cCaminho := "\sql_auto_save"
Local _cFile := "\select_"+ DTOS(dDataBase) + "_" + Left(StrTran(Time(),":","-"), 5) + ".sql"

Local _cSelect := oSelect:RetText()

If !ExistDir(_cCaminho)
	MakeDir(_cCaminho)
EndIf

_cCaminho += _cFile

MemoWrite(_cCaminho , _cSelect)

Return

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Salva o sql
/*/
Static Function fSalvSql()
Local _cTipo := "Arquivos sql (*.sql) |*.sql|Arquivos txt (*.txt) |*.txt|Todos (*.*)|*.*"
Local _cCaminho := cGetFile(_cTipo ,"Selecione o caminho", , "" ,.F.,GETF_LOCALHARD+GETF_RETDIRECTORY , .T.)
Local _cFile := "select_"+ DTOS(dDataBase) + StrTran(Time(),":","-") + ".sql"

Local _cSelect := oSelect:RetText()

Local _nHdl
Local _nPPonto := 0

If Empty(_cCaminho) // se vazio clicou em cancelar
	Return
EndIf

If Rat("\" , _cCaminho) = Len(_cCaminho)
	_cCaminho += _cFile
EndIf

_nPPonto := Rat("." , _cCaminho)

// tratativa para adicionar a extensao do arquivo apenas se for necessario
// se nao encontrar ponto no arquivo ou se encontrar porem a posicao anteriro a 4 caracteres de tras pra frente
If _nPPonto = 0 .OR. _nPPonto < Len(_cCaminho) - 4
	_cCaminho += ".sql"
EndIf

If File(_cCaminho)
	If MsgYesNo("Arquivo "+ _cCaminho + " j� existe"+ CRLF + "deseja sobrescrever?")
		If MemoWrite(_cCaminho , _cSelect)
			MsgInfo("Arquivo " + _cCaminho + " criado")
		Else
			MsgStop("N�o foi possivel criar o arquivo "+_cCaminho + CRLF +" Erro: "+ Str(FError()) )
		EndIf
	EndIf
Else
	If MemoWrite(_cCaminho , _cSelect)
		MsgInfo("Arquivo " + _cCaminho + " criado")
	Else
		MsgStop("N�o foi possivel criar o arquivo "+ _cCaminho + CRLF +" Erro: "+ Str(FError()) )
	EndIf
EndIf

Return nil

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Abri o arquivo sql
/*/
Static Function fOpenDbf()
Local _cTipo := "Arquivos (*"+_cDbExt+") |*"+_cDbExt+"|Todos (*.*)|*.*"
Local _cCaminho := cGetFile(_cTipo ,"Selecione o caminho", , "" ,.T.,GETF_LOCALHARD , .T.)
Local _cFile := ""
Local _nHdl
Local _cPthSrv := "\data\"

If Empty(_cCaminho) // se vazio clicou em cancelar
	Return
EndIf

_cTimeI := Time()

If File(_cCaminho)
	
	// se ele informar um caminho que nao seja do servidor deve copiar o arquivo primeiro antes de abrir
	If SubStr(_cPthSrv,1,1) <> SubStr(_cCaminho,1,1)
		_cFile := SubStr(_cCaminho , RAt("\" , _cCaminho ) + 1 )
		
		CpyT2S( _cCaminho , _cPthSrv , .T. )
		
		_cCaminho := _cPthSrv + _cFile
	EndIf
	
	If Select(_cALias) > 0
		(_cALias)->(dbClosearea())
	Endif
	
	//Alert(_cALias)
	
	DbUseArea(.T., _cRdd , _cCaminho , _cALias, .F., .F.)
	
	//Alert(_cALias)

	dbSelectArea(_cALias)
	
	//Alert(_cRdd)
	
	//BUILDEXPR("SX3")
	
	fGridRes()
Else
	Alert("Arquivo n�o econtrado: " + _cCaminho)
EndIf

Return nil

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Abri o arquivo sql
/*/
Static Function fOpenSql()
Local _cTipo := "Arquivos sql (*.sql) |*.sql|Arquivos txt (*.txt) |*.txt|Todos (*.*)|*.*"
Local _cCaminho := cGetFile(_cTipo ,"Selecione o caminho", , "" ,.T.,GETF_LOCALHARD , .T.)
//Local _cFile := "select_"+ DTOS(dDataBase) + StrTran(Time(),":","-") + ".sql"
Local _nHdl

If Empty(_cCaminho) // se vazio clicou em cancelar
	Return
EndIf

If File(_cCaminho)
	//cSelect := MemoRead(_cCaminho)
	//Alert(MemoRead(_cCaminho))
	_cStr := MemoRead(_cCaminho)
	If "<html>" $ Lower(_cStr) .AND. "</html>" $ Lower(_cStr)
	Else
		_cStr := StrTran(StrTran(StrTran(StrTran(StrTran(_cStr,"<", "&lt;"),">", "&gt;"),CRLF,"<br />"),Chr(13),"<br />"),Chr(10),"<br />")
	EndIf
	oSelect:Load( _cStr )
Else
	MsgStop("Arquivo "+ _cCaminho + "n�o encontrado." )
EndIf

Return nil

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Salva em dbf
/*/
Static Function fGerDBF()
Local _aLinhas := {}
Local _aLinha := {}
Local _cCaminho := cGetFile("" ,"Selecione o caminho", , "" ,.T.,GETF_LOCALHARD+GETF_RETDIRECTORY , .T.)
Local _cPthSrv := "\data\"
Local _cFile := "Resultado_select_"+ DTOS(dDataBase) + "_" + StrTran(Time(),":","-") + _cDbExt
Local _lContinua := .T.

Local _aStruct := {}// (_cAlias)->(dbStruct())

If Empty(_cCaminho)
	Return nil
EndIf

If Right(_cCaminho , 1) = "\"
	
Else
	// se a pessoa digitar o nome do arquivo 
	// a rotina o utiliza, do contrario pega um valor default
	_cFile := SubStr(_cCaminho , RAt("\" , _cCaminho ) + 1 )
	_cCaminho := SubStr(_cCaminho , 1 , RAt("\" , _cCaminho ) )
	
	If Upper(Right(_cFile , 4)) <> Upper(_cDbExt)
		_cFile += _cDbExt
	EndIf
	
	//_cPthSrv += _cFile
EndIf

If File(_cCaminho + _cFile)
	If !MsgYesNo("Arquivo " + _cCaminho + _cFile + CRLF + "J� existe, deseja sobrescrer?" )
		Return nil
	EndIf
EndIf

If Select(_cAlias) > 0
	_aStruct := (_cAlias)->(dbStruct())
Else
	Return nil
EndIf

dbSelectArea(_cAlias)
(_cAlias)->(dbGoTop())

If SubStr(_cPthSrv,1,1) == SubStr(_cCaminho,1,1)
	Copy To ( _cCaminho +_cFile )
Else
	Copy To (_cPthSrv + _cFile)
	
	CpyS2T( _cPthSrv + _cFile , _cCaminho , .T. )
EndIf

/*
For _nx := 1 To Len(_aStruct)
	If _aStruct[_nx,02] == "N"
		oExcel:AddColumn(_cNomeWS,_cNomeTab, _aStruct[_nx,01] , 1,2)
	Else
		oExcel:AddColumn(_cNomeWS,_cNomeTab, _aStruct[_nx,01] , 1,1)
	EndIf
Next

_aLinhas := aGridRes // fVarrAlias()

For _nx := 1 To Len(_aLinhas)
	_aLinha := {}
	
	For _ny:= 1 To Len(_aLinhas[_nx])
		If ValTyPe(_aLinhas[_nx,_ny]) == "N"
			Aadd(_aLinha , _aLinhas[_nx,_ny])
		Else
			_cCell := _aLinhas[_nx,_ny]
			_cCell := StrTran(_cCell , "<", "&lt;" )
			_cCell := StrTran(_cCell , ">", "&gt;" )
			Aadd(_aLinha , _cCell )
		EndIf
	Next

	oExcel:AddRow(_cNomeWS, _cNomeTab, _aLinha)
Next
*/
Return nil
/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Salva em excel xml
/*/
Static Function fExcel()
Local oExcel
Local oExcelApp
Local _aLinhas := {}
Local _aLinha := {}
Local _cCaminho := cGetFile("" ,"Selecione o caminho", , "" ,.F.,GETF_LOCALHARD+GETF_RETDIRECTORY , .F.)
Local _cFile := "Resultado_select_"+ DTOS(dDataBase) + "_" + StrTran(Time(),":","-") + ".xml"
Local _lExcel := fValExcel() // ApOleClient("MSExcel")// verifica se o excel esta instalado na maquina client

Local _cNomewS := "Resultado Select"
Local _cNomeTab := "Resultado Select"

Local _aStruct := {}// (_cAlias)->(dbStruct())
Local _cCell := ""

If Empty(_cCaminho)
	Return nil
EndIf

If !_lP11
	Alert("Essa vers�o do protheus n�o suporta a gera��o de excel xml.")
	Return nil
EndIf

If Select(_cAlias) > 0
	_aStruct := (_cAlias)->(dbStruct())
Else
	Return nil
EndIf

oExcel    := FWMSEXCEL():New()

oExcel:AddworkSheet(_cNomeWS)
oExcel:AddTable (_cNomeWS,_cNomeTab)

For _nx := 1 To Len(_aStruct)
	If _aStruct[_nx,02] == "N"
		oExcel:AddColumn(_cNomeWS,_cNomeTab, _aStruct[_nx,01] , 1,2)
	Else
		oExcel:AddColumn(_cNomeWS,_cNomeTab, _aStruct[_nx,01] , 1,1)
	EndIf
Next

_aLinhas := aGridRes // fVarrAlias()

For _nx := 1 To Len(_aLinhas)
	_aLinha := {}
	
	For _ny:= 1 To Len(_aLinhas[_nx])
		If ValTyPe(_aLinhas[_nx,_ny]) == "N"
			Aadd(_aLinha , _aLinhas[_nx,_ny])
		Else
			_cCell := _aLinhas[_nx,_ny]
			_cCell := StrTran(_cCell , "<", "&lt;" )
			_cCell := StrTran(_cCell , ">", "&gt;" )
			Aadd(_aLinha , _cCell )
		EndIf
	Next

	oExcel:AddRow(_cNomeWS, _cNomeTab, _aLinha)
Next

oExcel:Activate()

oExcel:GetXMLFile(_cCaminho+_cFile)
If _lExcel
	_cMsgErro := "Arquivo gerado em:" + CRLF + _cCaminho + _cFile + CRLF + "O que deseja fazer?"
	_nAv := Aviso( "Arquivo csv", _cMsgErro ,{"Abrir arquivo","Abrir pasta","Nada"} , 3 )
	If _nAv == 1
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(_cCaminho+_cFile)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	ElseIf _nAv == 2
		WinExec('explorer /select, "'+_cCaminho+_cFile+'"')
	EndIf
Else
	_cMsgErro := "N�o foi encontrado o excel instalado nessa maquina. Arquivo gerado em:" + CRLF + _cCaminho
	If Aviso( "Excel not found", _cMsgErro ,{"OK","Abrir pasta"} , 3 ) = 2
		WinExec('explorer /select, "'+_cCaminho+_cFile+'"')
	EndIf
EndIf
Return nil
/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Salva em excel csv
/*/
Static Function fExCSV()
Local oExcel
Local oExcelApp
Local _aLinhas := {}
Local _cCaminho := cGetFile("" ,"Selecione o caminho", , "" ,.F.,GETF_LOCALHARD+GETF_RETDIRECTORY , .F.)
Local _cFile := "Resultado_select_"+ DTOS(dDataBase) + "_" + StrTran(Time(),":","-") + ".csv"
Local _lExcel := fValExcel() // ApOleClient("MSExcel")// verifica se o excel esta instalado na maquina client

Local _cNomewS := "Resultado Select"
Local _cNomeTab := "Resultado Select"

Local _aStruct := {}// (_cAlias)->(dbStruct())

Local _nHdl
Local _cCsv := ""

If Empty(_cCaminho)
	Return nil
EndIf

If Select(_cAlias) > 0
	_aStruct := (_cAlias)->(dbStruct())
Else
	Return nil
EndIf

_nHdl := fCreate(_cCaminho+_cFile)
If _nHdl < 0
	Aviso( "Erro Arquivo", "Erro ao criar arquivo: " + FError() ,{"OK"} , 3 )
	Return Nil
EndIf

For _nx := 1 To Len(_aStruct)
	_cCsv += _aStruct[_nx,01] + ';'
Next
_cCsv += CRLF

FWrite(_nHdl , _cCsv)
_cCsv := ""

_aLinhas := aGridRes//fVarrAlias()

For _nx := 1 To Len(_aLinhas)
	For _ny := 1 To Len(_aStruct)
		If _aStruct[_ny,02] == "N"
			_cCsv += cValToChar(_aLinhas[_nx , _ny]) + ';'
		Else
			_cCsv += _aLinhas[_nx , _ny] + ';'
		EndIf
	Next
	_cCsv += CRLF
	FWrite(_nHdl , _cCsv)
	_cCsv := ""
Next

FClose(_nHdl)

If _lExcel
	_cMsgErro := "Arquivo gerado em:" + CRLF + _cCaminho + _cFile + CRLF + "O que deseja fazer?"
	_nAv := Aviso( "Arquivo csv", _cMsgErro ,{"Abrir arquivo","Abrir pasta","Nada"} , 3 )
	If _nAv == 1
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(_cCaminho+_cFile)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	ElseIf _nAv == 2
		WinExec('explorer /select, "'+_cCaminho+_cFile+'"')
	EndIf
Else
	_cMsgErro := "N�o foi encontrado o excel instalado nessa maquina. Arquivo gerado em:" + CRLF + _cCaminho
	If Aviso( "Excel not found", _cMsgErro ,{"OK","Abrir pasta"} , 3 ) = 2
		WinExec('explorer /select, "'+_cCaminho+_cFile+'"')
	EndIf
EndIf
Return nil
/*/
@author: caiocrol
@data: 17/08/2014
@descricao: 
/*/
//------------------------------------------------ 
Static Function fGridRes(lFim)
//------------------------------------------------
Local _aHeader := {""}
Local _aSize := {1}
Local _aStruct := {}
Local oColumn
Local _nx := 0

Default lFim := .F.

If Select(_cALias) > 0 // .AND. !(_cAlias)->(Eof())
	_aStruct := (_cAlias)->(dbStruct())
	
	_aHeader := {}
	_aSize := {}
	
	If ValType(oGridRes) = "O"
		oGridRes:FreeChildren()
		FreeObj(oGridRes)
	EndIf
	oGridRes := NIL
	
	aGridRes := fVarrAlias(,lFim)
	
	_cNReg := Transform(Len(aGridRes) , "@E 999,999,999,999") + " registros."
	//oMsgRec:SetText(_cNReg)
	
	_cTimeF := Time()
	
	//oMsgSts:SetText( ElapTime( _cTimeI , _cTimeF ) + " tempo." )
	
	oGridRes := MsBrGetDBase():New( 10, 0, 260, 170,,/*_aHeader*/,/*_aSize*/, oPanel1,,,,,,,,,,,, .F., "", .T.,, .F.,,, )
	oGridRes:SetArray(aGridRes)
	
	For _nx := 1 To Len(_aStruct)
		oGridRes:AddColumn(TCColumn():New(_aStruct[_nx,01]	, &('{ || aGridRes[oGridRes:nAt,'+cValToChar(_nx)+'] }'),,,,"LEFT"/*,,.F.,.F.,,,,.F.,*/))
	Next
	
	oGridRes:Align := CONTROL_ALIGN_ALLCLIENT
Else

EndIf

Return
//����������������������������������������������������������������������������������������������������������������������������������������������������������
// funcao fbLine
//����������������������������������������������������������������������������������������������������������������������������������������������������������
Static Function fbLine(_aLinhas, _oGrid)
Local _aRet := {}
Local _ny := 0
For _ny := 1 to Len(_aLinhas[1])
	Aadd(_aRet,_aLinhas[_oGrid:nAt,_ny] )
Next
Return(_aRet)

/*/
@author: caiocrol
@data: 16/08/2014
@descricao: 
Funcao que varre alias para retornar select
/*/
Static Function fVarrAlias(_cTipo, lFim)
	Local _xRet
	
	Local _aStruct := (_cAlias)->(dbStruct())
	Local _nLenRet := 0
	Local _nCont := 0
	
	Default _cTipo := "ARRAY"
	Default lFim := .F.
	
	(_cAlias)->(dbGoTop())
	
	If Upper(_cTipo) == "ARRAY"
		_xRet := {}
		If (_cAlias)->(Eof())
			Aadd(_xRet , {})
			_nLenRet := Len(_xRet)
			
			For _nx := 1 To Len(_aStruct)
				Aadd(_xRet[_nLenRet] , "" )
			Next
		Else
			While !(_cAlias)->(Eof())
				Aadd(_xRet , {})
				_nLenRet := Len(_xRet)
				
				For _nx := 1 To Len(_aStruct)
					Aadd(_xRet[_nLenRet] , (_cAlias)->&(_aStruct[_nx,01]) )
				Next
				
				if lFim
					Alert("Abortado pelo usuario.")
					Exit
				EndIf
				
				(_cAlias)->(dbSkip())
			EndDo
		EndIf
	ElseIf Upper(_cTipo) == "STRING"
		_xRet := ""
		
		For _nx := 1 To Len(_aStruct)
			_xRet += Padr(_aStruct[_nx,01] , _aStruct[_nx,03]) + " ; "
		Next
		
		_xRet += CRLF
		
		While !(_cAlias)->(Eof())
			For _nx := 1 To Len(_aStruct)
				If _aStruct[_nx,02] == "N"
					_xRet += Str((_cAlias)->&(_aStruct[_nx,01]),_aStruct[_nx,03]) + " ; "
				Else
					_xRet += (_cAlias)->&(_aStruct[_nx,01]) + " ; "
				EndIf
			Next
			
			_xRet += CRLF
			
			_nCont++
			
			(_cAlias)->(dbSkip())
		EndDo
		
		_xRet += cValToChar(_nCont) + " linhas retornadas"
		
	EndIf
	
	//If Empty(_aRet)
	//_aRet := {""}
	//EndIf
	
Return _xRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Fun��o de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  05/06/2015
@obs    Gerado por EXPORDIC - V.4.22.10.8 EFS / Upd. V.4.19.13 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
/*
Static Function MyOpenSM0(lShared)

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex( "SIGAMAT.IND" )
		Exit
	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen
	MsgStop( "N�o foi poss�vel a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN��O" )
EndIf

Return lOpen
*/


/*/
@author: caiocrol
@data: 15/09/2015
@descricao: converte html em linguagem condificao asc
/*/
Static Function fRetHTML(_xVar)
	Local _cRet := ""
	
	_cRet := VarInfo("_xVar", _xVar )
	_cRet := StrTran(_cRet , "<br>" , CRLF )
	_cRet := StrTran(_cRet , "<pre>" , "")
	_cRet := StrTran(_cRet , "</pre>" , "")
	_cRet := StrTran(_cRet , CRLF+CRLF , CRLF )
	
Return _cRet

/*/
@author: caio.lima
@data: 24/08/2016
@descricao: funcao que valida se o excel esta instalado na maquina
/*/
Static Function fValExcel()
	Local _lRet := .F.
	
	_lRet := ApOleClient("MSExcel") .OR. ApOleClient("MsExcel") .OR. ApOleClient("Microsoft Excel")
	
Return _lRet
/*/{Protheus.doc} MyOpenSM0
Fun��o de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  17/07/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/

Static Function MyOpenSM0(lShared)

	Local lOpen := .F.
	Local nLoop := 0

	For nLoop := 1 To 20
		dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf

		Sleep( 500 )

	Next nLoop

	If !lOpen
		MsgStop( "N�o foi poss�vel a abertura da tabela " + ;
		IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN��O" )
	EndIf

Return( lOpen )

 
/*/{Protheus.doc} zChooseFile
Fun��o que abre a tela padr�o do Windows Explorer para escolher um arquivo
Substitui a cGetFile
@author Atilio
@since 03/08/2017
@version undefined
@param cMascara, characters, M�scara para escolha de arquivos (Descri��o *.extens�o | *.extens�o)
@type function
@example Exemplos abaixo:
    //Escolher qualquer arquivo ( *.* ):
    u_zChooseFile()
     
    //Escolher somente arquivos texto ( *.txt )
    u_zChooseFile("Arquivos Texto (*.txt)|*.txt")
     
    //Escolher arquivos texto ou todos (*.txt ou *.*)
    u_zChooseFile("Arquivos Texto (*.txt)|*.txt|Todos Arquivos (*.*)|*.*")
     
    //Escolher imagens png ou jpg (*.png ou *.jpg)
    u_zChooseFile("Arquivos Texto (*.png)|*.png|Arquivos Texto (*.jpg)|*.jpg")
/*/
 
Static Function zChooseFile(cMascara)
    Local cResultado := ""
    Local cComando   := ""
    Local cDir       := GetTempPath()
    Local cNomBat    := "zChooseFile.bat"
    Local cArquivo   := "resultado.txt"
    Local cMac       := ""
    Default cMascara := "Todos Arquivos (*.*)|*.*"
     
    //Se o resultado j� existir, exclui
    If File(cDir + cArquivo)
        FErase(cDir +cArquivo)
    EndIf
     
    //Monta o comando para abrir a tela de sele��o do windows
    cComando += '@echo off' + CRLF
    cComando += 'setlocal' + CRLF
    cComando += 'set ps_cmd=powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.Filter=' + "'"+cMascara+"'" + ';$f.showHelp=$true;$f.ShowDialog()|Out-Null;$f.FileName"' + CRLF
    cComando += '' + CRLF
    cComando += 'for /f "delims=" %%I in (' + "'%ps_cmd%'" + ') do set "filename=%%I"' + CRLF
    cComando += '' + CRLF
    cComando += 'if defined filename (' + CRLF
    cComando += '    echo %filename% > '+cArquivo + CRLF
    cComando += ')' + CRLF
    
    //Gravando em um .bat o comando
    MemoWrite(cDir + cNomBat, cComando)
    
    //Executando o comando atrav�s do .bat
    WaitRun(cDir+cNomBat, 2)
    
    //Se existe o arquivo
    If File(cDir + cArquivo)
     
        //Pegando o resultado que o usu�rio escolheu
        cResultado := MemoRead(cDir + cArquivo)
    EndIf
Return cResultado

/*/{Protheus.doc} MapColor
	@description Mapeia e formata palavras.
	@type User Function
	@author Rafael Karczevski
	@since 17/01/2020
	@version 1.0
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@see (links_or_references)
/*/
Static Function MapColor()

	Local nX
	Local aDados := {}
	Local cColBlu := "#2467d4"
	Local cColTag := "#2e4469"

	aAdd(aDados, {"AND"		,cColBlu})
	aAdd(aDados, {"SELECT"	,cColBlu})
	aAdd(aDados, {"FROM"	,cColBlu})
	aAdd(aDados, {"OR"		,cColBlu})
	aAdd(aDados, {"("		,cColTag})
	aAdd(aDados, {")"		,cColTag})
	aAdd(aDados, {"="		,cColTag})
	aAdd(aDados, {"<"		,cColTag})
	aAdd(aDados, {">"		,cColTag})
	aAdd(aDados, {"-"		,cColTag})
	aAdd(aDados, {"+"		,cColTag})
	aAdd(aDados, {"."		,cColTag})
	aAdd(aDados, {","		,cColTag})
	aAdd(aDados, {"*"		,cColTag})
	aAdd(aDados, {"/"		,cColTag})

	IF oSelect <> Nil
		For nX := 1 to Len(aDados)
			oSelect:Load( StrTran(oSelect:RetText(), aDados[nX][1], "<font color=" + aDados[nX][2] + ">" + aDados[nX][1] + "</font>") )
		Next
	EndIf

Return