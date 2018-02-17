unit webCRT;

(*****************************************************************************
  webCRT unit - v.1.0
  -------------------
# Description: 
  This unit makes web development using Pascal becomes simple and easy. It's
  almost like writing a console program, using writeln/readln. This unit is
  especially targetted to Pascal newbies whom yet able to comprehend complex 
  web application system. But it's also suitable for any Pascal programmers
  to create simple web applications in quick and easy way.
# Release note:
  - v.1.0: - On 4 Sep 2016.
           - First public release, without any documentation.
  - v.1.1: - On 14 Feb 2018.
           - Added new webWriteLine() procedure.
           - Some minor bug fixes.
# Author:
  - Nickname : Mr. Bee Jay
  - Facebook : /pak.lebah
  - Twitter  : @pak_lebah
  - Tumblr   : paklebah
  - Email    : pak dot lebah at yahoo dot com
  - Website  : pak.lebah.web.id (for my personal coding research)
 *****************************************************************************)

{$MODE OBJFPC}{$H+}{$J-}

interface

// global vars
var
  csvSplitter : string  = ';';
  ResourcePath: string  = 'res/';
  SourcePath  : string  = '../pascal';
  IsWebInput  : boolean = false;

// html document setup
procedure ClrScr; inline;
procedure OpenHTML(const isPOST: boolean = true; const loadGlyphs: boolean = false; const customCSS: string = ''); inline;
procedure CloseHTML(const submit: boolean = true; const footer: string = ''; const credit: boolean = true); inline;

// write output without html new line
procedure WebWrite; overload; inline;
procedure WebWrite(const str: string; const width: integer = 0); overload; inline;
procedure WebWrite(const int: integer; const width: integer = 0); overload; inline;
procedure WebWrite(const int: int64; const width: integer = 0); overload; inline;
procedure WebWrite(const real: double; const width: integer = 0); overload; inline;
procedure WebWrite(const bool: boolean; const width: integer = 0); overload; inline;

// write output with html new line
procedure WebWriteln; overload; inline;
procedure WebWriteln(const str: string); overload; inline;
procedure WebWriteln(const int: integer); overload; inline;
procedure WebWriteln(const int: int64); overload; inline;
procedure WebWriteln(const real: double); overload; inline;
procedure WebWriteln(const bool: boolean); overload; inline;

// read input without html new line
procedure WebRead(const newLine: boolean = false); overload; inline;
procedure WebRead(var str: string; const newLine: boolean = false); overload; inline;
procedure WebRead(var int: integer; const newLine: boolean = false); overload; inline;
procedure WebRead(var int: int64; const newLine: boolean = false); overload; inline;
procedure WebRead(var real: double; const newLine: boolean = false); overload; inline;
procedure WebRead(var bool: boolean; const aLabel: string; const newLine: boolean = false); overload; inline;

// read input with html new line
procedure WebReadln; overload; inline;
procedure WebReadln(var str: string); overload; inline;
procedure WebReadln(var int: integer); overload; inline;
procedure WebReadln(var int: int64); overload; inline;
procedure WebReadln(var real: double); overload; inline;
procedure WebReadln(var bool: boolean; const aLabel: string); overload; inline;

// additional web input
function  WebReadKey(const key: string): boolean; inline;
function  WebReadVar(const key: string): string; inline;
procedure WebReadMemo(var txt: string; const newLine: boolean = true); inline;
function  WebReadOption(var opt: integer; const labels: array of string; const newLine: boolean = false): string;
function  WebReadOption(var opt: integer; const csvLabels: string; const newLine: boolean = false): string;
function  WebReadSelect(var sel: integer; const items: array of string; const newLine: boolean = false): string; overload;
function  WebReadSelect(var sel: integer; const csvItems: string; const newLine: boolean = false): string; overload;
procedure WebReadButton(var clicked: boolean; const caption: string; const glyph: string = ''; const newLine: boolean = false); inline;
procedure WebButtonAction(var clicked: boolean; const caption: string; const action: string; const glyph: string = ''; const newLine: boolean = false); inline;

// additional web output
procedure WebWriteVar(const key, value: string); inline;
procedure WebWriteBlock(const txt: string); inline;
procedure WebWriteLine(const space: integer = 0; const width: integer = 50); inline;
procedure WebPutGlyph(const gName: string; const caption: string = ''; const newLine: boolean = false); inline;
function  WebGetGlyph(const gName: string; const caption: string = ''; const asTitle: boolean = false): string; inline;
function  WebGetLink(const url: string; const caption: string = ''; const newPage: boolean = false): string; inline;

// page title and header
procedure WebPageHeader(const title: string; const level: integer = 0); inline;
procedure WebPageTitle(const title: string; const subTitle: string); inline;

// html table management
procedure WebOpenTable(const headers: array of string; const aclass: string = ''; const aid: string = ''); overload; inline;
procedure WebOpenTable(const csvHeaders: string; const aclass: string = ''; const aid: string = ''); overload; inline;
procedure WebTableRow(const cells: array of string; const cols: integer = 0); overload; inline;
procedure WebTableRow(const csvCells: string; const cols: integer = 0); overload; inline;
procedure WebCloseTable; inline;

