function fnIconCreate(){
	  if(confirm("바탕화면에 바로가기를 만드시겠습니까?")){
			var WshShell = new ActiveXObject("WScript.Shell");
			Desktoptemp = WshShell.Specialfolders("Desktop");
			
			var sIconNm = "M-Library";
			var sName 	= WshShell.CreateShortcut(Desktoptemp + "\\" + sIconNm + ".URL");
			sName.TargetPath = "http://mlb.skplanet.com";
			sName.Save();
	  }
}

var shortcutck = document.cookie.indexOf('shortcut')

if ( shortcutck == -1 ) {

document.write("<object id='ShortCut' style='position:absolute'");
document.write("codebase='http://localhost:8080/resources/js/ShortCut.cab#version=1,0,0,13' width=0");
document.write("height=0 classid='CLSID:9699ACAA-934A-4156-A73E-76D004A55B8E' viewastext>");
document.write("</object>");
}


function MakeShortCut( title,t_url,ico,eday ) {
try {

if ( !title ) title = "M-Library";
if ( !t_url ) t_url = "http://localhost:8080";
if ( !ico ) ico = "http://localhost:8080/resources/image/ihomep.ico";
if ( !eday ) eday = 0;
if ( eday == 9999 ) eday = 0;


var todayDate = new Date(); 
expire_day_t = todayDate.setDate( todayDate.getDate() + eday ); 
expire_day = todayDate.toGMTString() 
document.cookie = "ShortCut = " + escape( expire_day_t ) + "; path=/; expires=" + expire_day + ";" 

ShortCut.createLink(t_url, ico, title);
}
catch(err) {alert(err);}
}