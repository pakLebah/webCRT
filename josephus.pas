program JosephusProblem;

uses 
  webCRT;
  
type
  ArrayOfInteger = array of integer; // 0-based array
  
function FontColor(const s,c: string): string;
begin
  FontColor := '<font color="'+c+'">'+s+'</font> ';
end;

function FmtStr(const s: string; w: integer = 2): string;
var
  i,l: integer;
  r: string;
begin
  r := s;
  l := Length(r);
  if l > w then w := l;
  for i := 1 to w-l do r := ' '+r;
  FmtStr := r
end;

function Joseph(const men, int: integer): ArrayOfInteger;
  
  // count survivor
  function life(a: array of integer): integer;
  var
    i,l: integer;
  begin
    l := 0;
    for i := 0 to High(a) do 
      if a[i] <> 0 then l := l+1;
    life := l;
  end;
  
var
  a,m: ArrayOfInteger;
  c,i,j,k,l,x: integer;
  r: boolean;
  s: string;
begin
  // initialize array
  x := men-1;
  SetLength(a, men);
  SetLength(m, men);
  for i := 0 to x do m[i] := i+1;
  
  r := false;
  s := '';
  i := -1;
  j := 0;
  k := 0;
  c := 0;
  repeat
    // iterate victim
    i := i + 1;
    if i > x then 
    begin 
      i := 0;
      r := true;
    end;
    if m[i] <> 0 then j := j+1; // stepping
    
    // execute on interval
    if j = int then 
    begin
      a[i] := k+1;  // save step in 1-based
      k := k + 1;
      m[i] := 0;    // BANG!
      j := 0;
      
      // execution sequence
      s := s+FmtStr(Int2Str(i+1))+'| ';
      for l := 0 to x do
        // alive
        if m[l] <> 0 then
          s := s+FmtStr(Int2Str(m[l]))+' '
        else
        // mark the dead
        begin
          if l <> i then
            s := s+FontColor(FmtStr('x'),'red')
          else
          begin
            // last executed
            c := c + 1;
            if c = men then
              s := s+FontColor(FmtStr(' ♥︎'),'blue')
            else
              s := s+FontColor(FmtStr('x'),'blue');
          end;
        end;
        
      // mark on rotation
      if r then 
      begin
        if c <> men then
          s := s + '↩︎';
        r := false;
      end;
      
      s := s+LineEnding;
    end;
  until life(m) = 0; // until all dead
  
  // victim sequence 
  s := s + '    ';
  for l := 0 to x do
    s := s + FmtStr('__ ');
  s := s+LineEnding;
  s := s + '    ';
  for l := 0 to x do
    s := s + FmtStr(Int2Str(a[l])) + ' ';
  
  // print sequence
  webWrite('<pre>'+s+'</pre>');
  Joseph := a;
end;

(***** main program *****)

var
  s: string;
  i: integer;
  nov: integer = 0;
  iod: integer = 0;
  jos: ArrayOfInteger; // 0-based array
  
begin
  ClrScr;
  webWriteln('<big><b>Josephus Problem</b></big>');
  webWriteln('<span style="font-size:0.8em">Note: Number must not be zero.</span>');
  
  webWrite('<p>');
  webWrite('Input number of victim: ',160); webReadln(nov);
  webWrite('Input interval of dead: ',160); webReadln(iod);
  
  if (nov > 0) and (iod > 0) then
  begin
    if iod > nov then
      webWriteln(FontColor('<p>Error:','red')+
                 'The interval can <b>not</b> be larger than the victims.')
    else
    begin
      webWriteln('<p>Execution sequence:');
      jos := Joseph(nov,iod);
      
      // print function result
      s := '';
      webWrite('Josephus('+Int2Str(nov)+','+Int2Str(iod)+') = [');
      for i := 0 to High(jos) do 
        s := s + Int2Str(jos[i]) + ',';
      s := Copy(s,1,Length(s)-1);
      webWriteln(s+']');
      
      // select from sequence
      webWrite('ex: Victim number '+Int2Str(nov div 2)+' is ');
      webWriteln('executed in step '+Int2Str(jos[(nov div 2)-1])+'.');
      //webWriteln('The last man standing is number '+Int2Str(last)+'.');
    end;
  end;
  
  webReadln;
end.