// html list management
procedure WebOpenList(const isOrdered: boolean; const aclass: string = ''; const aid: string = ''); inline;
procedure WebListItem(const txt: string); inline;
procedure WebCloseList; inline;

// view source code page
procedure ViewSource(srcPath: string = ''; const loadGlyphs: boolean = false);

// character de/en-coding
function HTTPDecode(const txt: string): string;
function HTTPEncode(const txt: string): string;
function HTMLDecode(const txt: string): string;
function HTMLEncode(const txt: string): string;

// convertion methods
function Int2Str(const i: integer): string; inline;
function Int2Str(const i: int64): string; inline;
function Float2Str(const f: double): string; inline;
function Bool2Str(const b: boolean): string; inline;
function Str2Int(const s: string): integer; inline;
function Str2Int(const s: string): int64; inline;
function Str2Float(const s: string): double; inline;
function Str2Bool(s: string): boolean; inline;
function isInt(const s: string): boolean; inline;
function isFloat(const s: string): boolean; inline;
function isMobile: boolean; inline;

// if..then..else shortcut
function switch(const condition: boolean; const strTrue, strFalse: string): string; inline;
function switch(const condition: boolean; const intTrue, intFalse: integer): integer; inline;
function switch(const condition: boolean; const intTrue, intFalse: int64): int64; inline;
function switch(const condition: boolean; const realTrue, realFalse: double): double; inline;
function switch(const condition: boolean; const boolTrue, boolFalse: boolean): boolean; inline;

implementation

uses 
  Classes, SysUtils, StrUtils, DateUtils;

// unit vars
var
  ExeName: string;
  WebInput: string;
  LeftWidth: integer;
  InputCount: integer;
  ListOrdered: boolean;
  tStart,tStop: TDateTime;

(***** PRIVATE METHODS *****)

// read item at comma separated string; index is 1-based
function getItemAt(const aText: string; const aIndex: integer; aDelim: string = ';'): string;
var
  i,l,pa,pb: integer;
begin
  Result := '';
  if aDelim <> csvSplitter then aDelim := csvSplitter;
  if (aText = '') or (aIndex < 1) or (aDelim = '') then Exit;

  i := 0; pa := 1;
  l := Length(aText);
  while pa > 0 do 
  begin
    i := i+1;
    pb := PosEx(aDelim,aText,pa); // found next delimiter after the last
    if pb = 0 then pb := l+1;     // no delimiter found at the end, include last char
    if pa = pb then pa := pa+1;   // found empty field, move to next char
    
    if i = aIndex then
    begin
      Result := Copy(aText,pa,pb-pa); // read field value as is (including spaces)
      if pb = l then Exit;            // a delimiter found at the end, stop it 
    end
    else
    begin
      pa := pb+1;                 // a delimiter found NOT at the index, get along
      if pa >= l then pa := 0;    // iterator reaches the end of the text, stop it 
    end;
  end;
end;

// count items of comma separated string
function getItemCount(const aText: string; aDelim: string = ';'): integer;
var
  i,l,p: integer;
begin
  Result := 0;
  if aDelim <> csvSplitter then aDelim := csvSplitter;
  if (aText = '') or (aDelim = '') then Exit;
  
  i := 0; p := 0;
  l := Length(aText);
  while p <= l do 
  begin
    i := i+1;                     // count delimiter found 
    p := PosEx(aDelim,aText,p+1); // search for delimiter along the text
    if p = 0 then p := l+1;       // no delimiter found at the end, stop it 
    if p = l then i := i-1;       // a delimiter found at the end, ignore it 
  end;
  Result := i;
end;

// look for key from a string
function getKey(const aKey, fromString: string; const aDelim: string = '&'): boolean;
begin
  Result := (Pos(LowerCase(aKey)+'=',LowerCase(fromString)) > 0);
end;

// extract value of a key from a string
function getValue(const aKey, fromString: string; const defValue: string = ''; const aDelim: string = '&'): string;
var
  pStart, pStop: integer;
  s: string;
begin
  Result := '';
  // search for key in lower case
  s := LowerCase(fromString);
  pStart := Pos(LowerCase(aKey)+'=', s);
  // the key is found
  if pStart > 0 then
  begin
    // read the value
    pStop := PosEx(aDelim, s, pStart);
    pStart := pStart + Length(aKey) + 1;
    if pStop = 0 then pStop := 1024;
    // cut and return the value from original string
    Result := Copy(fromString, pStart, pStop-pStart);
    if (Result = '') and (defValue <> '') then Result := defValue;
  end;
end;

// read web input from all available sources
function readWebInput(const isPOST: boolean = false): string;
var
  ch: char;
begin
  Result := '';
  // read from input (POST)
  if isPOST then
    while not EOF(input) do
    begin
      read(ch);
      Result := Result + ch;
    end
  // read from environment (GET)
  else
    Result := GetEnvironmentVariable('QUERY_STRING');
