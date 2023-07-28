unit Search;

interface

uses Print, Resources, Functions, MenuWin, NotificationWin, TableWin, Cards;

///окно поиска 
procedure SearchWindow();
///отработчик окна поиска
procedure SearchHandler();
///поиск карточки по введенному значению
function SearchCards() : boolean;

implementation

procedure SearchWindow();
begin
  setlength(listButtons, 2);
  setlength(listFields, 5);
  setlength(listLabels, 1);
  
  with listLabels[0] do
  begin
    text := 'Карточка больного';
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
    name := 'Номер карточки';
    length := 5;
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
    name := 'ФИО больного';
    length := 30;
    with loc do
    begin
      x1 := WindowWidth div 2 - 250;
      y1 := WindowHeight div 100 * 50 - 23;
      x2 := WindowWidth div 2 + 250;
      y2 := WindowHeight div 100 * 50 + 23;
    end;
  end;
  
  with listFields[2] do
  begin
    name := 'Дата рождения больного';
    length := 10;
    with loc do
    begin
      x1 := WindowWidth div 2 - 250;
      y1 := WindowHeight div 100 * 70 - 23;
      x2 := WindowWidth div 2 + 250;
      y2 := WindowHeight div 100 * 70 + 23;
    end;
  end;
  
  with listButtons[0] do
  begin
    text := 'Поиск';
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
  
  WindowHandler := SearchHandler;
  Printer();
end;

procedure SearchHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    
    if (focusButton.text = 'Поиск') then
    begin
      var searched := SearchCards();
      if searched then
      begin
        TableWindow();
        lastWindow := SearchWindow;
      end;
      
    end;
    
    if (focusButton.text = 'Назад') then
    begin
      TableWin.ResetTable();
      if CurrentUser.role = '1' then
        UserMenu()
      else
        AdminMenu();
    end
  end;
end;

function SearchCards() : boolean;
begin
  var cards := readCards();
  var j:=0;
  for var i := 0 to length(cards) - 1 do
  begin
    var skip: boolean;
    skip := false;
    
    if IsLetter(ListFields[0].text) = False then
      begin
        if listFields[0].text <> '' then
          if cards[i].number <> strToInt(listFields[0].text) then
          begin
            skip:=true;
          end;
      end;
    
    if listFields[1].text <> '' then
      if cards[i].FullNamePatient <> listFields[1].text then    
      begin
        skip:=true;
      end;
      
    if listFields[2].text <> '' then
      if cards[i].BirthDate <> listFields[2].text then
      begin
        skip:=true;
      end;
    
    if listFields[3].text <> '' then
      if cards[i].FullNameDoctor <> listFields[3].text then
      begin
        skip:=true;
      end;
      
    if not skip then
      begin
        cards[j] := cards[i];
        j+=1;
      end
  end;
  setlength(cards,j);
  
  if Length(cards) <> 0 then
    begin
      setTable(cards);
    end
  else
    begin
      lastWindow := SearchWindow;
      Notification('Неверные данные! По вашему запросу ничего не найдено.');
    end;
  SearchCards := Length(cards) <> 0;
end;

end.