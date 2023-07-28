unit Cards;

interface

uses Resources, Functions, MenuWin;

type
  card = record
    number: integer;
    FullNamePatient: string[30];
    BirthDate: string[10];
    FullNameDoctor: string[30];
    someDate : string[10];
  end;
  
  cardFile = file of card;
  listCards = array of card;
  
var
  VarCardFile: cardFile; 
  numberInteger: integer;
  numberCurrentCard : integer;

///сохранение карточки в файл
procedure SaveCard(card: card);
///чтение карточек из файла
function readCards() : listCards;
///окно для заполнения данных карточки
procedure CardWindow();
///отработчики команд на данном экране
procedure CardHandler();
///возвращает карточку из полей
function ParseCard(): Card;
///окно просмотра карточки у пользователя и администратора
procedure fillCardFields(existCard : card);
///удаление карточки из файла
procedure DeleteCard(CardForDeleting : card);
///изменение карточки
procedure UpdateCard(CardForUpdating : card);
///проверка на то, свободен ли номер
function CheckNumber(CurrentCard : integer) : boolean;
///отработчик окна уведомления, уточняющего удаление карточки
procedure CardDeletingNotificationHandler(dialogResult : boolean);
function GetCardNumber(): integer;
procedure reloadCard();

implementation

uses HomeWin, Print, Functions, NotificationWin, TableWin, datetablewin, datevisitwin;

var savedCard : card;

procedure fillCardFields(existCard : card);
begin
  
  setlength(listButtons, 2);
  ListFields[0].text := inttostr(existCard.number);
  ListFields[1].text := existCard.FullNamePatient; 
  ListFields[2].text := existCard.BirthDate;
  
  with listButtons[0] do
      begin
        text := 'Даты посещений и ФИО врача';
        loc.x1 := WindowWidth div 100 * 50 - 300;
        loc.y1 := WindowHeight div 100 * 85 - 30;
        loc.x2 := WindowWidth div 100 * 50 + 100;
        loc.y2 := WindowHeight div 100 * 85 + 30;
      end;
  
  with listButtons[1] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 100 * 70 - 60;
    loc.y1 := WindowHeight div 100 * 85 - 30;
    loc.x2 := WindowWidth div 100 * 70 + 60;
    loc.y2 := WindowHeight div 100 * 85 + 30;
  end;
  
  ListFields[0].blocktoupdate := true;
  ListFields[1].blocktoupdate := true;
  ListFields[2].blocktoupdate := true;
  
  if CardAction = EditCardAction then
    begin
      setlength(listButtons, 3);
     
      with listButtons[0] do
      begin
        text := 'Даты посещений и ФИО врача';
        loc.x1 := WindowWidth div 100 * 40 - 300;
        loc.y1 := WindowHeight div 100 * 85 - 30;
        loc.x2 := WindowWidth div 100 * 40 + 100;
        loc.y2 := WindowHeight div 100 * 85 + 30;
      end;
      
      with listButtons[2] do
      begin
        text := 'Назад';
        loc.x1 := WindowWidth div 100 * 85 - 50;
        loc.y1 := WindowHeight div 100 * 85 - 30;
        loc.x2 := WindowWidth div 100 * 85 + 50;
        loc.y2 := WindowHeight div 100 * 85 + 30;
      end;
      
      with listButtons[1] do
      begin
        text := 'Изменить карточку';
        loc.x1 := WindowWidth div 100 * 65 - 135;
        loc.y1 := WindowHeight div 100 * 85 - 30;
        loc.x2 := WindowWidth div 100 * 65 + 135;
        loc.y2 := WindowHeight div 100 * 85 + 30;
      end;
      
      ListFields[1].blocktoupdate := false;
      ListFields[2].blocktoupdate := false;
    end;
    
    if CardAction = DeleteCardAction then
      begin
        
        setlength(listButtons, 2);
        with listButtons[0] do
        begin
          text := 'Назад';
          loc.x1 := WindowWidth div 100 * 70 - 50;
          loc.y1 := WindowHeight div 100 * 85 - 30;
          loc.x2 := WindowWidth div 100 * 70 + 50;
          loc.y2 := WindowHeight div 100 * 85 + 30;
        end;
        
        with listButtons[1] do
        begin
          text := 'Удалить карточку';
          loc.x1 := WindowWidth div 100 * 38 - 130;
          loc.y1 := WindowHeight div 100 * 85 - 30;
          loc.x2 := WindowWidth div 100 * 38 + 130;
          loc.y2 := WindowHeight div 100 * 85 + 30;
        end;
      end;
end;

procedure SaveCard(card: card);
begin
  Seek(VarCardFile, FileSize(VarCardFile));
  Write(VarCardFile, card);
end;

function readCards() : listCards;
begin
  var listCards : listCards;
  var card : card;
  seek(VarCardFile, 0);
  while not Eof(VarCardFile) do
  begin
    read(VarCardFile, card);
    setLength(listCards, length(listCards) + 1);
    listCards[length(listCards) - 1] := card;
  end;
  readCards := listCards;
end;

