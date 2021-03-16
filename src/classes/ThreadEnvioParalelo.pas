unit ThreadEnvioParalelo;

interface

uses
 Windows, System.Classes,Vcl.StdCtrls,System.SysUtils;


 const QTDE_ARQUIVOS = 500;

type
  TEnvioParalelo = class(TThread)
  private
   FNomeBotao:String;
   FButton:TObject;
   FPDFFilename:string;
   FServidorPath:string;
   procedure EnviarArquivos;
  protected
    procedure Execute; override;
  public
    destructor Destroy; override;
    constructor Create(Sender:TObject; CreatedSuspended:Boolean);
  end;

implementation

{ TEnvioParalelo }

constructor TEnvioParalelo.Create(Sender:TObject; CreatedSuspended:Boolean);
begin
  inherited Create(CreatedSuspended);
  self.FreeOnTerminate:= true;
  FButton:= Sender;
  FNomeBotao:= TButton(FButton).Caption;
  FPDFFilename := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'pdf.pdf';
  FServidorPath:= IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Servidor\';

  if not DirectoryExists(FServidorPath) then
    ForceDirectories(FServidorPath);
end;

destructor TEnvioParalelo.Destroy;
begin
  TButton(FButton).Enabled:= true;
  TButton(FButton).Caption:= FNomeBotao;
  TButton(FButton).Refresh;
  inherited;
end;

procedure TEnvioParalelo.EnviarArquivos;
var i:integer;
begin
  for i:= 150 to QTDE_ARQUIVOS do
    begin
      // Creio eu que nesse exemplo Copiando o arquivo seria mais rápido
      // Mas poderia ser outro tipo de transferencia (Ex. API's, FTP etc...)
      CopyFile(PChar(FPDFFilename),Pchar(FServidorPath+IntToStr(i)+'.pdf'),true);
    end;
end;

procedure TEnvioParalelo.Execute;
begin
  NameThreadForDebugging('EnvioParalelo');
  TButton(FButton).Enabled:= False;
  TButton(FButton).Caption:= 'Processando...';
  EnviarArquivos;
end;

end.
