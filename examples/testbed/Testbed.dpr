{===============================================================================
   ___                 _
  | __|__ _ ____  _ _ | |___ ___ _ _ ™
  | _|/ _` (_-< || | || (_-</ _ \ ' \
  |___\__,_/__/\_, |\__//__/\___/_||_|
               |__/
      Effortless JSON Handling for
     Delphi with Fluent Simplicity.

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/EasyJson

 See LICENSE file for license information
===============================================================================}

program Testbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UTestbed in 'UTestbed.pas',
  EasyJson in '..\..\src\EasyJson.pas';

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    RunTests();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
