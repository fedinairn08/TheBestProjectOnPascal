unit NotificationWin;

interface

///окно уведомления
procedure Notification(error_massage: string);
///отработчик окна уведомления
procedure NotificationHandler();
///окно уведомления, уточняющего удаление карточки
procedure NotificationAboutDelete(TextNotice : string);
///отработчик окна уведомления, уточняющего удаление карточки
procedure NotificationAboutDeleteHandler();

implementation

uses Print, Resources, Functions, Cards, MenuWin, TableWin;

procedure Notification(error_massage: string);
begin
  setlength(listButtons, 1);
  setlength(listLabels, 1);
  
  with listLabels[0] do
  begin
    text := error_massage;
    fontSize := 40;
    with loc do
    begin
      x1 := 0;
      y1 := 0;
      x2 := WindowWidth;
      y2 := 500;
    end;
  end;
  
  with listButtons[0] do
  begin
    text := 'Ок';
    loc.x1 := WindowWidth div 2 - 100;
    loc.y1 := WindowHeight div 5 * 4 - 20;
    loc.x2 := WindowWidth div 2 + 100;
    loc.y2 := WindowHeight div 5 * 4 + 20;
  end;
  
  WindowHandler := NotificationHandler;
  Printer := printNotification;
  printer();
end;

procedure NotificationAboutDelete(TextNotice : string);
begin
  setlength(listButtons, 2);
  setlength(listLabels, 1);
  
  with listLabels[0] do
  begin
    text := TextNotice;
    fontSize := 40;
    with loc do
    begin
      x1 := 0;
      y1 := 0;
      x2 := WindowWidth;
      y2 := 500;
    end;
  end;
  
  with listButtons[0] do
  begin
    text := 'Да';
    focus := true;
    loc.x1 := WindowWidth div 100 * 30 - 100;
    loc.y1 := WindowHeight div 5 * 4 - 20;
    loc.x2 := WindowWidth div 100 * 30 + 100;
    loc.y2 := WindowHeight div 5 * 4 + 20;
  end;
  
  with listButtons[1] do
  begin
    text := 'Отмена';
    loc.x1 := WindowWidth div 100 * 70 - 100;
    loc.y1 := WindowHeight div 5 * 4 - 20;
    loc.x2 := WindowWidth div 100 * 70 + 100;
    loc.y2 := WindowHeight div 5 * 4 + 20;
  end;
  
  WindowHandler := NotificationAboutDeleteHandler;
  Printer := printNotification;
  Printer();
end;


procedure NotificationHandler();
begin
  if focusOnButton() then
  begin 
    var focusButton := getFocusButton();
    Printer := PrintWindow;
    
    if focusButton.text = 'Ок' then
      lastWindow();
  end;
end;

procedure NotificationAboutDeleteHandler();
begin
  if focusOnButton() then
  begin 
    var focusButton := getFocusButton();
    Printer := PrintWindow;
    
    if focusButton.text = 'Да' then
      begin
        NotificationsHandler(True);
      end;
        
    if focusButton.text = 'Отмена' then
      begin
      NotificationsHandler(False);
      end;
  end;
end;

end.