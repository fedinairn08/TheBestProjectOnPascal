unit TableWin;

interface

uses Print, Resources, Functions, Cards;

type
  matrix = array of array of string;

///окно с таблицей карточек
procedure TableWindow();
///отработчик окна с таблицей карточек
procedure TableHandler();
///получение таблицы из списка всех карточек
function getAllCards() : matrix;
///занесение карточек в матрицу
function mapCardsToMatrix(allCards: listCards): matrix;
///создает таблицу из списка карточек
procedure setTable(listCard: listCards);
///фокус нажатия на номер карточки
function IsId(text: string): boolean;
///фокус нажатия на ФИО пациета
function IsName(text: string): boolean;
///переход в карточку по номеру карточки
function GetCardById(number: integer): card;
///переход в карточку по ФИО пациента
function GetCardByName(fio: string): card;
///очистка таблицы
procedure ResetTable();

implementation

const
  limit = 8;
  heightCell = 58;

var
  offset := 0; //смещение
  dateOffset := 0;  
  table: matrix;
  dateTable : matrix;

procedure TableWindow();
begin
  setlength(listButtons, 6);
  setlength(listFields, 0);
  setlength(listLabels, 0);
  
  with listButtons[0] do
  begin
    text := 'Номер карточки';
    loc.x1 := 100 - 100;
    loc.y1 := 40 - 30;
    loc.x2 := 100 + 100;
    loc.y2 := 40 + 30;
  end;
  
  with listButtons[1] do
  begin
    text := 'ФИО больного';
    loc.x1 := 600 - 400;
    loc.y1 := 40 - 30;
    loc.x2 := 600 + 400;
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
  
  var maxC := trunc(length(table) div limit) + 1;
  with listButtons[4] do
  begin
    text := inttostr(offset + 1) + ' из ' +  inttostr(maxC);
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
  
  if table = nil then
    table := getAllCards();
  
  var start := offset * limit;
  var n := length(listButtons);
  
  for var i := start to start + limit - 1 do
  begin
    var numberCell: string;
    var fioCell: string;
    if i < length(table) then
    begin
      numberCell := table[i][0];
      fioCell := table[i][1];
    end
    else
    begin
      numberCell := '';
      fioCell := '';
    end;
    SetLength(listButtons, length(listButtons) + 2);
    
    with listButtons[n] do
    begin
      text := numberCell;
      loc.x1 := 100 - 100;
      loc.y1 := 100 - 30 + heightCell * (i - limit * offset);
      loc.x2 := 100 + 100;
      loc.y2 := 100 + 30 + heightCell * (i - limit * offset);
    end;
    
    with listButtons[n + 1] do
    begin
      text := fioCell;
      loc.x1 := 600 - 400;
      loc.y1 := 100 - 30 + heightCell * (i - limit * offset);
      loc.x2 := 600 + 400;
      loc.y2 := 100 + 30 + heightCell * (i - limit * offset);
    end;
    
    n := n + 2;
    WindowHandler := TableHandler;
  end;
  printer();
end;

procedure TableHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    if (focusButton.text = 'Назад') then
    begin
      LastWindow();
      table := nil;
      offset := 0;
    end;
    
    if (focusButton.text = '<<<') then
      if offset > 0 then
      begin
        offset := offset - 1;
        TableWindow();
      end;
    
    if (focusButton.text = '>>>') then
      if (Length(table) > (offset + 1) * limit) then
        begin
          offset := offset + 1;
          TableWindow();
        end;
    
    
    if IsId(focusButton.text) = True then
    begin
      var IsCard: card;
      IsCard := GetCardById(strtoint(focusButton.text));
      CardWindow();
      fillCardFields(IsCard);
      ResetTable();
    end;
    
    if IsName(focusButton.text) = True then
    begin
      var IsCard: card;
      IsCard := GetCardByName(focusButton.text);
      CardWindow();
      fillCardFields(IsCard);
      ResetTable();
    end;
  end
end;

function getAllCards() : matrix;
begin
  var allCards := readCards();
  getAllCards := mapCardsToMatrix(allCards);
end;

function mapCardsToMatrix(allCards: listCards): matrix;
begin
  var tableCards: matrix;
  setLength(tableCards, length(allCards));
  for var i := 0 to length(allCards) - 1 do
  begin
    setLength(tableCards[i], 2);
    tableCards[i][0] := allCards[i].number.toString();
    tableCards[i][1] := allCards[i].FullNamePatient;
  end;
  mapCardsToMatrix := tableCards;
end;

procedure setTable(listCard: listCards);
begin
  table := mapCardsToMatrix(listCard);
end;

function IsId(text: string): boolean;
begin
  IsId := False;
  for var i := 0 to length(table) - 1 do
    if text = table[i][0] then
    begin
      IsId := True;
      break;
    end
end;

function IsName(text: string): boolean;
begin
  IsName := False;
  for var i := 0 to length(table) - 1 do
    if text = table[i][1] then
    begin
      IsName := True;
      break;
    end; 
end;

function GetCardById(number: integer): card;
begin
  var listCards := readCards();
  for var i := 0 to length(listCards) - 1 do
    if number = listCards[i].number then
    begin
      GetCardById := listCards[i];
      break;
    end;
end;

function GetCardByName(fio: string): card;
begin
  var listCards := readCards();
  for var i := 0 to length(listCards) - 1 do
    if fio = listCards[i].FullNamePatient then
    begin
      GetCardByName := listCards[i];
      break;
    end;
end;

procedure ResetTable();
begin
  table := nil;
end;

end.