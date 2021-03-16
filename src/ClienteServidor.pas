unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls,Zip, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB;

type
  TServidor = class
  private
    FPath: string;
    FHistoricoEnviado: array of string;
    FAProgressbar: TProgressBar;
    FsetMaxProgressBar: integer;
    procedure RollBack;

    procedure SetAProgressbar(const Value: TProgressBar);
    procedure SetMaxProgressBar(const Value: integer); public
    constructor Create;
    //Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;

    property AProgressbar:TProgressBar read FAProgressbar write SetAProgressbar;
    property MaxProgressBar:integer read FsetMaxProgressBar write SetMaxProgressBar;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure onDestroy(Sender:TObject);
    procedure EnviarParaleloClick(Sender:TObject);
  private
    FPath: string;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
 ExceptionManager,ThreadEnvioParalelo, IOUtils;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
  erro:Boolean;
begin
  try
    erro:= false;
    cds := InitDataset;
    FServidor := TServidor.Create;
    FServidor.AProgressbar:= ProgressBar;
    FServidor.MaxProgressBar:= QTD_ARQUIVOS_ENVIAR;

    for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      try
        cds.Append;
        cds.FieldByName('id').AsInteger:= i;
        cds.FieldByName('Arquivo').AsString:= FPath;
        cds.Post;

        {$REGION Simulação de erro, não alterar}
        if i = (QTD_ARQUIVOS_ENVIAR/2) then
          FServidor.SalvarArquivos(NULL);
        {$ENDREGION}

        ProgressBar.Position:= i;
        Application.ProcessMessages;
      except
        on e:exception do
        begin
          erro:= true;
          TExceptionManager.RegistraLog(sender,e);
        end;
      end;
    end;

    FServidor.SalvarArquivos(cds.Data);


    // Caso entre na exception ele executa o método Rollback
    if erro = true then
      FServidor.RollBack;

  finally
    FreeAndNil(FServidor);
    FreeAndNil(cds);
  end;
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  try
    cds := InitDataset;
    FServidor := TServidor.Create;
    FServidor.AProgressbar:= ProgressBar;
    FServidor.MaxProgressBar:= QTD_ARQUIVOS_ENVIAR;

    for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      cds.Append;
      cds.FieldByName('id').AsInteger:= i;
      cds.FieldByName('Arquivo').AsString:= FPath;
      cds.Post;
    end;

    FServidor.SalvarArquivos(cds.Data);
  finally
    FreeAndNil(FServidor);
    FreeAndNil(cds);
  end;
end;

procedure TfClienteServidor.EnviarParaleloClick(Sender: TObject);
var
  EnvioParalelo:TEnvioParalelo;
begin
  // Nesse caso não finalizei a Thread com ao fechar o form
  // deixei rodando em segundo plano
  EnvioParalelo:= TEnvioParalelo.Create(Sender,true);
  EnvioParalelo.Start;
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('id',ftInteger);
  Result.FieldDefs.Add('arquivo',ftBlob);
  Result.CreateDataSet;
end;

procedure TfClienteServidor.onDestroy(Sender: TObject);
begin
  if FServidor <> nil then
   FreeAndNil(FServidor);
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Servidor\';

  if not DirectoryExists(FPath) then
    ForceDirectories(FPath);
end;


procedure TServidor.RollBack;
var
  I: Integer;
begin
  if Length(FHistoricoEnviado) = 0  then exit;

  for I := 0 to High(FHistoricoEnviado) do
  begin
    TFile.Delete(Pchar(FHistoricoEnviado[i]));
  end;
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
begin
  Result := True;
  try
    cds := TClientDataset.Create(nil);
    cds.Data := AData;

    {$REGION Simulação de erro, não alterar}
    if cds.RecordCount = 0 then
      Exit;
    {$ENDREGION}

    cds.First;
    while not cds.eof do
    begin
      try
        FileName := FPath + cds.FieldByName('id').AsString + '.pdf';

        if TFile.Exists(FileName) then
          TFile.Delete(FileName);

        TFile.Copy(Pchar(cds.FieldByName('Arquivo').AsString),PChar(FileName),False);

        // Grava em um array o que está sendo enviado Caso caia na except
        // Pega o que foi enviado e da um roolback
        SetLength(FHistoricoEnviado,cds.FieldByName('id').AsInteger+1);
        FHistoricoEnviado[cds.FieldByName('id').AsInteger]:= FileName;
        //------------------------------------------------------------//

        AProgressbar.Position:= cds.FieldByName('id').AsInteger;
        Application.ProcessMessages;
        cds.Next;
      except
        on e:exception do
        begin
          TExceptionManager.RegistraLog(self,e);
          RollBack;
          Break;
        end;
      end;
    end;
  finally
    FreeAndNil(cds);
  end;
end;

procedure TServidor.SetAProgressbar(const Value: TProgressBar);
begin
  FAProgressbar := Value;
end;

procedure TServidor.setMaxProgressBar(const Value: integer);
begin
  FAProgressbar.Max := Value;
  FAProgressbar.Position:= 0;
end;

end.
