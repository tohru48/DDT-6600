// Decompiled with JetBrains decompiler
// Type: Game.Logic.BallConfigMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class BallConfigMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, BallConfigInfo> dictionary_0;

    public static bool Init() => BallConfigMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, BallConfigInfo> dictionary = BallConfigMgr.smethod_0();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, BallConfigInfo>>(ref BallConfigMgr.dictionary_0, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        BallConfigMgr.ilog_0.Error((object) "Ball Mgr init error:", ex);
      }
      return false;
    }

    private static Dictionary<int, BallConfigInfo> smethod_0()
    {
      Dictionary<int, BallConfigInfo> dictionary = new Dictionary<int, BallConfigInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (BallConfigInfo ballConfigInfo in produceBussiness.GetAllBallConfig())
        {
          if (!dictionary.ContainsKey(ballConfigInfo.TemplateID))
            dictionary.Add(ballConfigInfo.TemplateID, ballConfigInfo);
        }
      }
      return dictionary;
    }

    public static BallConfigInfo FindBall(int id)
    {
      return BallConfigMgr.dictionary_0.ContainsKey(id) ? BallConfigMgr.dictionary_0[id] : (BallConfigInfo) null;
    }
  }
}
