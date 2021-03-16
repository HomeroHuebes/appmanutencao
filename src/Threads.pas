{
  Fiz um controle manual utilizando lógica para controlar as threads em execução
  Fechamento de formulário etc.
}
unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,IteracaoThreads, Vcl.ComCtrls;

type
  TfThreads = class(TForm)
    edtQtdeThreads: TEdit;
    edtTempo: TEdit;
    memoLog: TMemo;
    btnExecuteThreads: TButton;
    Label1: TLabel;
    Label2: TLabel;
    progress: TProgressBar;
    procedure edtQtdeThreadsKeyPress(Sender: TObject; var Key: Char);
    procedure edtTempoKeyPress(Sender: TObject; var Key: Char);
    procedure btnExecuteThreadsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
   FThread:TProvaThreads;
   function somenteNumeros(value:Char):Char;
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;

implementation

{$R *.dfm}


procedure TfThreads.btnExecuteThreadsClick(Sender: TObject);
var
  i:integer;
  qtde_threads:integer;
begin
  qtde_threads:= StrToIntDef(edtQtdeThreads.Text,0);

  //Caso não tenha nenhuma Thread em andamento reseta o Progressbar
  if progress.Tag = 0 then
  begin
    progress.Max:= 0;
    progress.Position:= 0;
  end;

  // Executa várias threads conforme a quantidade solicitada.
  if qtde_threads > 0 then
  begin
    for i := 1 to qtde_threads do
    begin
       FThread:= TProvaThreads.Create(true,progress,self);
       FThread.Timer:= StrToIntDef(edtTempo.Text,1000);
       FThread.Log:= memoLog;
       FThread.Start;

       Application.ProcessMessages;
    end;
  end;
end;

procedure TfThreads.edtQtdeThreadsKeyPress(Sender: TObject; var Key: Char);
begin
  key:= somenteNumeros(key);
end;

procedure TfThreads.edtTempoKeyPress(Sender: TObject; var Key: Char);
begin
  key:= somenteNumeros(key);
end;

procedure TfThreads.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Flag que identifica Threads ainda em execução
  if progress.Tag > 0 then
  begin
    Application.MessageBox('O formulário será fechado ao finalizar os processos em andamento.  Aguarde...', 'ProvaAPP',
      MB_OK + MB_ICONINFORMATION);

    // seta a flag do formulário para fechar utlizando a propriedade Tag.
    self.Tag:= 1;

    CanClose:= false;
  end;

end;

procedure TfThreads.FormShow(Sender: TObject);
begin
  // Como criei o formulário no mesmo formato que me mandaram os outros forms
  // Coloquei  o reset de configurações no OnShow  pois no Create não irá funcionar
  // Pois já é criado junto na inicialização.
  progress.Tag:= 0;
  self.Tag:= 0;
  progress.Max:= 0;
  progress.Position:= 0;
  memoLog.Clear;
  edtQtdeThreads.Clear;
  edtTempo.Clear;
end;

function TfThreads.somenteNumeros(value:Char):Char;
begin
  Result:= value;
  If not (CharInSet(value, ['0'..'9',#27,#08])) then
    Result:= #0;
end;

end.
