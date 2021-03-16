unit ExceptionManager;

interface


uses
  SysUtils, Forms, System.Classes;

type
 TExceptionManager = class(TObject)
   private
     FLogFileName: String;
   public
   constructor Create;
   procedure TrataException(Sender:TObject; E: Exception);
   procedure GravarLog(value:string);

   // Class procedure criada para atender necessidades
   // de tratar erros fora do escorpo da Application  como Threads
   class procedure RegistraLog(Sender:TObject; E:Exception);
 end;

implementation

uses
  Winapi.Windows;

constructor TExceptionManager.Create;
begin
  FLogFileName:= ChangeFileExt(ParamStr(0), '.log');
  Application.OnException:= TrataException;
end;

procedure TExceptionManager.GravarLog(value: string);
var
  LArquivoLog:TextFile;
begin
  AssignFile(LArquivoLog,FLogFileName);

  if FileExists(FLogFileName) then
    Append(LArquivoLog)
  else
    Rewrite(LArquivoLog);

  Writeln(LArquivoLog,FormatDateTime('dd/mm/yyy hh:nn:ss ',now) + value);

  CloseFile(LArquivoLog);
end;

class procedure TExceptionManager.RegistraLog(Sender:TObject; E:Exception);
var
  obj: TExceptionManager;
begin
  try
    obj:= TExceptionManager.Create;
    obj.TrataException(Sender,E);
  finally
    FreeAndNil(obj);
  end;
end;

procedure TExceptionManager.TrataException(Sender: TObject; E: Exception);
begin
  GravarLog('=========================================================');
  if TComponent(Sender) is TForm then
  begin
    GravarLog('Form: ' + TForm(Sender).Name);
    GravarLog('Caption: ' + TForm(Sender).Caption);
    GravarLog('Erro: ' + E.ClassName);
    GravarLog('Erro: ' + E.Message);
  end
  else
    GravarLog('Erro:' + E.ClassName + ' --- ' + e.Message);

  Application.MessageBox(PChar(e.Message),'Exception', MB_OK + MB_ICONERROR);
end;


var
  AppException: TExceptionManager;
initialization
  AppException:= TExceptionManager.Create;
finalization
  AppException.Free;
end.
