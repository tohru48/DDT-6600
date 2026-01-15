// Decompiled with JetBrains decompiler
// Type: Game.Logic.BallMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class BallMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, BallInfo> dictionary_0;
    private static Dictionary<int, Tile> dictionary_1;

    public static bool Init() => BallMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, BallInfo> list = BallMgr.smethod_0();
        Dictionary<int, Tile> dictionary = BallMgr.smethod_1(list);
        if (list.Values.Count > 0 && dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, BallInfo>>(ref BallMgr.dictionary_0, list);
          Interlocked.Exchange<Dictionary<int, Tile>>(ref BallMgr.dictionary_1, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        BallMgr.ilog_0.Error((object) "Ball Mgr init error:", ex);
      }
      return false;
    }

    private static Dictionary<int, BallInfo> smethod_0()
    {
      Dictionary<int, BallInfo> dictionary = new Dictionary<int, BallInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (BallInfo ballInfo in produceBussiness.GetAllBall())
        {
          if (!dictionary.ContainsKey(ballInfo.ID))
            dictionary.Add(ballInfo.ID, ballInfo);
        }
      }
      return dictionary;
    }

    private static Dictionary<int, Tile> smethod_1(Dictionary<int, BallInfo> list)
    {
      Dictionary<int, Tile> dictionary = new Dictionary<int, Tile>();
      foreach (BallInfo ballInfo in list.Values)
      {
        if (ballInfo.HasTunnel)
        {
          string str = string.Format("bomb\\{0}.bomb", (object) ballInfo.ID);
          Tile tile = (Tile) null;
          if (File.Exists(str))
            tile = new Tile(str, false);
          dictionary.Add(ballInfo.ID, tile);
          if (tile == null && ballInfo.ID != 1 && ballInfo.ID != 2 && ballInfo.ID != 3)
            BallMgr.ilog_0.ErrorFormat("can't find bomb file:{0}", (object) str);
        }
      }
      return dictionary;
    }

    public static BallInfo FindBall(int id)
    {
      return BallMgr.dictionary_0.ContainsKey(id) ? BallMgr.dictionary_0[id] : (BallInfo) null;
    }

    public static Tile FindTile(int id)
    {
      return BallMgr.dictionary_1.ContainsKey(id) ? BallMgr.dictionary_1[id] : (Tile) null;
    }

    public static BombType GetBallType(int ballId)
    {
      if (ballId <= 99)
      {
        if (ballId <= 56)
        {
          switch (ballId - 1)
          {
            case 0:
              break;
            case 1:
            case 3:
              return BombType.Normal;
            case 2:
              return BombType.FLY;
            case 4:
              return BombType.CURE;
            default:
              if (ballId != 56)
                return BombType.Normal;
              break;
          }
        }
        else
        {
          if (ballId == 59 || ballId == 64)
            return BombType.CURE;
          switch (ballId)
          {
            case 97:
            case 98:
              return BombType.CURE;
            case 99:
              break;
            default:
              return BombType.Normal;
          }
        }
        return BombType.FORZEN;
      }
      if (ballId <= 117)
      {
        if (ballId == 110 || ballId == 117)
          return BombType.WORLDCUP;
      }
      else
      {
        if (ballId == 120)
          return BombType.CURE;
        switch (ballId - 128)
        {
          case 0:
          case 1:
            return BombType.CATCHINSECT;
          default:
            if (ballId == 10009)
              return BombType.CURE;
            break;
        }
      }
      return BombType.Normal;
    }
  }
}
