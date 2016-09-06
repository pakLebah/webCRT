program wordpc;

{$MODE OBJFPC}{$H+}{$J-}
{$ASSERTIONS ON}

uses webCRT;

function int2str(i: integer): string;
begin
  str(i,Result);
end;

function str2int(s: string): integer;
var
  c: word;
  i: integer;
begin
  i := 0;
  val(s,i,c);
  if c = 0 then Result := i
  else Assert(c=0,'EConvertError: invalid integer');
end;

(* MAIN PROGRAM *)

var
  i: integer;
  v: byte;
  s: string;
  w: word;
begin
  clrscr;
  webwriteln('<b>WORD PERCENTAGE CALCULATOR</b>');
  webwriteln('<small>Method: A = 1 ... Z = 26; number = its value; others = 0</small>');
  webwrite('<p>Type something ');
  webreadln(s);
  // calculate input
  if s <> '' then
  begin
    webwriteln('Result:');
    s := upcase(s);
    webwrite(s+' = ');
    // calculate each letter
    w := 0;
    for i := 1 to length(s) do
    begin
      // get the value of the letter
      if s[i] in ['A'..'Z'] then
        v := ord(s[i])-64
      else if s[i] in ['0'..'9'] then
        v := ord(s[i])-48
      else
        v := 0; // not unicode friendly
      // show value addition
      if i < length(s) then
        webwrite(int2str(v)+'+')
      else
        webwrite(int2str(v)+' = ');
      // sum them all up
      w := w + v;
    end;
    webwrite(int2str(w)+'%');
  end;
  webreadln;
end.