unit UserMenuWin;

interface

procedure UserMenu();
procedure UserHandler();

implementation

uses Print, Resources, Functions;

procedure UserMenu();
begin
  setlength(listButtons, 4);
  setlength(listFields, 0);
  setlength(listLabels, 0);
  
  with listButtons[0] do
  begin
    text := 'Информация по врачу/дню';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 30 - 30;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 * 30 + 30; 
  end;
  
  with listButtons[1] do
  begin
    text := 'Поиск дополнительной информации';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 45 - 45;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 * 45 + 45;
  end;
  
  with listButtons[2] do
  begin
    text := 'Все карточки больных';
    loc.x1 := WindowWidth div 2 - 150;
    loc.y1 := WindowHeight div 100 * 60 - 35;
    loc.x2 := WindowWidth div 2 + 150;
    loc.y2 := WindowHeight div 100 * 60 + 35;
  end;
  
  with listButtons[3] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 2 - 100;
    loc.y1 := WindowHeight div 100 * 75 - 20;
    loc.x2 := WindowWidth div 2 + 100;
    loc.y2 := WindowHeight div 100 * 75 + 20;
  end;
  
  WindowHandler := UserHandler;
  printWindow();
end;

procedure UserHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    
    //if (focusButton.text = 'Информация по врачу/дню') then
      
    
    //if (focusButton.text = 'Поиск дополнительной информации') then
      
      
    //if (focusButton.text = 'Все карточки больных') then
      
      
//    if (focusButton.text = 'Назад') then
//      EntranceWindow();
      
  end
end;

end.