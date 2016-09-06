program Collatz5n;

uses
  FGL, webCRT;

type
  TIntegerList = specialize TFPGList<int64>;

var
  num   : TIntegerList;
  c,s,x : integer;  // default to 0
  nodiv3: boolean = false;
  plus1 : boolean = false;
  noalt : boolean = false;
  use3n : boolean = false;
  plus3 : boolean = false;
  btn   : boolean = false;
  js    : string = '';

function colorText(const s: string; const c: string = 'red'): string; inline;
begin
  Result := '<font color="'+c+'">'+s+'</font>';
end;

procedure Summary;
var
  g: boolean;
  i,j,len,min,max,glide,delay: int64;
begin
  webWriteln('<p><b>Summary:</b>');
  // initialize variables
  len := num.IndexOf(num.Last);
  delay := num.IndexOf(1);
  glide := num.First;
  min := num.First;
  max := num.First;
  g := false;
  // calculate summary
  for i := 0 to len do
  begin
    j := num[i];
    if ((c > 0) and (j < 0)) or   // quit on out of range
       ((c < 0) and (j > 0)) then Break;
    if j < min then min := j;
    if j > max then max := j;
    if (j < glide) and (not g) then
    begin
      glide := j;
      g := true;
    end;
  end;
  // print summary
  webWriteln('• n: '+Int2Str(c));
  webWriteln('• min: '+Int2Str(min)+' on step '+Int2Str(num.IndexOf(min)+1));
  webWriteln('• max: '+Int2Str(max)+' on step '+Int2Str(num.IndexOf(max)+1));
  if glide = num.First then
    webWriteln('• glide: – (none)')
  else
    webWriteln('• glide: '+Int2Str(glide)+' on step '+Int2Str(num.IndexOf(glide)+1));
  if delay > 0 then 
    webWriteln('• delay: '+Int2Str(delay+1)+' steps')
  else
  begin
    webWrite('• delay: infinite steps ');
    if ((c > 0) and (num.Last < 0)) or
       ((c < 0) and (num.Last > 0)) then
      webWriteln('(divergent)')
    else
      webWriteln('(closed loop)');
  end;
end;

procedure Collatz5(const n: int64);
var
  i: integer;
  d: boolean;
  r: string;
begin
  // sequence step
  s := s+1;
  r := Int2Str(s)+';';
  // check for double
  i := num.IndexOf(n);
  d := (i <> -1);
  if not d then num.Add(n);
  // print current n
  if n > 0 then r := r+'<code><big>'+(Int2Str(n))+'</big></code>;'
    else r := r+'<code><big>'+colorText(Int2Str(n))+'</big></code>;';
  (* compute next n *)
  // quit on out of range
  if ((c > 0) and (n < 0)) or ((c < 0) and (n > 0)) then
  begin
    webTableRow(r+colorText('out of range'));
    webTableRow(';Note: Max <b>n</b> is 64-bit integer or 2<sup>63</sup>;;');
    Exit;
  end
  // quit on loop (double n)
  else if d then
  begin
    webTableRow(r+'back to step <b>'+colorText(Int2Str(i+1))+'</b>');
    Exit;
  end
  // quit on finish (n=1)
  else if (n = 1) or (n = -1) then
  begin
    webTableRow(r+'done');
    Exit;
  end
  // check for even number
  else if (n mod 2 = 0) then
  begin
    webTableRow(r+'n/2');
    Collatz5(n div 2);
  end
  // check for division by 3
  else if (not nodiv3) and (n mod 3 = 0) then
  begin
    webTableRow(r+colorText('n/3','limegreen'));
    Collatz5(n div 3);
  end
  // check for odd number
  else
  begin
    // flip to +3 or +1
    if not noalt then plus3 := not plus3;
    if n < 0 then 
    begin  // check for negative
      if plus3 then
      begin
        webTableRow(r+colorText(Int2Str(x)+'n-3','blue'));
        Collatz5(x*n-3);
      end
      else
      begin
        webTableRow(r+colorText(Int2Str(x)+'n-1','fuchsia'));
        Collatz5(x*n-1);
      end;
    end    
    else  // compute on positive
    begin
      if plus3 then
      begin
        webTableRow(r+colorText(Int2Str(x)+'n+3','blue'));
        Collatz5(x*n+3);
      end
      else
      begin
        webTableRow(r+colorText(Int2Str(x)+'n+1','fuchsia'));
        Collatz5(x*n+1);
      end;
    end;
  end;
end;
  
(* main program *)

begin
  OpenHTML(true,true);
  // app page title
  webPageTitle('Another Collatz Conjecture: 5n+1 or 5n+3',
               'Note: Number must <b>not</b> be zero.');
  // input n
  webWrite('<p>');
  webWrite('Enter a number:',110); webRead(c);
  // button position on mobile
  if isMobile then 
  begin
    webWriteln;
    webWrite;
  end;
  webReadButton(btn,'GO','',true);
  // computation options
  webWrite('<p>');
  webWrite('Options:',110);
  webReadln(nodiv3,'no division by 3');     webWrite;
  webReadln(plus1 ,'start with Xn+3');      webWrite;
  webReadln(noalt ,'no switching');         webWrite;
  webReadln(use3n ,'use 3n instead of 5n');
  // compute sequence
  if isWebInput then 
  begin
    // apply options
    num := TIntegerList.Create;
    plus3 := not plus1;
    if noalt then plus3 := not plus3;
    if use3n then x := 3 else x := 5;
    // table styling
    writeln('<style>');
    writeln('table { font-size: 11pt; }');
    writeln('table td:nth-child(1) { text-align: right; }');
    writeln('table td:nth-child(2) { text-align: right; min-width: 140px; }');
    writeln('table td:nth-child(3) { text-align: center; font-size: smaller }');
    writeln('</style>');
    // print sequence
    webWriteln('<b>Result:</b>');
    webOpenTable('Step;N<small>step</small>;Operation','','t5n');
    Collatz5(c);
    webCloseTable;
    // summary
    Summary;
    num.Free;
    // js copy library
    writeln('<script src="https://cdn.jsdelivr.net/clipboard.js/1.5.12/clipboard.min.js"></script>');
    writeln('<script>new Clipboard(''.btn'');</script>'); 
  end;
  // copy button
  if c <> 0 then
    js := ' │ <button class="btn" data-clipboard-target="#t5n"> Copy Table to Clipboard </button>';
  CloseHTML(true,js);
end.