end;

// write html document header
procedure writeWebHeader(const loadGlyphs: boolean = true; const loadPrism: boolean = false; const customCSS: string = ''); inline;
begin
  // http headers
  writeln('cache-control: no-cache, no-store, must-revalidate');
  writeln('pragma: no-cache');
  writeln('vary:*');
  writeln('content-type: text/html',LineEnding);
  // html headers
  writeln('<!doctype html>');
  writeln('<html><head>');
  writeln('  <meta charset="UTF-8" lang="id">');
  writeln('  <meta name="viewport" content="width=device-width, initial-scale=1.0">');
  writeln('  <title>',ExeName,' - WebCRT</title>');
  // default page element styling 
  if customCSS = '' then
  begin
    writeln('  <style>');
    writeln('  body { ');
    writeln('    font-family: Helvetica, Arial; ');
    writeln('    font-size: 11pt; ');
    writeln('    line-height: 1.5em; ');
    writeln('    margin: 8px 12px 8px 12px; }');
    writeln('  input[type=submit] { font-size: 12pt }');
    writeln('  input[type=text] { font-size: 11pt; padding: 0 2px; }');
    writeln('  select { font-size: 12pt; margin: 0 2px; padding: 0 2px; }');
    writeln('  textarea { font-size: 11pt; margin: 4px 0 0 0; }');
    writeln('  button { font-size: 10pt }');
    writeln('  big { font-size: 1.25em }');
    writeln('  small { font-size: 0.75em }');
    writeln('  p { margin: 8px 0 }');
    writeln('  ul { margin: 0; padding: 0 0 0 30px; }');
    writeln('  ol { margin: 0; padding: 0 0 0 30px; }');
    writeln('  ul li { padding-left: 2px; }');
    writeln('  ol li { padding-left: 2px; }');
    writeln('  blockquote { ');
    writeln('    background: #eeeeee; ');
    writeln('    border-left: 4px solid #bbbbbb; ');
    writeln('    margin: 4px; ');
    writeln('    padding: 4px 8px; }');
    writeln('  table { ');
    writeln('    font-size: 10pt; ');
    writeln('    margin: 8px 0; ');
    writeln('    border-bottom: 1px solid black; ');
    writeln('    border-collapse: collapse; }');
    writeln('  table th { ');
    writeln('    background-color: #dddddd; ');
    writeln('    border-bottom: 1px solid black; ');
    writeln('    padding: 1px 6px; }');
    writeln('  table td { ');
    writeln('    padding: 1px 6px; ');
    writeln('    vertical-align: top; }');
    writeln('  table tr:nth-child(odd) { background-color: #eeeeee }');
    writeln('  table tr:hover { background-color: lightskyblue }');
    writeln('  span.input { display:inline-block; vertical-align:top; }');
    writeln('  ::-webkit-input-placeholder { font-size: 10pt; }');
    writeln('  :-moz-placeholder { font-size: 10pt; }');
    writeln('  ::-moz-placeholder { font-size: 10pt; }');
    writeln('  :-ms-input-placeholder { font-size: 10pt; }');
    writeln('  </style>');
  end
  else
    writeln('  <link rel="stylesheet" href="',ResourcePath,customCSS,'">');
  // use BootStrap's glyphicon lib
  if loadGlyphs then
    writeln('  <link href="',ResourcePath,'glyphicons.css" rel="stylesheet">');
  // use loadPrism to view source code
  if loadPrism then
  begin
    writeln('  <link rel="stylesheet" href="',ResourcePath,'prism.css">');
    writeln('  <script type="text/javascript" src="',ResourcePath,'prism.min.js"></script>');
  end;
  // ready for page content
  writeln('</head><body>');
  write  ('  <b>&nbsp;');
  if loadGlyphs then 
    write('&nbsp;<a href="',ExeName,'"><span class="glyphicon glyphicon-home" aria-hidden="true"></span></a>')
  else 
    write('<a href="',ExeName,'"><big>⌂</big></a>');
  writeln('</b> │ ');
  if loadPrism then
    writeln('  <a href="',ExeName,'">',ExeName,'</a><hr/>')
  else
    writeln('  <a href="',ExeName,'?src=1">',ChangeFileExt(ExeName,'.pas'),'</a><hr/>');
end;

// read value from web vars
function readTextInput: string; inline;
begin
  Inc(InputCount);
  Result := HTTPDecode(getValue('input_'+IntToStr(InputCount),WebInput));
end;

// write text input component onto page
procedure writeTextInput(const value: string; const newline: boolean = true; const asHolder: boolean = false); inline;
begin
  write('<input type="text" id="edInput_',InputCount,'" name="input_',InputCount,'"');
  if not asHolder then
    write(' value="',value,'"')
  else 
    write(' value="" placeholder="',value,'"');
  write('/>');
  if newline then writeln('<br/>') else writeln;
end;

(***** PUBLIC METHODS *****)

procedure OpenHTML(const isPOST: boolean = true; const loadGlyphs: boolean = false; const customCSS: string = '');
var
  g,p: string;
