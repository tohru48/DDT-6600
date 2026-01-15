// Decompiled with JetBrains decompiler
// Type: Game.Logic.DropInfoMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class DropInfoMgr
  {
    protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected static ReaderWriterLock m_lock = new ReaderWriterLock();
    public static Dictionary<int, MacroDropInfo> DropInfo;

    public static bool CanDrop(int templateId)
    {
      if (DropInfoMgr.DropInfo == null)
        return true;
      DropInfoMgr.m_lock.AcquireWriterLock(-1);
      try
      {
        if (DropInfoMgr.DropInfo.ContainsKey(templateId))
        {
          MacroDropInfo macroDropInfo = DropInfoMgr.DropInfo[templateId];
          if (macroDropInfo.DropCount >= macroDropInfo.MaxDropCount && macroDropInfo.SelfDropCount < macroDropInfo.DropCount)
            return false;
          ++macroDropInfo.SelfDropCount;
          ++macroDropInfo.DropCount;
          return true;
        }
      }
      catch (Exception ex)
      {
        if (DropInfoMgr.log.IsErrorEnabled)
          DropInfoMgr.log.Error((object) "DropInfoMgr CanDrop", ex);
      }
      finally
      {
        DropInfoMgr.m_lock.ReleaseWriterLock();
      }
      return true;
    }
  }
}
