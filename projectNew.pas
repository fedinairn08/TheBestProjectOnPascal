program projectNew;

uses GraphABC, Resources, Print, HomeWin, Input, Cards;

begin
  SetWindowHeight(WindowHeight);
  SetWindowWidth(WindowWidth);
  SetWindowIsFixedSize(true);
  SetFontName('Courier new');
  SetWindowTitle('Registry');
  setDefaultFont();
  
  Reset(varUserFile, 'users_data.dat');
  Reset(varCardFile, 'cards_data.dat');
  Reset(varDateFile, 'date_visit_data.dat');
  OnKeyPress := CharHandler;
  OnKeyDown := KeyHandler;
  OnMouseDown := MouseHandler;
  Printer := printWindow;
  helloWindow();
end.