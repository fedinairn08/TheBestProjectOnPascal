unit SignUpWin;

interface

uses Resources, MenuWin;

///Окно регистрации
procedure RegWindow();
///отработчик окна регистрации
procedure RegHandler();
///сохранение пользователя в файл
procedure SaveUser(user : user);
///чтение пользователей из файла
function readUsers() : listUsers;
///проверка на то, свободен ли логин
function CheckLogin(CurrentLogin : string) : boolean;

implementation

uses HomeWin, Print, Functions, NotificationWin, TableWin;

procedure RegWindow();
begin
  setlength(listButtons, 2);
  setlength(listFields, 3);
  setlength(listLabels, 0);
  
  
  with listFields[0] do
  begin
    name := 'Логин';
    length := 10;
    with loc do
    begin
      x1 := WindowWidth div 2 - 175;
      y1 := WindowHeight div 5 - 23;
      x2 := WindowWidth div 2 + 175;
      y2 := WindowHeight div 5 + 23;
    end;
  end;
  
   with listFields[1] do
  begin
    name := 'Пароль';
    length := 10;
    with loc do
    begin
      x1 := WindowWidth div 2 - 175;
      y1 := WindowHeight div 20 * 7 - 23;
      x2 := WindowWidth div 2 + 175;
      y2 := WindowHeight div 20 * 7 + 23;
    end;
  end;
  
    with listFields[2] do
  begin
    name := 'Статус : клиент(1) или администратор(2)';
    length := 10;
    with loc do
    begin
      x1 := WindowWidth div 2 - 175;
      y1 := WindowHeight div 20 * 11 - 23;
      x2 := WindowWidth div 2 + 175;
      y2 := WindowHeight div 20 * 11 + 23;
    end;
  end;
  
  with listButtons[0] do
  begin
    text := 'Регистрация';
    loc.x1 := WindowWidth div 100 * 43 - 100;
    loc.y1 := WindowHeight div 5 * 4 - 20;
    loc.x2 := WindowWidth div 100 * 43 + 100;
    loc.y2 := WindowHeight div 5 * 4 + 20;
  end;
  
  with listButtons[1] do
  begin
    text := 'Назад';
    loc.x1 := WindowWidth div 100 * 62 - 50;
    loc.y1 := WindowHeight div 5 * 4 - 20;
    loc.x2 := WindowWidth div 100 * 62 + 50;
    loc.y2 := WindowHeight div 5 * 4 + 20;
  end;
  
  WindowHandler := RegHandler;
  Printer();
end;

procedure RegHandler();
begin
  
  if focusOnButton() then
  begin 
    var focusButton := getFocusButton();
    
    if (focusButton.text = 'Регистрация') then
    begin
      var login := listFields[0].text;
      var password := listFields[1].text;
      var role := listFields[2].text;
      
      if ((Length(login) = 0) or (Length(password) = 0)) then
        begin
           lastWindow := RegWindow;
           Notification('Неверные данные! Вы не ввели данные.');
           exit;
         end;
      
      if CheckLogin(login) then
      begin
        lastWindow := RegWindow;
        Notification('Данный логин уже занят, введите другой!');
        exit;
      end;
      
      if (Length(login) <> 0) and (Length(password) <> 0) then
        begin
          if (Length(role) = 0) then
            begin
             lastWindow := RegWindow;
             Notification('Неверные данные! Вы не ввели статус аккаунта.');
             exit;
           end;
           
          if (Length(role) <> 0) and ((role <> '1') or (role <> '2')) then
             begin
               lastWindow := RegWindow;
               Notification('Неверные данные! Вы неправильно ввели статус аккаунта.');
               exit;
             end; 
        end;
         
      if (Length(login) <> 0) and 
        (Length(password) <> 0) and
        ((role = '1') or (role = '2'))
        then
          begin
            CurrentUser.login := login;
            CurrentUser.password := password;
            CurrentUser.role := role;
            SaveUser(CurrentUser);
            
            if role = '2' then
              AdminMenu()
            else
              UserMenu();
          end;
    end;
         
    if (focusButton.text = 'Назад') then
      helloWindow();
  end
end;

procedure SaveUser(user : user);
begin
  Seek(varUserFile, FileSize(varUserFile));
  Write(varUserFile, User);
end;

function readUsers() : listUsers;
begin
  var listUsers : listUsers;
  var user : user;
  seek(varUserFile, 0);
  while not Eof(varUserFile) do
  begin
    read(varUserFile, user);
    setLength(listUsers, length(listUsers) + 1);
    listUsers[length(listUsers) - 1] := user; 
  end;
  readUsers := listUsers;
end;

function CheckLogin(CurrentLogin : string) : boolean;
begin
  var users := readUsers();
  CheckLogin := false;
  for var i := 0 to length(users) - 1 do
    if users[i].login = CurrentLogin then
      begin
        CheckLogin := true;
        break;
      end
end;

end.