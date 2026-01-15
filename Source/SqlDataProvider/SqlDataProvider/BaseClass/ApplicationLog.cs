// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.BaseClass.ApplicationLog
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System.Diagnostics;

#nullable disable
namespace SqlDataProvider.BaseClass
{
  public static class ApplicationLog
  {
    public static void WriteError(string message)
    {
      ApplicationLog.smethod_0(TraceLevel.Error, message);
    }

    private static void smethod_0(TraceLevel traceLevel_0, string string_0)
    {
      try
      {
        EventLogEntryType type = traceLevel_0 != TraceLevel.Error ? EventLogEntryType.Error : EventLogEntryType.Error;
        string str = "Application";
        if (!EventLog.SourceExists(str))
          EventLog.CreateEventSource(str, "BIZ");
        new EventLog(str, ".", str).WriteEntry(string_0, type);
      }
      catch
      {
      }
    }
  }
}
