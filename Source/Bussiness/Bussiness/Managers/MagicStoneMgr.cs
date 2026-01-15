// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.MagicStoneMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Bussiness.Managers
{
  public class MagicStoneMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static MagicStoneInfo[] magicStoneInfo_0;
    private static Dictionary<int, List<MagicStoneInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();
    private static ReaderWriterLock readerWriterLock_0;

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        MagicStoneMgr.readerWriterLock_0 = new ReaderWriterLock();
        MagicStoneInfo[] MagicStones = MagicStoneMgr.LoadMagicStoneDb();
        Dictionary<int, List<MagicStoneInfo>> dictionary = MagicStoneMgr.LoadMagicStones(MagicStones);
        if (MagicStones != null)
        {
          Interlocked.Exchange<MagicStoneInfo[]>(ref MagicStoneMgr.magicStoneInfo_0, MagicStones);
          Interlocked.Exchange<Dictionary<int, List<MagicStoneInfo>>>(ref MagicStoneMgr.dictionary_0, dictionary);
        }
        return true;
      }
      catch (Exception ex)
      {
        if (MagicStoneMgr.ilog_0.IsErrorEnabled)
          MagicStoneMgr.ilog_0.Error((object) nameof (ReLoad), ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => MagicStoneMgr.ReLoad();

    public static MagicStoneInfo[] LoadMagicStoneDb()
    {
      MagicStoneInfo[] magicStoneTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        magicStoneTemplate = produceBussiness.GetAllMagicStoneTemplate();
      return magicStoneTemplate;
    }

    public static Dictionary<int, List<MagicStoneInfo>> LoadMagicStones(MagicStoneInfo[] MagicStones)
    {
      Dictionary<int, List<MagicStoneInfo>> dictionary = new Dictionary<int, List<MagicStoneInfo>>();
      for (int index = 0; index < MagicStones.Length; ++index)
      {
        MagicStoneInfo info = MagicStones[index];
        if (!dictionary.Keys.Contains<int>(info.TemplateID))
        {
          IEnumerable<MagicStoneInfo> source = Enumerable.Where<MagicStoneInfo>((IEnumerable<MagicStoneInfo>) MagicStones, (Func<MagicStoneInfo, bool>) (s => s.TemplateID == info.TemplateID));
          dictionary.Add(info.TemplateID, source.ToList<MagicStoneInfo>());
        }
      }
      return dictionary;
    }

    public static List<MagicStoneInfo> FindMagicStone(int templateId)
    {
      if (MagicStoneMgr.dictionary_0 == null)
        MagicStoneMgr.ReLoad();
      MagicStoneMgr.readerWriterLock_0.AcquireReaderLock(-1);
      try
      {
        if (MagicStoneMgr.dictionary_0.ContainsKey(templateId))
          return MagicStoneMgr.dictionary_0[templateId];
      }
      finally
      {
        MagicStoneMgr.readerWriterLock_0.ReleaseReaderLock();
      }
      return (List<MagicStoneInfo>) null;
    }

    public static MagicStoneInfo FindMagicStoneByLevel(int templateId, int level)
    {
      if (MagicStoneMgr.dictionary_0 == null)
        MagicStoneMgr.ReLoad();
      MagicStoneMgr.readerWriterLock_0.AcquireReaderLock(-1);
      try
      {
        if (MagicStoneMgr.dictionary_0.ContainsKey(templateId))
        {
          foreach (MagicStoneInfo magicStoneByLevel in MagicStoneMgr.dictionary_0[templateId])
          {
            if (magicStoneByLevel.Level == level)
              return magicStoneByLevel;
          }
        }
      }
      finally
      {
        MagicStoneMgr.readerWriterLock_0.ReleaseReaderLock();
      }
      return (MagicStoneInfo) null;
    }

    public static SqlDataProvider.Data.ItemInfo GetMagicStoneInfo(ItemTemplateInfo info, int level)
    {
      MagicStoneInfo magicStoneByLevel = MagicStoneMgr.FindMagicStoneByLevel(info.TemplateID, level);
      if (magicStoneByLevel == null)
        return (SqlDataProvider.Data.ItemInfo) null;
      SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(info, 1, 101);
      PropMgInfo[] prop = MagicStoneMgr.CreateProp(magicStoneByLevel);
      MagicStoneMgr.threadSafeRandom_0.Shuffer<PropMgInfo>(prop);
      int num = prop.Length > info.Property3 ? info.Property3 : prop.Length;
      for (int index = 0; index < num; ++index)
      {
        switch (prop[index].key)
        {
          case null:
            continue;
          case "att":
            fromTemplate.AttackCompose = prop[index].value;
            break;
          case "agi":
            fromTemplate.AgilityCompose = prop[index].value;
            break;
          case "def":
            fromTemplate.DefendCompose = prop[index].value;
            break;
          case "luc":
            fromTemplate.LuckCompose = prop[index].value;
            break;
          case "mgatt":
            fromTemplate.MagicAttack = prop[index].value;
            break;
          case "mgdef":
            fromTemplate.MagicDefence = prop[index].value;
            break;
        }
      }
      fromTemplate.StrengthenLevel = level;
      fromTemplate.StrengthenExp = magicStoneByLevel.Exp;
      return fromTemplate;
    }

    public static PropMgInfo[] CreateProp(MagicStoneInfo info)
    {
      List<PropMgInfo> propMgInfoList = new List<PropMgInfo>();
      if (info.Attack > 0)
      {
        PropMgInfo propMgInfo = new PropMgInfo()
        {
          key = "att",
          value = info.Attack
        };
        propMgInfoList.Add(propMgInfo);
      }
      if (info.Defence > 0)
      {
        PropMgInfo propMgInfo = new PropMgInfo()
        {
          key = "def",
          value = info.Defence
        };
        propMgInfoList.Add(propMgInfo);
      }
      if (info.Agility > 0)
      {
        PropMgInfo propMgInfo = new PropMgInfo()
        {
          key = "agi",
          value = info.Agility
        };
        propMgInfoList.Add(propMgInfo);
      }
      if (info.Luck > 0)
      {
        PropMgInfo propMgInfo = new PropMgInfo()
        {
          key = "luc",
          value = info.Luck
        };
        propMgInfoList.Add(propMgInfo);
      }
      if (info.MagicAttack > 0)
      {
        PropMgInfo propMgInfo = new PropMgInfo()
        {
          key = "mgatt",
          value = info.MagicAttack
        };
        propMgInfoList.Add(propMgInfo);
      }
      if (info.MagicDefence > 0)
      {
        PropMgInfo propMgInfo = new PropMgInfo()
        {
          key = "mgdef",
          value = info.MagicDefence
        };
        propMgInfoList.Add(propMgInfo);
      }
      return propMgInfoList.ToArray();
    }
  }
}
