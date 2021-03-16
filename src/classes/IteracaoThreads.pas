unit IteracaoThreads;

interface

uses
  System.Classes,Forms,System.SysUtils,ExceptionManager,
  Vcl.StdCtrls,windows,Vcl.ComCtrls;

  CONST  QTDE_LOOP = 100;

type
  TProvaThreads = class(TThread)
  private
    FProgress,FForm:TComponent;
    FTimer: integer;
    FLog: TMemo;
    procedure Settimer(const Value: integer);
    procedure SetLog(const Value: TMemo);
    procedure updateProgress;
    procedure UpdateProgressMax;

  protected
    procedure Execute; override;
  public
    destructor Destroy;override;
    constructor Create(CreatedSuspended:boolean; AProgress:TComponent; AForm:TComponent);

    property Timer:integer read FTimer write Settimer;
    property Log:TMemo read FLog write SetLog;
  end;

implementation

{ TProvaThreads }

constructor TProvaThreads.Create(CreatedSuspended:boolean; AProgress:TComponent; AForm:TComponent);
begin
  inherited Create(CreatedSuspended);
  self.FreeOnTerminate:= true;
  FProgress:= AProgress;
  FForm:= AForm;
end;

destructor TProvaThreads.Destroy;
begin
  Log.Lines.Add(inttostr(self.ThreadID) + ' - Processamento finalizado.');
  TProgressBar(FProgress).Tag:=   TProgressBar(FProgress).Tag - 1;

  // caso o usuário queira fechar o form.
  // A última Thread em execução irá fechar o formulário
  if TProgressBar(FProgress).Tag = 0 then
    if TForm(FForm).Tag  = 1 then
      TForm(FForm).Close;
  inherited;
end;

procedure TProvaThreads.Execute;
var
  i:integer;
begin
  try
    NameThreadForDebugging('ProvaThreads');
    Log.Lines.Add(inttostr(self.ThreadID) + ' - Iniciando processamento.');
    Synchronize(UpdateProgressMax);

    // Referência de Threads em execução está na propriedade Tag do Nosso ProgressBar
    TProgressBar(FProgress).Tag:=   TProgressBar(FProgress).Tag + 1;

    for I:= 0 to QTDE_LOOP  do
    begin
      Sleep(Random(FTimer));

      // Utilizado Synchronize Para evitar problema na concorrencia do componente TProgressBar
      Synchronize(updateProgress);
    end;

  except
    on e:exception do
      TExceptionManager.RegistraLog(self,e);
  end;
end;

procedure TProvaThreads.SetLog(const Value: TMemo);
begin
  FLog := Value;
end;

procedure TProvaThreads.Settimer(const Value: integer);
begin
  FTimer := Value;
end;

procedure TProvaThreads.updateProgress;
begin
  TProgressBar(FProgress).position:= TProgressBar(FProgress).position + 1;
end;

procedure TProvaThreads.UpdateProgressMax;
begin
  TProgressBar(FProgress).Max:= TProgressBar(FProgress).Max + QTDE_LOOP;
end;

end.