procedure CardWindow();
begin
  setlength(listButtons, 2);
  setlength(listFields, 4);
  setlength(listLabels, 1);
  
  ListFields[0].blocktoupdate := true;
  
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
  
  var currentNumber := GetCardNumber();
  listFields[0].text := inttostr(currentNumber + 1);
  
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
    text := 'Создать карточку';
    loc.x1 := WindowWidth div 100 * 38 - 130;
    loc.y1 := WindowHeight div 100 * 85 - 30;
    loc.x2 := WindowWidth div 100 * 38 + 130;
    loc.y2 := WindowHeight div 100 * 85 + 30;
  end;
  
  with listButtons[1] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 100 * 70 - 50;
    loc.y1 := WindowHeight div 100 * 85 - 30;
    loc.x2 := WindowWidth div 100 * 70 + 50;
    loc.y2 := WindowHeight div 100 * 85 + 30;
  end;
  
  WindowHandler := CardHandler;
  Printer();
end;

procedure CardHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();

    if (focusButton.text = 'Создать карточку') then
    begin
      if (length(listFields[1].text) = 0) 
      or (length(listFields[2].text) = 0) 
       then
      begin
        lastWindow := CardWindow;
        Notification('Ошибка ввода данных! Вы не заполнили обязательные поля.');
        exit;
      end;
      
      if IsLetter(ListFields[1].text) = False then
      begin
        lastWindow := CardWindow;
        Notification('Введен неверный формат ФИО пациента!');
        exit;
      end;
      
      if IsDate(ListFields[2].text) = False then
      begin
        lastWindow := CardWindow;
        Notification('Введен неверный формат даты рождения пациента!');
        exit;
      end;

      begin
        var currentCard := parseCard();
        SaveCard(currentCard);
      end;
    end;
      
    if (focusButton.text = 'Назад') then
    begin
      if CurrentUser.role = '1' then
        UserMenu()
      else
        AdminMenu();
    end;
    
    if (focusButton.text = 'Изменить карточку') then
    begin
      var CurrentCardForUpdating := parseCard();
      UpdateCard(CurrentCardForUpdating);
      lastWindow();
    end;
    
    if (focusButton.text = 'Даты посещений и ФИО врача') then
      begin
        savedCard := parseCard();
        numberCurrentCard:= parseCard().number;
        DataTableWindow();
      end;
    
    if (focusButton.text = 'Удалить карточку') then
    begin
      NotificationsHandler := CardDeletingNotificationHandler;
      NotificationAboutDelete('После нажатия кнопки "Да" будет удалена карточка. Подтвердите удаление карточки');
    end;
  end
end;

procedure reloadCard();
begin
  CardWindow();
  fillCardFields(savedCard);
end;

function GetCardNumber(): integer;
begin
  var readFile : listCards;
  var maxNumber : integer = 0;
  readFile := readCards();
  for var i :=0 to length(readFile) - 1 do
  begin
    var card := readFile[i];
    if card.number > maxNumber then
      maxNumber := card.number;
  end;
    
  result := maxNumber;
end;

function ParseCard(): Card;
begin
  var 
    card : card;
  card.number := strtoint(listFields[0].text);
  card.FullNamePatient := listFields[1].text;
  card.BirthDate := listFields[2].text;
  card.FullNameDoctor := listFields[3].text;
  result := card;
end;

procedure DeleteCard(CardForDeleting : card);
begin
  var CurrentCard : card;
  var CurrentNumber : integer;
  seek(VarCardFile, 0);
  while not Eof(VarCardFile) do
  begin
    read(VarCardFile, CurrentCard);
    if (CardForDeleting.number = CurrentCard.number) then
      CurrentNumber := FilePos(VarCardFile);
  end;
  
  seek(VarCardFile, CurrentNumber);
  for var i:=CurrentNumber - 1 to filesize(VarCardFile) - 2 do
   begin
    seek(VarCardFile, i + 1);
    read(VarCardFile, CurrentCard);
    seek(VarCardFile, i);
    write(VarCardFile, CurrentCard);
   end;
   
  seek(VarCardFile, filesize(VarCardFile) - 1);
  truncate(VarCardFile);
  deleteAll(CardForDeleting.number);
end;

procedure UpdateCard(CardForUpdating : card);
begin
  var CurrentCard : card;
  var CurrentNumber : integer;
  seek(VarCardFile, 0);
  while not Eof(VarCardFile) do
  begin
    read(VarCardFile, CurrentCard);
    if (CardForUpdating.number = CurrentCard.number) then
    begin
      CurrentNumber := FilePos(VarCardFile);
      break;
    end;
  end;
  
  DeleteCard(CardForUpdating);
  seek(VarCardFile, CurrentNumber - 1);
  write(VarCardFile, CardForUpdating);
  
end;

function CheckNumber(CurrentCard : integer) : boolean;
begin
  var cards := readCards();
  CheckNumber := false;
  for var i := 0 to length(cards) - 1 do
    if cards[i].number = CurrentCard then
      begin
        CheckNumber := true;
        break;
      end
end;


procedure CardDeletingNotificationHandler(dialogResult : boolean);
begin
  if dialogResult then
    begin
      var CurrentCardForDeleting := parseCard();
      DeleteCard(CurrentCardForDeleting);
      AdminMenu();
    end
  else
    begin
      cardWindow();
      fillCardFields(parseCard());
    end;
end;

end.