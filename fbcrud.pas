program FirebirdDemo;

uses
  SysUtils, Classes, DB, SQLDB, IBConnection, webCRT;

type
  TDBOperation = (dboSelect, dboInsert, dboDelete, dboUpdate);

const
  INPUT_LEFT: integer = 140;

var
  fb: TIBConnection;
  tr: TSQLTransaction;
  qr: TSQLQuery;
  tl: TStringList;
  dbo: TDBOperation;
  btn_v: boolean;
  tbl_n: string;
  tbl_i: integer;

procedure writeErrorMsg(const aTitle, aMsg: string); inline;
begin
  webWriteln('<p><font color="red"><b>'+aTitle+'</b>:</font> '+aMsg);
end;

function isMemoInputField(const field: string): boolean;
begin
  case lowercase(field) of
    'job_requirement' : Result := true;
    'proj_desc'       : Result := true;
    else Result := false;
  end;
end;

function isEditableTable(const table: string): boolean;
begin
  case lowercase(table) of
    'country'         : Result := true;
    'customer'        : Result := true;
    'department'      : Result := false;
    'employee'        : Result := false;
    'employee_project': Result := false;
    'job'             : Result := false;
    'phone_list'      : Result := true;
    'project'         : Result := true;
    'proj_dept_budget': Result := false;
    'salary_history'  : Result := false;
    'sales'           : Result := false;
    else Result := false;
  end;
end;

function PKFieldCount(const table: string): integer;
begin
  case lowercase(table) of
    'country'         : Result := 1;
    'customer'        : Result := 1;
    'department'      : Result := 1;
    'employee'        : Result := 1;
    'employee_project': Result := 2;
    'job'             : Result := 3;
    'phone_list'      : Result := 1;
    'project'         : Result := 1;
    'proj_dept_budget': Result := 3;
    'salary_history'  : Result := 3;
    'sales'           : Result := 1;
    else Result := 1;
  end;
end;

procedure SetupDB; inline;
begin
  // resource setup
  tl := TStringList.Create;
  qr := TSQLQuery.Create(nil);
  tr := TSQLTransaction.Create(nil);
  fb := TIBConnection.Create(nil);
  // db setup
  fb.Hostname     := 'localhost';
  fb.DatabaseName := 'employee.fdb';
  fb.Username     := 'fbadmin';
  fb.Password     := 'firebird';
  fb.Charset      := 'UTF8';
  fb.Dialect      := 3;  
  // connection setup
  fb.Transaction := tr;
  tr.Database    := fb;
  qr.Database    := fb;
  qr.Transaction := tr;
end;

procedure CleanDB; inline;
begin
  // free resource
  tl.Free;
  qr.Free;
  tr.Free;
  fb.Free;
end;

procedure SelectData;
var
  i,col,row: integer;
  s,fl,vl: string;
  btn: boolean;
