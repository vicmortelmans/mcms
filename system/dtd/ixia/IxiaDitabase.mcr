<?xml version="1.0" ?>
<!DOCTYPE MACROS SYSTEM "macros.dtd">
<MACROS>
	<MACRO name="On_Document_Before_DropText" lang="JScript" hide="true">
			var topaste = ActiveDocument.Clipboard.Text;
			var noLocId = topaste.replace(/ixia_locid="[0-9]*"/g, "");
			ActiveDocument.Clipboard.Text = noLocId;
	</MACRO>
</MACROS>
