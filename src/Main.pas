unit Main;

interface

{
  Fiz alguns coment�rios no fonte pois n�o sei exatamente o que voc�s esperam no teste
  Tive algumas d�vidas mas tentei seguir as instru��es do Readme.


  A unit ExceptionManager � a respons�vel por gerenciar as exceptions que
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
