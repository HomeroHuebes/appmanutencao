program Foo;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fMain},
  DatasetLoop in 'DatasetLoop.pas' {fDatasetLoop},
  ClienteServidor in 'ClienteServidor.pas' {fClienteServidor},
  ExceptionManager in 'classes\ExceptionManager.pas',
  IteracaoThreads in 'classes\IteracaoThreads.pas',
  Threads in 'Threads.pas' {fThreads},
  ThreadEnvioParalelo in 'classes\ThreadEnvioParalelo.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:= true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfDatasetLoop, fDatasetLoop);
  Application.CreateForm(TfClienteServidor, fClienteServidor);
  Application.CreateForm(Tfthreads, fthreads);
  Application.Run;
end.
