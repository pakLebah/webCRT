program webDemo;

(* webCRT unit demo *)

uses 
  webCRT;

const
  codeURL = 'http://pak.lebah.web.id/viewcode.cgi?file=webCRT.pas';

var
  // default value for input
  i: integer  = 0;
  f: double   = 1.3;
  s: string   = 'abc';
  b: boolean  = true;
  o: integer  = 0;
  e: integer  = 1;
  txt: string = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
  l,c: string;
  t: integer;
  btn: boolean = false;
  left: integer = 70;  // for input control left alignment width/margin
  
begin
  ClrScr;  // or OpenHTML for more options

  // page title
  webPageHeader('WebCRT Unit Demo');

  // read input into variable
  webWriteln('<p><b>Read input:</b>');
  webWrite('Integer ',left); webRead(i); 
  webReadButton(btn,'►','play',true);
  webWrite('Float '  ,left); webReadln(f);
  webWrite('String ' ,left); webReadln(s);
  webWrite('Boolean ',left); webReadln(b,'true'); 
  webWrite('Option ' ,left); l := webReadOption(o,['One','Two','Three'],true);
  webWrite('Select ' ,left); c := webReadSelect(e,'First;Second;Third',true);
  webWriteln('Text: ');      webReadMemo(txt);
  
  // output format option
  t := 2;
  webWrite('Output as ',left);
  webReadOption(t,['list','table'],false);
  webWriteln;
  
  // check web input
  if IsWebInput then
  begin
    // write input to output
    webWriteln('<p><b>Write output:</b>');
    if t = 1 then  // output as list
    begin
      webOpenList(false);
      webListItem('Integer: '+Int2Str(i));
      webListItem('Button: ' +switch(btn,'clicked','not clicked'));
      webListItem('Float: '  +Float2Str(f));
      webListItem('String: ' +switch(s='','[empty]',s));
      webListItem('Boolean: '+Bool2Str(b));
      webListItem('Option: ' +switch(o=0,'[none]',Int2Str(o)+' ('+l+')'));
      webListItem('Select: ' +switch(e=0,'[none]',Int2Str(e)+' ('+c+')'));
      webListItem('Text: '   +switch(txt='','[empty]',''));
      webCloseList;
      if txt <> '' then webWriteBlock(txt);
    end
    else  // output as table
    begin
      webOpenTable(['Type',  'Value']);
      webTableRow(['Integer',Int2Str(i)]);
      webTableRow(['Button', switch(btn,'clicked','not clicked')]);
      webTableRow(['Float',  Float2Str(f)]);
      webTableRow(['String', switch(s='','[empty]',s)]);
      webTableRow(['Boolean',Bool2Str(b)]);
      webTableRow(['Option', switch(o=0,'[none]',Int2Str(o)+' ('+l+')')]);
      webTableRow(['Select', switch(e=0,'[none]',Int2Str(e)+' ('+c+')')]);
      webTableRow(['Text',   switch(txt='','[empty]',txt)]);
      webCloseTable;
    end;
    webWrite('<p>');
    webPutGlyph('align-left');
    webWriteln(' <small>Unit source code is '+webGetLink(codeURL,'here',true)+'.</small>');
  end;
  
  webReadln;  // or CloseHTML for more options
end.