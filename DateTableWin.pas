unit DateTableWin;

interface

uses Print, Resources, Functions, Cards, TableWin, DateVisitWin;

///окно с таблицей дат посещений и ФИО врача
procedure DataTableWindow();
///отработчик окна с таблицей дат посещений и ФИО врача
procedure DateTableHandler();
///получение таблицы из списка всех дат посещений
function getAllDates() : matrix;
///занесение дат посещений в матрицу
function mapDatesToMatrix(allDAte: listDate): matrix;
///переход в карточку по ФИО врача
function GetDateVisitByDoctor(fio: string): datevisit;
///переход в карточку по дате посещения
function GetDateVisitByDate(date: string): datevisit;
///фокус нажатия на ФИО врача
function IsDoctor(text: string): boolean;
///фокус нажатия на дату посещения
function IsDatevisit(text: string): boolean;

implementation

uses cards;

const
  limit = 8;
  heightCell = 58;

var
  dateOffset := 0;
  dateTable : matrix;

procedure DataTableWindow();
begin
  setlength(listButtons, 6);
  setlength(listFields, 0);
  setlength(listLabels, 0);
  
  with listButtons[0] do
  begin
    text := 'Дата посещения';
    loc.x1 := 150 - 150;
    loc.y1 := 40 - 30;
    loc.x2 := 150 + 150;
    loc.y2 := 40 + 30;
  end;
  
  with listButtons[1] do
  begin
    text := 'ФИО врача';
    loc.x1 := 700 - 400;
    loc.y1 := 40 - 30;
    loc.x2 := 700 + 400;
    loc.y2 := 40 + 30;
  end;
  
  with listButtons[2] do
  begin
    text := 'Назад';
    loc.x1 := 150 - 60;
    loc.y1 := 650 - 25;
    loc.x2 := 150 + 60;
    loc.y2 := 650 + 25;
  end;
  
  with listButtons[3] do
  begin
    text := '<<<';
    loc.x1 := 600 - 35;
    loc.y1 := 650 - 25;
    loc.x2 := 600 + 35;
    loc.y2 := 650 + 25;
  end;
  
  var maxC := trunc(length(dateTable) div limit) + 1;
  with listButtons[4] do
  begin
    text := inttostr(dateoffset + 1) + ' из ' +  inttostr(maxC);
    loc.x1 := 750 - 70;
    loc.y1 := 650 - 25;
    loc.x2 := 750 + 70;
    loc.y2 := 650 + 25;
  end;
  
  with listButtons[5] do
  begin
    text := '>>>';
    loc.x1 := 900 - 35;
    loc.y1 := 650 - 25;
    loc.x2 := 900 + 35;
    loc.y2 := 650 + 25;
  end;
  
  var test := CardAction;
  
  if CardAction <> SearchCardAction then
    begin
      setlength(listButtons, 7);
      with listButtons[6] do
      begin
        text := 'Добавить';
        loc.x1 := 400 - 75;
        loc.y1 := 650 - 25;
        loc.x2 := 400 + 75;
        loc.y2 := 650 + 25;
      end;
    end;
  
  dateTable := getAllDates();
  
  var start := dateoffset * limit;
  var n := length(listButtons);
  
  for var i := start to start + limit - 1 do
  begin
    var dataCell: string;
    var fioCell: string;
    if i < length(dateTable) then
    begin
      dataCell := dateTable[i][0];
      fioCell := dateTable[i][1];
    end
    else
    begin
      dataCell := '';
      fioCell := '';
    end;
    SetLength(listButtons, length(listButtons) + 2);
    
    with listButtons[n] do
    begin
      text := dataCell;
      loc.x1 := 150 - 150;
      loc.y1 := 100 - 30 + heightCell * (i - limit * dateoffset);
      loc.x2 := 150 + 150;
      loc.y2 := 100 + 30 + heightCell * (i - limit * dateoffset);
    end;
    
    with listButtons[n + 1] do
    begin
      text := fioCell;
      loc.x1 := 700 - 400;
      loc.y1 := 100 - 30 + heightCell * (i - limit * dateoffset);
      loc.x2 := 700 + 400;
      loc.y2 := 100 + 30 + heightCell * (i - limit * dateoffset);
    end;
    
    n := n + 2;
    WindowHandler := DateTableHandler;
  end;
  printer();
end;


procedure DateTableHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    if (focusButton.text = 'Назад') then
    begin
      reloadCard();
      dateoffset := 0;
    end;
    
    if (focusButton.text = 'Добавить') then
    begin
      lastWindow := DataTableWindow;
      DataWindow();
    end;
    
    if (focusButton.text = '<<<') then
      if dateoffset > 0 then
      begin
        dateoffset := dateoffset - 1;
        TableWindow();
      end;
    
    if (focusButton.text = '>>>') then
      if (Length(datetable) > (dateoffset + 1) * limit) then
        begin
          dateoffset := dateoffset + 1;
          TableWindow();
        end;
    
    
    if IsDatevisit(focusButton.text) = True then
    begin
      var visit: datevisit;
      visit := GetDateVisitByDate(focusButton.text);
      DataWindow();
      fillDateFields(visit);
      lastWindow := DataTableWindow;
    end;
    
    if IsDoctor(focusButton.text) = True then
    begin
      var visit: datevisit;
      visit := GetDateVisitByDoctor(focusButton.text);
      DataWindow();
      fillDateFields(visit);
      lastWindow := DataTableWindow;
    end;
  end
end;

function getAllDates() : matrix;
begin
  var AllDates := readDate();
  var j := 0;
  for var i := 0 to length(alldates) - 1 do
  begin
    if AllDates[i].number = numberCurrentCard then
    begin
      AllDates[j] := AllDates[i];
      j += 1;
    end;
  end;
  
  setlength(AllDates, j);
  
  getAllDates := mapDatesToMatrix(AllDates);
end;

function mapDatesToMatrix(allDAte: listDate): matrix;
begin
  var tableDAtes: matrix;
  setLength(tableDAtes, length(allDAte));
  for var i := 0 to length(allDAte) - 1 do
  begin
    setLength(tableDAtes[i], 2);
    tableDAtes[i][0] := allDAte[i].VisitDate.toString();
    tableDAtes[i][1] := allDAte[i].FullNamePatient;
  end;
  mapDatesToMatrix := tableDAtes;
end;

function IsDatevisit(text: string): boolean;
begin
  IsDatevisit := False;
  for var i := 0 to length(datetable) - 1 do
    if text = dateTable[i][0] then
    begin
      IsDatevisit := True;
      break;
    end
end;

function IsDoctor(text: string): boolean;
begin
  IsDoctor := False;
  for var i := 0 to length(datetable) - 1 do
    if text = dateTable[i][1] then
    begin
      IsDoctor := True;
      break;
    end; 
end;

function GetDateVisitByDate(date: string): datevisit;
begin
  var listDates := readDate();
  for var i := 0 to length(listDates) - 1 do
    if date = listDates[i].VisitDate then
    begin
      GetDateVisitByDate := listDates[i];
      break;
    end;
end;

function GetDateVisitByDoctor(fio: string): datevisit;
begin
  var listDates := readDate();
  for var i := 0 to length(listDates) - 1 do
    if fio = listDates[i].FullNamePatient then
    begin
      GetDateVisitByDoctor := listDates[i];
      break;
    end;
end;

end.