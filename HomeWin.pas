unit HomeWin;

interface

///Начальное окно с названием программы
procedure helloWindow();
///отработчик начального окна с названием программы
procedure helloHandler();

implementation

uses GraphABC, Print, Resources, SignUpWin, SignInWin, Functions;

procedure helloWindow();
begin
  setlength(listButtons, 3);
  setlength(listLabels, 3);
  setlength(listFields, 0);
  
  with listLabels[0] do
  begin
    text := 'Registry';
    fontSize := 70;
    with loc do
    begin
      x1 := 0;
      y1 := 0;
      x2 := WindowWidth;
      y2 := 500;
    end;
  end;
  
  with listLabels[1] do
  begin
    text := 'Автор - Федина И.А.';
    fontSize := 20;
    with loc do
    begin
      x1 := WindowWidth div 2 - 300;
      y1 := WindowHeight div 100 * 45 - 300;
      x2 := WindowWidth div 2 + 300;
      y2 := WindowHeight div 100 * 45 + 400;
    end;
  end;
  
  with listLabels[2] do
  begin
    text := 'Группа 2413';
    fontSize := 20;
    with loc do
    begin
      x1 := WindowWidth div 2 - 300;
      y1 := WindowHeight div 2 - 300;
      x2 := WindowWidth div 2 + 300;
      y2 := WindowHeight div 2 + 400;
    end;
  end;
  
  with listButtons[0] do
  begin
    text := 'Регистрация';
    loc.x1 := WindowWidth div 2 - 100;
    loc.y1 := WindowHeight div 3 * 2 - 20;
    loc.x2 := WindowWidth div 2 + 100;
    loc.y2 := WindowHeight div 3 * 2 + 20;
  end;
  
  with listButtons[1] do
  begin
    text := 'Вход';
    loc.x1 := WindowWidth div 2 - 100;
    loc.y1 := WindowHeight div 4 * 3 - 20;
    loc.x2 := WindowWidth div 2 + 100;
    loc.y2 := WindowHeight div 4 * 3 + 20;
  end;
  
  with listButtons[2] do
  begin
    text := 'Выход';
    loc.x1 := WindowWidth div 2 - 100;
    loc.y1 := WindowHeight div 100 * 83 - 20;
    loc.x2 := WindowWidth div 2 + 100;
    loc.y2 := WindowHeight div 100 * 83 + 20;
  end;
  
  WindowHandler := helloHandler;
  printWindow();
end;

procedure helloHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    
    if (focusButton.text = 'Выход') then
      CloseWindow();
    
    if (focusButton.text = 'Регистрация') then
      RegWindow();
    
    if (focusButton.text = 'Вход') then
      EntranceWindow();
  end
end;

end.