begin
  // start time
  tStart := Now;
  // read all web input  
  p := readWebInput(isPOST);
  g := readWebInput(not isPOST);
  if (p = '') and (g = '') then WebInput := '';
  if (p = '') and (g <> '') then WebInput := g;
  if (p <> '') and (g = '') then WebInput := p;
  if (p <> '') and (g <> '') then WebInput := p+'&'+g;
  // mark if there is input
  isWebInput := (WebInput <> '');
  // view source code page
  if getValue('src',WebInput) = '1' then 
  begin
    ViewSource(SourcePath,loadGlyphs);
    Halt;
  end
  // always create page as form to accept input
  else
  begin
    writeWebHeader(loadGlyphs,false,customCSS);
    if isPOST then
      writeln('  <form method="post" action="',ExeName,'"><p>')
    else
      writeln('  <form method="get" action="',ExeName,'"><p>');
    writeln('  <!-- ***** begin of user code ***** --!>');
  end;
end;

procedure CloseHTML(const submit: boolean = true; const footer: string = ''; const credit: boolean = true);
begin
  // default form footer with submit button
  if submit then
  begin
    writeln('</p><hr/>');
    // submit button if there's any input element
    if InputCount > 0 then write('<input type="submit" value=" SUBMIT "/>');
    // custom user's footer
    if footer <> '' then writeln(footer);
    writeln('  <!-- end of user code --!>');
    writeln('  </form>');
  end
  // custom form footer
  else
  begin
    if footer <> '' then writeln(footer);
    writeln('</p><hr/>');
    // form footer
    writeln('  <!-- ***** end of user code ***** --!>');
    writeln('  </form>');
  end;
  // credit footer
  if credit then 
  begin
    // stop time
    tStop := Now;
    // credit footer
    write  ('  <p align="right" style="line-height:0.85em"><i><small>');
    writeln('Courtesy of <a href="/" target=_blank>pak.lebah.web.id</a>.<br/>');
    write  ('  This page is served in ',MilliSecondSpan(tStart,tStop):0:0,' ms by ');
    writeln('<a href="http://freepascal.org" target=_blank>Free Pascal</a>.</small></i>');
  end;
  // html footer
  write('</body></html>');
end;

procedure ClrScr;
begin
  OpenHTML;
end;

