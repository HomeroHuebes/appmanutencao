unit Main;

interface

{
  Fiz alguns comentários no fonte pois não sei exatamente o que vocês esperam no teste
  Tive algumas dúvidas mas tentei seguir as instruções do Readme.


  A unit ExceptionManager é a responsável por gerenciar as exceptions que
  ocorrem no escopo da  Application Ela se auto instancia pela initialization

}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls , ExceptionManager;

type
  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure btnThreads(Sender:TObject);
  private
  end;

var
  fMain: TfMain;

implementation

uses
  DatasetLoop, ClienteServidor, Threads;

{$R *.dfm}

procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
  fDatasetLoop.Show;
end;

procedure TfMain.btnThreads(Sender: TObject);
begin
  fThreads.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
  fClienteServidor.Show;
end;

end.
