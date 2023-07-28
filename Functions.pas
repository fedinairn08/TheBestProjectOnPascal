unit Functions;

interface

uses Resources;

///определение фокуса на кнопке
function focusOnButton() : boolean;
///установка фокуса на кнопке
function getFocusButton() : button;
///установка фокуса на поле
function getFocusField() : field;
///ставит фокус на первый элемент какого-либо списка
procedure setFocus();
///Возвращает значение в выбранном поле
function ReturnValue(field_name: string): String;
///проверка формата номера
function IsNumber(number : string) : boolean;
///проверка формата ФИО пациента и врача
function IsLetter(words : string) : boolean;
///проверка формата дат
function IsDate(date : string) : boolean;

implementation

function focusOnButton() : boolean;
begin
  for var i := 0 to length(listFields) - 1 do
    if listFields[i].focus = true then
      focusOnButton := false;
  
  for var i := 0 to length(listButtons) - 1 do
    if listButtons[i].focus = true then
      focusOnButton := true;
end;

function getFocusButton() : button;
begin
  for var i := 0 to length(listButtons) - 1 do
    if listButtons[i].focus = true then
      getFocusButton := listButtons[i];
end;

function getFocusField() : field;
begin
  for var i := 0 to length(listFields) - 1 do
    if listFields[i].focus = true then
      getFocusField := listFields[i];
end;

procedure setFocus();
begin
  var
  focusList: boolean := true;
  
  for var i := 0 to length(listFields) - 1 do
    if listFields[i].focus = true then
      focusList := false;
  
  for var i := 0 to length(listButtons) - 1 do
    if listButtons[i].focus = true then
      focusList := false;
  
  if focusList then
  begin
    if length(listFields) <> 0 then
      listFields[0].focus := True
    else
    if length(listButtons) <> 0 then
      listButtons[0].focus := True;
  end;
end;


function ReturnValue(field_name: string): String;
begin
  for var i := 0 to length(listFields) - 1 do
    if listFields[i].name = field_name then
      result := listFields[i].text
end;

function IsNumber(number : string) : boolean;
begin
  var n, e : integer;
  val(number, n, e);
  IsNumber := e > 0;
end;

function IsLetter(words : string) : boolean;
begin
  for var i := 1 to length(words) do
  begin
    IsLetter := True;
    if not (((ord(words[i]) > 64) and (ord(words[i]) < 91)) 
    or ((ord(words[i]) > 96) and (ord(words[i]) < 123)) 
    or ((ord(words[i]) > 1039) and (ord(words[i]) < 1104)) 
    or (ord(words[i]) = 32)) then
      IsLetter := False;
  end;
end;

function IsDate(date : string) : boolean;
begin
  for var i := 1 to length(date) do
  begin
    IsDate := True;
    if not (((ord(date[i]) > 47) and (ord(date[i]) < 58)) 
    or (ord(date[i]) = 46)) then
      IsDate := False;
  end;
end;

end.