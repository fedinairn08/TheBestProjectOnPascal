unit MenuWin;

interface
///меню администратора
procedure AdminMenu();
///отработчики команд на экране администратора
procedure AdminHandler();
///меню пользователя
procedure UserMenu();
///отработчики команд на экране пользователя
procedure UserHandler();

implementation

uses Print, Resources, Functions, NotificationWin, SignUpWin, SignInWin, Cards, TableWin, Search;

procedure AdminMenu();
begin
  setlength(listButtons, 5);
  setlength(listFields, 0);
  setlength(listLabels, 0);
  
  with listButtons[0] do
  begin
    text := 'Поиск карточки';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 20 - 30;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 *20 + 30;
  end;
  
  with listButtons[1] do
  begin
    text := 'Создание карточки';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 35 - 30;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 * 35 + 30;
  end;
  
   with listButtons[2] do
  begin
    text := 'Изменение карточки';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 50 - 30;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 * 50 + 30;
  end;
  
   with listButtons[3] do
  begin
    text := 'Удаление карточки';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 65 - 30;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 * 65 + 30;
  end;
  
  with listButtons[4] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 2 - 80;
    loc.y1 := WindowHeight div 100 * 80 - 20;
    loc.x2 := WindowWidth div 2 + 80;
    loc.y2 := WindowHeight div 100 * 80 + 20;
  end;
  
  WindowHandler := AdminHandler;
  Printer();
end;

procedure AdminHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    
    if (focusButton.text = 'Поиск карточки') then
      begin
        SearchWindow();
        CardAction := SearchCardAction;
      end;
    
    if (focusButton.text = 'Создание карточки') then
      begin
        CardWindow();
        cardAction := CreateCardAction;
      end;
    
    if (focusButton.text = 'Изменение карточки') then
      begin
        SearchWindow();
        CardAction := EditCardAction;
      end;
    
    if (focusButton.text = 'Удаление карточки') then
     begin
      SearchWindow();
      CardAction := DeleteCardAction;
     end;
    
    if (focusButton.text = 'Назад') then
      EntranceWindow();
  end
end;

procedure UserMenu();
begin
  setlength(listButtons, 2);
  setlength(listFields, 0);
  setlength(listLabels, 0);
  
  with listButtons[0] do
  begin
    text := 'Поиск карточки';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 40 - 30;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 * 40 + 30; 
  end;
  
  with listButtons[1] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 2 - 100;
    loc.y1 := WindowHeight div 100 * 60 - 20;
    loc.x2 := WindowWidth div 2 + 100;
    loc.y2 := WindowHeight div 100 * 60 + 20;
  end;
  
  WindowHandler := UserHandler;
  Printer();
end;

procedure UserHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    
    if (focusButton.text = 'Поиск карточки') then
      SearchWindow();
      
    if (focusButton.text = 'Назад') then
      EntranceWindow(); 
  end
end;

end.