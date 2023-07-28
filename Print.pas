unit Print;

interface

uses GraphABC, Resources;

///отрисовка надписей
procedure printTextLable(textLabel: textLabel);
///отрисовка полей
procedure printField(field: Field);
///изменение размера и цвета пера
procedure editPen(widthPen: integer; color: Color := clBlack);
///изменение размера и цвета шрифта
procedure editFont(fontSize: integer; color: Color := clBlack);
///установка размера и цвета пера
procedure setDefaultPen();
///установка размера и цвета шрифта
procedure setDefaultFont();
///отрисовка кнопок
procedure printButton(button : Button);
///отрисовка окна
procedure printWindow();
///отрисовка фокуса на элементе
procedure PrintSelect();
///очистка фокуса
procedure clearFocus();
///отрисовка уведомлений
procedure printNotification();

implementation

procedure printTextLable(textLabel: textLabel);
begin
  with textLabel do
  begin
    editFont(fontSize, fontColor);
    if (center) then
      DrawTextCentered(loc.x1, loc.y1, loc.x2, loc.y2, text)
    else
      TextOut(loc.x1, loc.y1, text);
    setDefaultFont();
  end;
end;

procedure printField(field: field);
begin
  DrawRectangle(field.loc.x1, field.loc.y1, field.loc.x2, field.loc.y2);
  
  var textLabel : textLabel;
  textLabel.loc := field.loc;
  textLabel.text := field.text;
  printTextLable(textLabel);
  
  var loc := field.loc;
  loc.y1 := 2 * loc.y1 - loc.y2;
  loc.y2 := field.loc.y1;
  textLabel.loc := loc;
  textLabel.text := field.name;
  printTextLable(textLabel);
  
end;

procedure editPen(widthPen: integer; color: Color);
begin
  SetPenWidth(widthPen); 
  SetPenColor(color);
end;

procedure editFont(fontSize: integer; color: Color);
begin
  SetFontColor(color);
  SetFontSize(fontSize);
end;

procedure setDefaultPen();
begin
  SetPenWidth(DefaultWidthPen);
  SetPenColor(DefaultColor);
end;

procedure setDefaultFont(); 
begin
  SetFontColor(DefaultColor);
  SetFontSize(DefaultFontSize);
end;

procedure printButton(button : Button);
begin
  DrawRectangle(button.loc.x1, button.loc.y1, button.loc.x2, button.loc.y2);
  var textLabel : textLabel;
  textLabel.loc := button.loc;
  textLabel.text := button.text;
  printTextLable(textLabel);
end;

procedure printWindow();
begin
  lockDrawing();
  ClearWindow(); 
  for var i := 0 to length(listFields) - 1 do
    printField(listFields[i]);
  
  for var i := 0 to length(listLabels) - 1 do
    printTextLable(listLabels[i]);
  
  for var i := 0 to length(listButtons) - 1 do
    printButton(listButtons[i]);
  PrintSelect();
  unlockDrawing();
end;

procedure printNotification();
begin
  lockDrawing();
  ClearWindow(); 
  
  for var i := 0 to length(listLabels) - 1 do
    printTextLable(listLabels[i]);
  
  for var i := 0 to length(listButtons) - 1 do
    printButton(listButtons[i]);
  
  for var i := 0 to length(listFields) - 1 do
    begin
      with listFields[i] do
      begin
        with loc do
        begin
          x1 := 0;
          y1 := 0;
          x2 := 0;
          y2 := 0;
        end;
     end;
    end;
  
  PrintSelect();
  unlockDrawing();
end;

procedure PrintSelect();
begin
  SetPenColor(clRed);
  for var i := 0 to length(listFields) - 1 do
    if listFields[i].focus = true then
      with listFields[i] do
        with loc do
          DrawRectangle(X1, Y1, X2, Y2);
  
  for var i := 0 to length(listButtons) - 1 do
    if listButtons[i].focus = true then
      with listButtons[i] do
        with loc do
          DrawRectangle(X1, Y1, X2, Y2);
  SetPenColor(DefaultColor);
end;

procedure clearFocus();
begin
   for var i := 0 to length(listFields) - 1 do
    listFields[i].focus := false;
   
   for var i := 0 to length(listButtons) - 1 do
    listButtons[i].focus := false;
end;

 end. 