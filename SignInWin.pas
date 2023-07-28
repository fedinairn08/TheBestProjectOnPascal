unit SignInWin;

interface

///окно авторизации
procedure EntranceWindow();
///отработчики команд на экране авторизации
procedure EntranceHandler();
///проверка логина, пароля и роли
function checkLog(login, password : string) : integer;

implementation

uses HomeWin, Print, Resources, Functions, SignUpWin, MenuWin, NotificationWin;

procedure EntranceWindow();
begin
  setlength(listButtons, 2);
  setlength(listFields, 2);
  setlength(listLabels, 0);
  
  with listFields[0] do
  begin
    name := 'Логин';
    length := 10;
    with loc do
    begin
      x1 := WindowWidth div 2 - 175;
      y1 := WindowHeight div 100 * 30 - 23;
      x2 := WindowWidth div 2 + 175;
      y2 := WindowHeight div 100 * 30 + 23;
    end;
  end;
  
   with listFields[1] do
  begin
    name := 'Пароль';
    length := 10;
    with loc do
    begin
      x1 := WindowWidth div 2 - 175;
      y1 := WindowHeight div 100 * 50 - 23;
      x2 := WindowWidth div 2 + 175;
      y2 := WindowHeight div 100 * 50 + 23;
    end;
  end;
  
  with listButtons[0] do
  begin
    text := 'Вход';
    loc.x1 := WindowWidth div 100 * 40 - 45;
    loc.y1 := WindowHeight div 5 * 4 - 20;
    loc.x2 := WindowWidth div 100 * 40 + 45;
    loc.y2 := WindowHeight div 5 * 4 + 20;
  end;
  
  with listButtons[1] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 10 * 6 - 50;
    loc.y1 := WindowHeight div 5 * 4 - 20;
    loc.x2 := WindowWidth div 10 * 6 + 50;
    loc.y2 := WindowHeight div 5 * 4 + 20;
  end;
  
  WindowHandler := EntranceHandler;
  Printer();
end;

procedure EntranceHandler();
begin
  if focusOnButton() then
  begin
    var focusButton := getFocusButton();
    if (focusButton.text = 'Вход') then
    begin
      var login := listFields[0].text;
      var password := listFields[1].text; 
      var status := checkLog(login, password);

      if (status = 1) or (status = 2) then
      begin
        CurrentUser.login := login;
        CurrentUser.password := password;
        CurrentUser.role := inttostr(status);
      end;
      
      if (status = 1) then
        UserMenu();
      
      if (status = 2) then
        AdminMenu();
        
      if ((status = 0) or (status = 3)) then
           begin
             lastWindow := EntranceWindow;
             Notification('Неверные данные! Вы не верно ввели логин или пароль.');
           end;
       
      if ((Length(login) = 0) or (Length(password) = 0)) then
        begin
          lastWindow := EntranceWindow;
          Notification('Неверные данные! Вы не ввели данные.');
        end;
     end; 
     
    if (focusButton.text = 'Назад') then
      helloWindow();
  end
end;

function checkLog(login, password : string) : integer;
  var
    readFile : listUsers;
begin
  checkLog := 0;
  readFile := readUsers();
    for var i :=0 to length(readFile) - 1 do
    begin
      var user := readFile[i];
      
      if (user.login = login) and
      (user.password = password) and
      (user.role = '1') then
        begin
          checkLog := 1;
          break
        end
      
        else 
          if (user.login = login) and
          (user.password = password) and
          (user.role = '2') then
            begin
              checkLog := 2;
              break
            end
        
            else
              if (user.login = login) and
              (user.password <> password) then
                begin
                  checkLog := 3;
                  break
                end;
      end; 
end;

end.