begin
  webWriteln('<p>Show records: ');
  // avoid blob column on some tables
  if tbl_n = 'JOB' then 
    s := 'select job_code, job_grade, job_country, job_title, min_salary, max_salary, job_requirement from '+tbl_n
  else if tbl_n = 'PROJ_DEPT_BUDGET' then
    s := 'select fiscal_year, proj_id, dept_no, projected_budget from '+tbl_n
  else
    s := 'select * from '+tbl_n;
  s := s + ' order by 1 asc nulls first';
  // view data from selected table
  qr.SQL.Text := s+';';
  try
    qr.Open;
    col := qr.Fields.Count;
    writeln('<style>table td:nth-child('+Int2Str(col+1)+') { text-align: right }</style>');
    // print field name
    s := ''; fl := '';
    for i := 0 to col-1 do 
    begin
      s := s+qr.Fields[i].FieldName+csvSplitter;
      // column alignment based on field data type
      if qr.FieldDefs[i].DataType in [ftSmallInt,ftInteger,ftWord,
                                      ftFloat,ftCurrency,ftBCD,ftFMTBcd,
                                      ftDateTime,ftDate,ftTime,ftTimeStamp] then
        writeln('<style>table td:nth-child('+Int2Str(i+1)+') { text-align: right }</style>')
      else if qr.FieldDefs[i].DataType in [ftFixedChar] then
        writeln('<style>table td:nth-child('+Int2Str(i+1)+') { text-align: center }</style>');
      // save field id
      if isEditableTable(tbl_n) and (i < PKFieldCount(tbl_n)) then
        fl := fl+'&field_'+Int2Str(i+1)+'='+qr.Fields[i].FieldName;
    end;
    if isEditableTable(tbl_n) then s := s+'ACTION';
    webOpenTable(s);
    // print field data
    row := 0;
    while not qr.EOF do
    begin
      s := ''; vl := '';
      row := row+1;
      for i := 0 to col-1 do
      begin
        // text formatting based on field data type
        if qr.FieldDefs[i].DataType in [ftFloat] then
          s := s+FormatFloat('#0.000',qr.Fields.Fields[i].AsFloat)
        else if qr.FieldDefs[i].DataType in [ftCurrency,ftBCD,ftFMTBcd] then
          s := s+FormatFloat('#,##0.00',qr.Fields.Fields[i].AsCurrency)
        else if qr.FieldDefs[i].DataType in [ftDateTime,ftDate] then
          s := s+FormatDateTime('dd-mm-yyyy',qr.Fields.Fields[i].AsDateTime)
        else if qr.FieldDefs[i].DataType in [ftTime,ftTimeStamp] then
          s := s+FormatDateTime('dd-mm-yyyy hh:nn:ss',qr.Fields.Fields[i].AsDateTime)
        else
          s := s+qr.Fields.Fields[i].AsString;
        s := s+csvSplitter;
        // save field value
        if isEditableTable(tbl_n) and (i < PKFieldCount(tbl_n)) then
          vl := vl+'&value_'+Int2Str(i+1)+'='+HTTPEncode(qr.Fields.Fields[i].AsString);
      end;
      // build data id into command link
      if isEditableTable(tbl_n) then
        s := s+webGetLink('?action=update&table='+tbl_n+fl+vl,
                          webGetGlyph('pencil','Edit record',true))+' │ '
              +webGetLink('?action=delete&table='+tbl_n+fl+vl,
                          webGetGlyph('remove','Delete record',true));
      webTableRow(s);
      qr.Next;
    end;
    webCloseTable;
    if isEditableTable(tbl_n) then webButtonAction(btn,' New record','?action=insert','plus');
    // print data summary
    webWriteln('<p>Summary:');
    webOpenList(false);
    webListItem('Table: '  +tbl_n);
    webListItem('Columns: '+Int2Str(col));
    webListItem('Rows: '   +Int2Str(row));
    webCloseList;
    qr.Close;
  // catch error
  except
    on E: Exception do writeErrorMsg(E.ClassName,E.Message);
  end;
end;

procedure InsertData;
var
  s: string;
  fc,i: integer;
  btn: boolean;
  data: array of string;
begin
  webWriteln('<p>New record: ');
  try
    // read data structure
    qr.SQL.Text := 'select * from '+tbl_n+' rows 1;';
    qr.Open;
    // required to override insert button
    webWriteVar('table',tbl_n);
    // field input
    fc := qr.Fields.Count;
    SetLength(data,fc);
    for i := 0 to fc-1 do
    begin
      webWrite(qr.Fields[i].FieldName,INPUT_LEFT);
      webWrite(':',10);
      if isMemoInputField(qr.Fields[i].FieldName) then 
        webReadMemo(data[i]) else webReadln(data[i]);
    end;
    qr.Close;
    // command button
    webWrite('<p>'); webWrite('',INPUT_LEFT+10);
    webButtonAction(btn,'INSERT','?action=insert','',true);
    // execute
    if btn then
    begin
      // build command
      s := 'insert into '+tbl_n+' values (';
      for i := 0 to fc-1 do s := s+''''+data[i]+''',';
      s := Copy(s,1,Length(s)-1)+');';
      // execute command
      qr.SQL.Text := s;
      (* // skip on demo
      qr.ExecSQL;
      tr.Commit; *)
      webWriteBlock('<b>Generated SQL</b>:<br/><code>'+s+'</code>');
      webWriteln('<p>New data inserted successfully!');
    end;
  except
    on E: Exception do writeErrorMsg(E.ClassName,E.Message);
  end;
end;

procedure DeleteData;
var
  i: integer;
  s,w: string;
  btn: boolean;