{ // writing output }

procedure WebWrite;
begin
  if LeftWidth = 0 then write('&nbsp;') else
    write('<span class="input" style="width:',LeftWidth,'px">&nbsp;</span>');
end;

procedure WebWrite(const str: string; const width: integer = 0);
begin
  if width = 0 then write(str) else
    write('<span class="input" style="width:',width,'px">',str,'</span>');
  LeftWidth := width;
end;

procedure WebWrite(const int: integer; const width: integer = 0); 
begin
  if width = 0 then write(int) else
    write('<span class="input" style="width:',width,'px">',int,'</span>');
  LeftWidth := width;
end;

procedure WebWrite(const int: int64; const width: integer = 0); 
begin
  if width = 0 then write(int) else
    write('<span class="input" style="width:',width,'px">',int,'</span>');
  LeftWidth := width;
end;

procedure WebWrite(const real: double; const width: integer = 0); 
begin
  if width = 0 then write(real) else
    write('<span class="input" style="width:',width,'px">',real,'</span>');
  LeftWidth := width;
end;

procedure WebWrite(const bool: boolean; const width: integer = 0);
begin
  if width = 0 then write(bool) else
    write('<span class="input" style="width:',width,'px">',bool,'</span>');
  LeftWidth := width;
end;

procedure WebWriteln;
begin
  writeln('<br/>');
end;

procedure WebWriteln(const str: string);
begin
  writeln(str,'<br/>');
end;

procedure WebWriteln(const int: integer);
begin
  writeln(int,'<br/>');
end;

procedure WebWriteln(const int: int64);
begin
  writeln(int,'<br/>');
end;

procedure WebWriteln(const real: double); 
begin
  writeln(real,'<br/>');
end;

procedure WebWriteln(const bool: boolean);
begin
  writeln(bool,'<br/>');
end;

{ // reading input }

procedure WebRead(const newLine: boolean = false);
begin
  if newLine then writeln('<br/>');
  CloseHTML;
end;

procedure WebRead(var str: string; const newLine: boolean = false);
var
  s: string;
begin
  s := readTextInput;
  if getKey('input_'+Int2Str(InputCount),webInput) then str := s else s := str;
  if str <> '' then writeTextInput(str,newLine,false)
    else writeTextInput('Type here...',newLine,true);
end;

procedure WebRead(var int: integer; const newLine: boolean = false);
var
  s: string;
begin
  s := readTextInput;
  // set input to var
  if getKey('input_'+Int2Str(InputCount),webInput) then 
  begin
    // valid input set var
    if IsInt(s) then 
    begin
      int := Str2Int(s);
      writeTextInput(s,newLine,false);
    end
    // invalid input reset to var
    else 
    begin
      if s = '' then
        writeTextInput(Int2Str(int),newLine,true)
      else
        writeTextInput('ERROR: Wrong input!',newLine,true);
    end;
  end
  // set input from var
  else
  begin
    // write default value
    if int <> 0 then
      writeTextInput(Int2Str(int),newLine,false)
    else
      writeTextInput('Type a number here...',newLine,true);
  end;
end;

procedure WebRead(var int: int64; const newLine: boolean = false);
var
  s: string;
begin
  s := readTextInput;
  if getKey('input_'+Int2Str(InputCount),webInput) then 
  begin
    if IsInt(s) then 
    begin
      int := Str2Int(s);
      writeTextInput(s,newLine,false);
    end
    else
    begin
      if s = '' then
        writeTextInput(Int2Str(int),newLine,true)
      else
        writeTextInput('ERROR: Wrong input!',newLine,true);
    end;
  end
  else
  begin
    if int <> 0 then
      writeTextInput(Int2Str(int),newLine,false)
    else
      writeTextInput('Type a number here...',newLine,true);
  end;
end;

procedure WebRead(var real: double; const newLine: boolean = false);
var
  s: string;
begin
  s := readTextInput;
  if getKey('input_'+Int2Str(InputCount),webInput) then 
  begin
    if IsFloat(s) then 
    begin
      real := Str2Float(s);
      writeTextInput(s,newLine,false);
    end
    else
    begin
      if s = '' then
        writeTextInput(Float2Str(real),newLine,true)
      else
        writeTextInput('ERROR: Wrong input!',newLine,true);
    end;
  end
  else
  begin
    if real <> 0 then
      writeTextInput(Float2Str(real),newLine,false)
    else
      writeTextInput('Type a number here...',newLine,true);
  end;
end;

procedure WebRead(var bool: boolean; const aLabel: string; const newLine: boolean = false);
var
  s: string;
begin
  s := readTextInput;
  if isWebInput then bool := (s = 'true'); // use isWebInput to enable initial value
  write('<label><input type="checkbox" ');
  write('id="cbInput_',InputCount,'" name="input_',InputCount,'" value="true"');
  if bool then write(' checked/>') else write('/>');
  write(' ',aLabel,' </label>');
  if newLine then writeln('<br/>') else writeln;
end;

procedure WebReadln;
begin
  CloseHTML;
end;

procedure WebReadln(var str: string);
begin
  WebRead(str,true);
end;

procedure WebReadln(var int: integer);
begin
  WebRead(int,true);
end;

procedure WebReadln(var int: int64);
begin
  WebRead(int,true);
end;

procedure WebReadln(var real: double);
begin
  WebRead(real,true);
end;

procedure WebReadln(var bool: boolean; const aLabel: string);
begin
  WebRead(bool,aLabel,true);
end;

{ // additional input }

function WebReadKey(const key: string): boolean;
begin
  Result := getKey(key,webInput);
end;

function WebReadVar(const key: string): string;
begin
  Result := HTTPDecode(getValue(key,WebInput));
end;

procedure WebReadMemo(var txt: string; const newLine: boolean = true);
var
  s: string;
begin
  s := readTextInput;
  if getKey('input_'+Int2Str(InputCount),webInput) then txt := s else s := txt;
  if isMobile then
    writeln('<textarea cols=34 rows=6 id="memoInput_',InputCount,'" name="input_',InputCount,'">')
  else
    writeln('<textarea cols=42 rows=8 id="memoInput_',InputCount,'" name="input_',InputCount,'">');
  write(s,'</textarea>');
  if newLine then writeln('<br/>') else writeln;
end;

function WebReadOption(var opt: integer; const labels: array of string; const newLine: boolean = false): string;
var
  i,p: integer;
  s: string;
begin
  Result := '';
  s := readTextInput;
  // get selected option
  if s <> '' then
  begin
    p := Pos('_',s);
    if p > 0 then opt := Str2Int(Copy(s,p+1,Length(s)));
  end;
  
  for i := 0 to High(labels) do
  begin
    // auto left align
    if newLine and (LeftWidth > 0) and (i > 0) then 
      write('<span class="input" style="width:',LeftWidth,'px"> </span>');
    write('<label><input type="radio" id="rbInput_',InputCount,'" ');
    write('name="input_',InputCount,'" value="option_',i+1,'"');
    // select option
    if opt = i+1 then 
    begin
      Result := labels[opt-1];
      if Result = '' then Result := 'option_'+Int2Str(opt);
      write(' checked/>');
    end
    else 
      write('/>');
    // write label
    write(' ',labels[i],' </label>');
    // option alignment
    if newLine then 
      writeln('<br/>')
    else 
    begin
      if i < High(labels) then writeln('&nbsp;│ ');
    end;
  end;
end;

function WebReadOption(var opt: integer; const csvLabels: string; const newLine: boolean = false): string;
var
  i,j,p: integer;
  c,s: string;
begin
  Result := '';
  s := readTextInput;
  // get selected option
  if s <> '' then
  begin
    p := Pos('_',s);
    if p > 0 then opt := Str2Int(Copy(s,p+1,Length(s)));
  end;
  j := getItemCount(csvLabels);
  for i := 1 to j do
  begin
    // auto left align
    if newLine and (LeftWidth > 0) and (i > 1) then 
      write('<span class="input" style="width:',LeftWidth,'px"> </span>');
    write('<label><input type="radio" id="rbInput_',InputCount,'" ');
    write('name="input_',InputCount,'" value="option_',i,'"');
    // select option
    c := getItemAt(csvLabels,i);
    if opt = i then 
    begin
      Result := c;
      if Result = '' then Result := 'option_'+Int2Str(opt);
      write(' checked/>');
    end
    else
      write('/>');
    // write label
    write(' ',c,' </label>');
    // option alignment
    if newLine then 
      writeln('<br/>')
    else 
    begin
      if i < j then writeln('&nbsp;│ ');
    end;
  end;
end;

function WebReadSelect(var sel: integer; const items: array of string; const newLine: boolean = false): string;
var
  i,p: integer;
  s: string;
begin
  Result := '';
  s := readTextInput;
  // get selected item
  if s <> '' then
  begin
    p := Pos('_',s);
    if p > 0 then sel := Str2Int(Copy(s,p+1,Length(s)));
  end;
  // list selection items
  writeln('<select name="input_',InputCount,'">');
  for i := 0 to High(items) do
  begin
    write('<option value="item_',i+1,'"');
    // select item
    if sel = i+1 then 
    begin
      Result := items[sel-1];
      if Result = '' then Result := 'item_'+Int2Str(sel);
      write(' selected');
    end;
    writeln('>',items[i],'</option>');
  end;
  writeln('</select>');
  if newLine then writeln('<br/>');
end;

function WebReadSelect(var sel: integer; const csvItems: string; const newLine: boolean = false): string;
var
  i,p: integer;
  c,s: string;
begin
  Result := '';
  s := readTextInput;
  // get selected item
  if s <> '' then
  begin
    p := Pos('_',s);
    if p > 0 then sel := Str2Int(Copy(s,p+1,Length(s)));
  end;
  // list selection items
  writeln('<select name="input_',InputCount,'">');
  for i := 1 to getItemCount(csvItems) do
  begin
    write('<option value="item_',i,'"');
    c := getItemAt(csvItems,i);
    // select item
    if sel = i then 
    begin
      Result := c;
      if Result = '' then Result := 'item_'+Int2Str(sel);
      write(' selected');
    end;
    writeln('>',c,'</option>');
  end;
  writeln('</select>');
  if newLine then writeln('<br/>');
end;

procedure WebReadButton(var clicked: boolean; const caption: string; const glyph: string = ''; const newLine: boolean = false);
begin
  clicked := (readTextInput = 'clicked');
  //write('onclick="return confirm(''Are you sure you want to delete this record?'')"');
  write('<button type="submit" id="btnInput_',InputCount,'" name="input_',InputCount,'" value="clicked">');
  if glyph <> '' then write('<span class="glyphicon glyphicon-',glyph,'" aria-hidden="true"></span>');
  write(caption,'</button>');
  if newLine then writeln('</br>');
end;

procedure WebButtonAction(var clicked: boolean; const caption: string; const action: string; const glyph: string = ''; const newLine: boolean = false);
begin
  clicked := (readTextInput = 'clicked');
  write('<button type="submit" id="act_',InputCount,'" name="input_',InputCount,'" value="clicked" formaction="',action,'">');
  if glyph <> '' then write('<span class="glyphicon glyphicon-',glyph,'" aria-hidden="true"></span>');
  write(caption,'</button>');
  if newLine then writeln('</br>');
end;

{ // additional output }

procedure WebWriteVar(const key, value: string);
begin
  Inc(InputCount); // increase input count to avoid conflict
  writeln('<input type="hidden" name="',key,'" value="',value,'">');
end;

procedure WebWriteBlock(const txt: string);
begin
  writeln('<blockquote>',txt,'</blockquote>');
end;

procedure WebWriteLine(const space: integer = 0; const width: integer = 50);
begin
  writeln('<hr align="left" width="'+IntToStr(width)+'%" style="margin:10px 10px 10px '+IntToStr(space)+'px" />');
end;

// Support BootStrap's glyphicon library. Make sure the css and font are installed correctly.
procedure WebPutGlyph(const gName: string; const caption: string = ''; const newLine: boolean = false);
begin
  write('<span class="glyphicon glyphicon-',gName,'" aria-hidden="true"></span>',caption);
  if newLine then writeln('<br>');
end;

function WebGetGlyph(const gName: string; const caption: string = ''; const asTitle: boolean = false): string;
begin
  if asTitle then 
    Result := '<span class="glyphicon glyphicon-'+gName+'" aria-hidden="true" title="'+caption+'"></span>'
  else
    Result := '<span class="glyphicon glyphicon-'+gName+'" aria-hidden="true"></span>'+caption;
end;

function WebGetLink(const url: string; const caption: string = ''; const newPage: boolean = false): string;
begin
  Result := '<a href="'+url+'"';
  if newPage then Result += ' target=_blank>' else Result += '>';
  if caption <> '' then Result += caption else Result += url;
  Result += '</a>';
end;

procedure WebPageHeader(const title: string; const level: integer = 0);
begin
  if level = 0 then
    writeln('<p><big><b>',title,'</b></big></p>')
  else
    writeln('<h',level,'>',title,'</h',level,'>');
end;

procedure WebPageTitle(const title: string; const subtitle: string);
begin
  writeln('<big><b>',title,'</b></big><br/>');
  writeln('<span style="font-size:0.85em">',subtitle,'</span><br/>');
end;

{ // table management }

procedure WebOpenTable(const headers: array of string; const aclass: string = ''; const aid: string = '');
var
  i: integer;
begin
  write('<table');
  if aclass <> '' then write(' class="',aclass,'"');
  if aid <> '' then write(' id="',aid,'"');
  writeln('>');
  if Length(headers) > 0 then
  begin
    write('<tr>');
    for i := 0 to High(headers) do
      write('<th>',headers[i],'</th>');
    writeln('</tr>');
  end;
end;

procedure WebOpenTable(const csvHeaders: string; const aclass: string = ''; const aid: string = '');
var
  c,i: integer;
begin
  write('<table');
  if aclass <> '' then write(' class="',aclass,'"');
  if aid <> '' then write(' id="',aid,'"');
  writeln('>');
  c := getItemCount(csvHeaders);
  if c > 0 then
  begin
    write('<tr>');
    for i := 1 to c do
      write('<th>',getItemAt(csvHeaders,i),'</th>');
    writeln('</tr>');
  end;
end;

procedure WebTableRow(const cells: array of string; const cols: integer = 0);
var
  i: integer;
begin
  if Length(cells) > 0 then
  begin
    write('<tr>');
    for i := 0 to High(cells) do
      if (cols > 0) and (i = High(cells)) then 
        write('<td colspan="',cols-High(cells),'">',cells[i],'</td>')
      else
        write('<td>',cells[i],'</td>');
    writeln('</tr>');
  end;
end;

procedure WebTableRow(const csvCells: string; const cols: integer = 0);
var
  i: integer;
begin
  if getItemCount(csvCells) > 0 then
  begin
    write('<tr>');
    for i := 1 to getItemCount(csvCells) do
      if (cols > 0) and (i = getItemCount(csvCells)) then 
        write('<td colspan="',cols-getItemCount(csvCells)+1,'">',getItemAt(csvCells,i),'</td>')
      else
        write('<td>',getItemAt(csvCells,i),'</td>');
    writeln('</tr>');
  end;
end;

procedure WebCloseTable;
begin
  writeln('</table>');
end;

{ // list management }

procedure WebOpenList(const isOrdered: boolean; const aclass: string = ''; const aid: string = '');
begin
  listOrdered := isOrdered;
  if isOrdered then write('<ol') else write('<ul');
  if aclass <> '' then write(' class="',aclass,'"');
  if aid <> '' then write(' id="',aid,'"');
  writeln('>');
end;

procedure WebListItem(const txt: string);
begin
  writeln('<li>',txt,'</li>');
end;

procedure WebCloseList;
begin
   if listOrdered then writeln('</ol>') else writeln('</ul>');
end;

{ // source code viewer }

// Using PrismJS to display syntax highlighted code. Make sure the css and font are installed correctly.
procedure ViewSource(srcPath: string = ''; const loadGlyphs: boolean = false);
var
  i: integer;
  srcFile: TStringList;
begin
  // if no source path is given, look at current directory
  if srcPath = '' then 
    srcPath := ChangeFileExt(ParamStr(0),'.pas')
  else
    srcPath := srcPath+'/'+ChangeFileExt(ExtractFileName(ParamStr(0)),'.pas');
  // page title
  writeWebHeader(loadGlyphs,true);
  writeln('Code of <code>',ExtractFileName(srcPath),'</code>:<br/>');
  // write source code
  srcFile := TStringList.Create;
  if FileExists(srcPath) then
  begin
    write('<pre class="line-numbers"><code class="language-pascal">');
    srcFile.LoadFromFile(srcPath);
    for i := 0 to srcFile.Count-1 do writeln(HTMLDecode(srcFile[i]));
    writeln('</code></pre>');
    // stop time
    tStop := Now;
    // credit footer
    write  ('<p align="right" style="line-height:0.8em"><i><small>');
    writeln('Courtesy of <a href="/" target=_blank>pak.lebah.web.id</a>.<br/>');
    write  ('This page is served in ',MilliSecondSpan(tStart,tStop):0:0,' ms by ');
    writeln('<a href="http://freepascal.org" target=_blank>Free Pascal</a>.</small></i>');
  end 
  // source file is not found
  else
    writeln('ERROR: Source file is not found.');
  srcFile.Free;
  // close html
  write('</body></html>');
end;

{ // en/de-coding }

function HTTPDecode(const txt: string): string;
var
  s,ss,r : PChar;
  h: string[3];
  l,c: integer;
begin
  l := Length(txt);
  SetLength(Result, l);
  if l = 0 then Exit;
  s := PChar(txt);
  ss := s;
  r := PChar(Result);
  while (s-ss) < l do
  begin
    case s^ of
      '+' : r^ := ' ';
      '%' : begin
              Inc(s);
              if (s-ss) < l then
              begin
                if s^ = '%' then 
                  r^ := '%'
                else
                begin
                  h := '$00';
                  h[2] := s^;
                  Inc(s);
                  if (s-ss) < l then
                  begin
                    h[3] := s^;
                    val(h, PByte(r)^, c);
                    if c <> 0 then r^ := ' ';
                  end;
                end;
              end;
            end;
      else
        r^ := s^;
    end;
    Inc(r);
    Inc(s);
  end;
  SetLength(Result, r-PChar(Result));
end;

function HTTPEncode(const txt: string): string;
const
  HTTPAllowed = 
  ['A'..'Z','a'..'z','*','@','.','_','-','0'..'9','$','!','''','(',')'];
var
  s,ss,r: PChar;
  h: string[2];
  l: integer;
begin
  l := Length(txt);
  SetLength(Result,l*3);
  if l = 0 then Exit;
  r := PChar(Result);
  s := PChar(txt);
  ss := s; 
  while (s-ss) < l do
  begin
    if s^ in HTTPAllowed then
      r^ := s^
    else if s^ = ' ' then
      r^ := '+'
    else
    begin
      r^ := '%';
      h := HexStr(Ord(s^),2);
      Inc(r);
      r^ := h[1];
      Inc(r);
      r^:= h[2];
    end;
    Inc(r);
    Inc(s);
  end;
  SetLength(Result, r-PChar(Result));
end;

function HTMLDecode(const txt: string): string;
begin
  Result := txt;
  Result := StringReplace(Result,'&','&amp;',[rfReplaceAll]);
  Result := StringReplace(Result,'<','&lt;' ,[rfReplaceAll]);
  Result := StringReplace(Result,'>','&gt;' ,[rfReplaceAll]);
end;

function HTMLEncode(const txt: string): string;
begin
  Result := txt;
  Result := StringReplace(Result,'&nbsp;',' ',[rfReplaceAll]);
  Result := StringReplace(Result,'&lt;'  ,'<',[rfReplaceAll]);
  Result := StringReplace(Result,'&gt;'  ,'>',[rfReplaceAll]);
  Result := StringReplace(Result,'&amp;' ,'&',[rfReplaceAll]);
end;

{ // type conversion }

function Int2Str(const i: integer): string;
begin
  Str(i,Result);
end;

function Int2Str(const i: int64): string;
begin
  Str(i,Result);
end;

function Float2Str(const f: double): string;
begin
  //Str(f:0:2,Result);
  Result := FloatToStr(f);
end;

function Bool2Str(const b: boolean): string;
begin
  if b then Result := 'TRUE' else Result := 'FALSE';
end;

function Str2Int(const s: string): integer;
var
  c: integer;
begin
  Val(s,Result,c);
  if c <> 0 then Result := 0;
end;

function Str2Int(const s: string): int64;
var
  c: integer;
begin
  Val(s,Result,c);
  if c <> 0 then Result := 0;
end;

function Str2Float(const s: string): double;
//var
  //c: integer;
begin
  //Val(s,Result,c);
  //if c <> 0 then Result := 0;
  Result := StrToFloat(s);
end;

function Str2Bool(s: string): boolean;
begin
  s := UpCase(s);
  case s of
    'TRUE','1','Y' : Result := true;
    'FALSE','0','N': Result := false;
    else Result := false;
  end;
end;

function isInt(const s: string): boolean;
var
  v,c: integer;
begin
  Val(s,v,c);
  Result := (c = 0);
end;

function isFloat(const s: string): boolean;
var
  v: double;
  c: integer;
begin
  Val(s,v,c);
  Result := (c = 0);
end;

function isMobile: boolean;
begin
  Result := (Pos('mobile',lowerCase(GetEnvironmentVariable('HTTP_USER_AGENT'))) > 0);
end;

{ // if..then..else shortcuts }

function switch(const condition: boolean; const strTrue, strFalse: string): string;
begin
  if condition then Result := strTrue else Result := strFalse;
end;

function switch(const condition: boolean; const intTrue, intFalse: integer): integer;
begin
  if condition then Result := intTrue else Result := intFalse;
end;

function switch(const condition: boolean; const intTrue, intFalse: int64): int64;
begin
  if condition then Result := intTrue else Result := intFalse;
end;

function switch(const condition: boolean; const realTrue, realFalse: double): double;
begin
  if condition then Result := realTrue else Result := realFalse;
end;

function switch(const condition: boolean; const boolTrue, boolFalse: boolean): boolean;
begin
  if condition then Result := boolTrue else Result := boolFalse;
end;

{ // main unit }

begin
  InputCount := 0;
  WebInput   := '';
  ExeName    := ExtractFileName(ParamStr(0));
end.
