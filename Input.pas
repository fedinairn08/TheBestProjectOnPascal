unit Input;

interface

///обработчик символов
procedure charHandler(ch: char);
///отработчик кнопок на клавиатуре
procedure keyHandler(key: integer);
///переход фокуса на следующий
procedure focusNext();
///переход фокуса на предыдущий
procedure focusPrevious();
///отработчик компьютерной мыши
procedure MouseHandler(x, y, key: integer);

implementation

uses Resources, Print, Functions;

procedure charHandler(ch: char);
begin
  for var i := 0 to length(listFields) - 1 do
    if (listFields[i].focus = true) and (listFields[i].BlockToUpdate = False) then
      with listFields[i] do
      begin
        var lenText := text.Length;
        if ord(ch) = 8 then
          text := copy(text, 0, lenText - 1)
        else 
        if ((ord(ch) > 1039) and (ord(ch) < 1104) or
		      (ord(ch) > 64) and (ord(ch) < 123) or
		      (ord(ch) > 45) and (ord(ch) < 58) or
		      (ord(ch) = 32) or (ord(ch) = 44)) and
		      (lenText < length) then
          text := text + ch;
      end;
  Printer();
end;

procedure keyHandler(key: integer);
begin
  if key = 38 then
    FocusPrevious();
  if key = 40 then
    FocusNext();
  if key = 13 then
    WindowHandler();
end;

procedure focusNext();
begin
  for var i := 0 to length(listFields) - 1 do
  begin
    if listFields[i].focus = True then
    begin
      listFields[i].focus :=  False;
      
      if length(listFields) - 1 - i = 0 then
      begin
        if length(listButtons) > 0 then
          listButtons[0].focus := True
        else
          listFields[0].focus := True;
      end
      else
      begin
        listFields[i + 1].focus := True;
      end;
      setFocus();
      Printer();
      exit;
    end;
  end;
  
  for var i := 0 to length(listButtons) - 1 do
  begin
    if listButtons[i].focus = True then
    begin
      listButtons[i].focus :=  False;
      
      if length(listButtons) - 1 - i = 0 then
      begin
        if length(listFields) > 0 then
          listFields[0].focus := True
        else
          listButtons[0].focus := True;
      end
      else
      begin
        listButtons[i + 1].focus := True;
      end;
      setFocus();
      Printer();
      exit;
    end;
  end;
  
end;

procedure focusPrevious();
begin
  for var i := 0 to length(listFields) - 1 do
  begin
    if listFields[i].focus = True then
    begin
      listFields[i].focus :=  False;
      
      if i = 0 then
      begin
        if length(listButtons) > 0 then
          listButtons[length(listButtons) - 1].focus := True
        else
          listFields[length(listFields) - 1].focus := True;
      end
      else
      begin
        listFields[i - 1].focus := True;
      end;
      break;
    end;
  end;
  
  for var i := 0 to length(listButtons) - 1 do
  begin
    if listButtons[i].focus = True then
    begin
      listButtons[i].focus :=  False;
      
      if i = 0 then
      begin
        if length(listFields) > 0 then
          listFields[length(listFields) - 1].focus := True
        else
          listButtons[length(listButtons) - 1].focus := True;
      end
      else
      begin
        listButtons[i - 1].focus := True;
      end;
      break;
    end;
  end;
  setFocus();
  Printer();
end;

procedure MouseHandler(x, y, key: integer);
begin
  
  for var i := 0 to length(listFields) - 1 do
    if ((listFields[i].loc.x1 < x) and  (x < listFields[i].loc.x2))
    and ((listFields[i].loc.y1 < y) and  (y < listFields[i].loc.y2)) then
    begin
      clearFocus();
      listFields[i].focus := true;
      windowHandler();
      break;
    end;
  
  for var i := 0 to length(listButtons) - 1 do
    if ((listButtons[i].loc.x1 < x) and  (x < listButtons[i].loc.x2))
    and ((listButtons[i].loc.y1 < y) and  (y < listButtons[i].loc.y2)) then
    begin
      clearFocus();
      listButtons[i].focus := true;
      windowHandler();
      break;
    end;
  
  Printer();
end;
end.