begin
  webWriteln('<p>Remove record: ');
  try
    // read data id
    tbl_n := webReadVar('table');
    w := webReadVar('where');
    if w = '' then
    begin
      // build where clause
      webWriteVar('table',tbl_n);
      for i := 1 to PKFieldCount(tbl_n) do
        w := w+webReadVar('field_'+Int2Str(i))+'='+
             ''''+webReadVar('value_'+Int2Str(i))+''' and ';
      w := Copy(w,1,Length(w)-5);
      webWriteVar('where',w);
      // read data structure
      qr.SQL.Text := 'select * from '+tbl_n+' where '+w;
      qr.Open;
      // show selected data
      for i := 0 to qr.Fields.Count-1 do
      begin
        webWrite(qr.Fields[i].FieldName,INPUT_LEFT);
        webWrite(':',10);
        webWriteln(qr.Fields.Fields[i].AsString);
      end;
      qr.Close;
      // command button
      webWrite('<p>'); webWrite('',INPUT_LEFT+10);
      webButtonAction(btn,'DELETE','?action=delete','',true);
    end
    // execute
    else
    begin
      // execute command
      s := 'delete from '+tbl_n+' where '+w+';';
      qr.SQL.Text := s;
      (* // skip on demo
      qr.ExecSQL;
      tr.Commit; *)
      webWriteBlock('<b>Generated SQL</b>:<br/><code>'+s+'</code>');
      webWriteln('<p>Old data deleted successfully!');
    end;
  except
    on E: Exception do writeErrorMsg(E.ClassName,E.Message);
  end;
end;

procedure UpdateData;
var
  s,w: string;
  fc,i: integer;
  btn: boolean;
  data: array of string;
begin
  webWriteln('<p>Update record: ');
  try
    // read data id
    tbl_n := webReadVar('table');
    webWriteVar('table',tbl_n);
    w := webReadVar('where');
    if w = '' then
    begin
      // build where clause
      for i := 1 to PKFieldCount(tbl_n) do
        w := w+webReadVar('field_'+Int2Str(i))+'='+
             ''''+webReadVar('value_'+Int2Str(i))+''' and ';
      w := Copy(w,1,Length(w)-5);
    end;
    // show selected data
    qr.SQL.Text := 'select * from '+tbl_n+' where '+w+';';
    qr.Open;
    // field input
    s := '';
    fc := qr.Fields.Count;
    SetLength(data,fc);
    for i := 0 to fc-1 do
    begin
      webWrite(qr.Fields[i].FieldName,INPUT_LEFT);
      webWrite(':',10);
      data[i] := qr.Fields.Fields[i].AsString;
      if isMemoInputField(qr.Fields[i].FieldName) then 
        webReadMemo(data[i]) else webReadln(data[i]);
      // build new value list
      s := s+qr.Fields[i].FieldName+'='''+data[i]+''', ';
    end;
    s := Copy(s,1,Length(s)-2);
    qr.Close;
    // this new var must be issued last to prevent interference with input var
    webWriteVar('where',w);
    // command button
    webWrite('<p>'); webWrite('',INPUT_LEFT+10);
    webButtonAction(btn,'UPDATE','?action=update','',true);
    // execute
    if btn then
    begin
      // build command
      s := 'update '+tbl_n+' set '+s+' where '+w+';';
      // execute command
      qr.SQL.Text := s;
      (* // skip on demo
      qr.ExecSQL;
      tr.Commit; *)
      webWriteBlock('<b>Generated SQL</b>:<br/><code>'+s+'</code>');
      webWriteln('<p>Data updated successfully!');
    end;
  except
    on E: Exception do writeErrorMsg(E.ClassName,E.Message);
  end;
end;

(*** main program ***)

var
  i: integer;
  s: string;

begin
  OpenHTML(true,true);
  csvSplitter := '|';
  SetupDB;

  try
    // open db
    fb.Open;
    if fb.Connected then fb.GetTableNames(tl);
    // show available tables
    webPageHeader('Firebird - SQLdb CRUD Demo');
    webWrite('<p>Table: ');
    for i := 0 to tl.Count-1 do 
    begin
      s := s+tl[i]+csvSplitter;
      // allow select from web var
      if webReadVar('table') = tl[i] then tbl_i := i+1;
    end;
    // select table
    tbl_n := webReadSelect(tbl_i,s);
    webReadButton(btn_v,'VIEW');
    webWriteln;
    // check db operation mode
    if webReadVar('action') = 'update' then dbo := dboUpdate 
      else if webReadVar('action') = 'delete' then dbo := dboDelete
        else if webReadVar('action') = 'insert' then dbo := dboInsert
          else dbo := dboSelect;
    // process data
    if isWebInput then
      case dbo of
        dboSelect: SelectData;
        dboInsert: InsertData;
        dboDelete: DeleteData;
        dboUpdate: UpdateData;
      end;
    // close db
    fb.Close;
  finally
    CleanDB;
  end;
  
  CloseHTML(false);
end.