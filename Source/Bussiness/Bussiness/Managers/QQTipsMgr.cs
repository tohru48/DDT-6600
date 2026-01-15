// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.QQTipsMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

#nullable disable
namespace Bussiness.Managers
{
  public class QQTipsMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, GClass1> dictionary_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, GClass1> infos = new Dictionary<int, GClass1>();
        if (QQTipsMgr.LoadItem(infos))
        {
          QQTipsMgr.dictionary_0 = infos;
          return true;
        }
      }
      catch (Exception ex)
      {
        if (QQTipsMgr.ilog_0.IsErrorEnabled)
          QQTipsMgr.ilog_0.Error((object) "ReLoad QQTips", ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        QQTipsMgr.dictionary_0 = new Dictionary<int, GClass1>();
        flag = QQTipsMgr.LoadItem(QQTipsMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (QQTipsMgr.ilog_0.IsErrorEnabled)
          QQTipsMgr.ilog_0.Error((object) "Init QQTips", ex);
        flag = false;
      }
      return flag;
    }

    public static bool LoadItem(Dictionary<int, GClass1> infos)
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (GClass1 gclass1 in produceBussiness.GetAllQQtipsMessagesLoad())
        {
          if (!infos.Keys.Contains<int>(gclass1.ID))
            infos.Add(gclass1.ID, gclass1);
        }
      }
      return true;
    }

    public static GClass1 GetQQtipsMessages()
    {
      if (QQTipsMgr.dictionary_0 == null)
        QQTipsMgr.Init();
      return QQTipsMgr.dictionary_0.Values.ToArray<GClass1>()[ThreadSafeRandom.NextStatic(QQTipsMgr.dictionary_0.Count)];
    }
  }
}
