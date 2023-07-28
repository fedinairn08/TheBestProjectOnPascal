unit DateVisitWin;

interface

uses resources, functions, print, cards, NotificationWin;

///отработчик окна добавления дат посещений и ФИО врача
procedure DataHandler();
///окно добавления дат посещений и ФИО врача
procedure DataWindow();
///возвращает дату посещения из полей
function ParseDateVisit(): dateVisit;
///процедура подготовки удаления даты посещения и ФИО врача из файла
procedure DeleteDate(DateForDeleting : dateVisit);
///сохранение даты посещения в файл
procedure saveDateVisit(dateVisit: dateVisit);
///чтение дат посещений из файла
function readDate() : listDate;
///установка номера карточки
procedure setCardNumber(cardNumber : integer);
///окно просмотра дат посещений и ФИО врача при поиске и удалении
procedure fillDateFields(existDate : dateVisit);
///процедура удаления
procedure deleteAll(number: integer);
///проверяет, есть ли такой номер карточки
function isPresent(number: integer) : boolean;

implementation

uses datetablewin;

procedure DataWindow();
begin
  setlength(listButtons, 2);
  setlength(listFields, 2);
  setlength(listLabels, 1);
  
  with listLabels[0] do
  begin
    text := 'Добавление даты и ФИО врача';
    fontSize := 40;
    with loc do
    begin
      x1 := 0;
      y1 := 0;
      x2 := WindowWidth;
      y2 := WindowHeight div 100 * 12;
    end;
  end;
  
  with listFields[0] do
  begin
    name := 'ФИО врача';
    length := 30;
    with loc do
    begin
      x1 := WindowWidth div 2 - 250;
      y1 := WindowHeight div 100 * 30 - 23;
      x2 := WindowWidth div 2 + 250;
      y2 := WindowHeight div 100 * 30 + 23;
    end;
  end;
  
   with listFields[1] do
  begin
    name := 'Дата посещения';
    length := 10;
    with loc do
    begin
      x1 := WindowWidth div 2 - 250;
      y1 := WindowHeight div 100 * 50 - 23;
      x2 := WindowWidth div 2 + 250;
      y2 := WindowHeight div 100 * 50 + 23;
    end;
  end;
  
  with listButtons[0] do
  begin
    text := 'Добавить';
    loc.x1 := WindowWidth div 100 * 43 - 100;
    loc.y1 := WindowHeight div 100 * 90 - 30;
    loc.x2 := WindowWidth div 100 * 43 + 100;
    loc.y2 := WindowHeight div 100 * 90 + 30;
  end;
  
  with listButtons[1] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 100 * 62 - 50;
    loc.y1 := WindowHeight div 100 * 90 - 30;
    loc.x2 := WindowWidth div 100 * 62 + 50;
    loc.y2 := WindowHeight div 100 * 90 + 30;
  end;
  
  WindowHandler := DataHandler;
  Printer();
end;

procedure DataHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();

    if (focusButton.text = 'Добавить') then
    begin
      if IsLetter(ListFields[0].text) = False then
      begin
        lastWindow := DataWindow;
        Notification('Введен неверный формат ФИО врача!');
        exit;
      end;
      
      if IsDate(ListFields[1].text) = False then
      begin
        lastWindow := DataWindow;
        Notification('Введен неверный формат даты посещения!');
        exit;
      end;
      
      begin
        var newDateVisit := ParseDateVisit();
        newDateVisit.number := numberCurrentCard;
        saveDateVisit(newDateVisit);
        DataTableWindow();
      end;
    end;
    
    if (focusButton.text = 'Назад') then
    begin
      DataTableWindow();
    end;
    
    if (focusButton.text = 'Удалить') then
    begin
      var DateVisit := ParseDateVisit();
      DateVisit.number := numberCurrentCard;
      DeleteDate(DateVisit);
      lastWindow();
    end;
    
  end
end;

function ParseDateVisit(): dateVisit;
begin
  result.FullNamePatient := listFields[0].text;
  result.VisitDate := listFields[1].text;
end;

procedure deleteAll(number: integer);
begin
  while isPresent(number) do
  begin
    var visit : dateVisit;
    visit.number := number;
    DeleteDate(visit);
  end;
end;

function isPresent(number: integer) : boolean;
begin
  var CurrentDate : dateVisit;
  seek(varDateFile, 0);
  result := false;
  while not Eof(varDateFile) do
  begin
    read(varDateFile, CurrentDate);
    if (number = CurrentDate.number) then
      begin
        result := true;
        break;
      end;
  end;
end;

procedure DeleteDate(DateForDeleting : dateVisit);
begin
  var CurrentDate : dateVisit;
  var CurrentNumber : integer;
  seek(varDateFile, 0);
  while not Eof(varDateFile) do
  begin
    read(varDateFile, CurrentDate);
    if (DateForDeleting.number = CurrentDate.number) then
      CurrentNumber := FilePos(varDateFile);
  end;
  
  seek(varDateFile, CurrentNumber - 1);
  for var i:=CurrentNumber - 1 to filesize(varDateFile) - 2 do
   begin
    seek(varDateFile, i + 1);
    read(varDateFile, CurrentDate);
    seek(varDateFile, i);
    write(varDateFile, CurrentDate);
   end;
   
  seek(varDateFile, filesize(varDateFile) - 1);
  truncate(varDateFile);
end;


procedure saveDateVisit(dateVisit: dateVisit);
begin
  Seek(varDateFile, FileSize(varDateFile));
  Write(varDateFile, dateVisit);
end;


function readDate() : listDate;
begin
  var listDate : listDate;
  var dateVisit : dateVisit;
  seek(varDateFile, 0);
  while not Eof(varDateFile) do
  begin
    read(varDateFile, dateVisit);
    setLength(listDate, length(listDate) + 1);
    listDate[length(listDate) - 1] := dateVisit;
  end;
  readDate := listDate;
end;


procedure fillDateFields(existDate : dateVisit);
begin
  ListFields[0].text := existDate.FullNamePatient;
  ListFields[1].text := existDate.VisitDate; 
  
  ListFields[0].blocktoupdate := true;
  ListFields[1].blocktoupdate := true;
  
  with listButtons[0] do
  begin
    text := 'Удалить';
    loc.x1 := WindowWidth div 100 * 43 - 100;
    loc.y1 := WindowHeight div 100 * 90 - 30;
    loc.x2 := WindowWidth div 100 * 43 + 100;
    loc.y2 := WindowHeight div 100 * 90 + 30;
  end;
    
    if CardAction = SearchCardAction then
      begin
        setlength(listButtons, 1);
        
        with listButtons[0] do
        begin
          text := 'Назад';
          loc.x1 := WindowWidth div 100 * 70 - 60;
          loc.y1 := WindowHeight div 100 * 83 - 30;
          loc.x2 := WindowWidth div 100 * 70 + 60;
          loc.y2 := WindowHeight div 100 * 83 + 30;
        end;
      end;
end;

procedure setCardNumber(cardNumber : integer);
begin
  numberCurrentCard := cardNumber;
end;

end.