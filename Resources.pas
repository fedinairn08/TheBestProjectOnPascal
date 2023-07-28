unit Resources;

interface

uses GraphABC;

const
  WindowHeight = 700;
  WindowWidth = 1000;
  DefaultFontSize = 18;
  DefaultColor = clBlack;
  DefaultWidthPen = 1;
  EditCardAction = 1;
  DeleteCardAction = 2;
  SearchCardAction = 3;
  CreateCardAction = 4;

type
  coordinates = record
    x1: integer;
    x2: integer;
    y1: integer;
    y2: integer;
  end;
  
  field = record
    length: integer;
    focus: boolean := false;
    name: string;
    loc: coordinates;
    text: string;
    pos: string;
    BlockToUpdate: boolean := False;
  end;
  
  button = record
    loc: coordinates;
    text: string;
    focus: boolean := false;
  end;
  
  textLabel = record
    loc: coordinates;
    text: string;
    fontSize: integer := DefaultFontSize;
    fontColor: color := DefaultColor;
    center: boolean := true;
  end;
  
  user = record
    login: string[10];
    password: string[10];
    role: string[1];
  end;
  
  dateVisit = record
    number: integer;
    FullNamePatient: string[30];
    VisitDate: string[10];
  end;
  
  userFile = file of user;
  dateFile = file of dateVisit;
  listDate = array of dateVisit;
  listUsers = array of user;
  ListField = array of field;
  ListButton = array of button;
  ListLabel = array of textLabel;

var
  listFields: ListField;
  listButtons: ListButton;
  listlabels: Listlabel;
  WindowHandler: procedure;
  LastWindow: procedure;
  CurrentUser: user;
  varUserFile: userFile;
  varDateFile: dateFile;
  NotificationsHandler: procedure(dialogResult: boolean);
  Printer: procedure;
  CardAction := 0;

implementation

end.