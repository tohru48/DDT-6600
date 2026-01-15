// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.RankTemplateMgr
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
  public class RankTemplateMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, RankTemplateInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        RankTemplateInfo[] RankTemplate = RankTemplateMgr.LoadRankTemplateDb();
        Dictionary<int, RankTemplateInfo> dictionary = RankTemplateMgr.LoadRankTemplates(RankTemplate);
        if (RankTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, RankTemplateInfo>>(ref RankTemplateMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (RankTemplateMgr.ilog_0.IsErrorEnabled)
          RankTemplateMgr.ilog_0.Error((object) "ReLoad RankTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => RankTemplateMgr.ReLoad();

    public static RankTemplateInfo[] LoadRankTemplateDb()
    {
      RankTemplateInfo[] allRankTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allRankTemplate = produceBussiness.GetAllRankTemplate();
      return allRankTemplate;
    }

    public static Dictionary<int, RankTemplateInfo> LoadRankTemplates(
      RankTemplateInfo[] RankTemplate)
    {
      Dictionary<int, RankTemplateInfo> dictionary = new Dictionary<int, RankTemplateInfo>();
      for (int index = 0; index < RankTemplate.Length; ++index)
      {
        RankTemplateInfo rankTemplateInfo = RankTemplate[index];
        if (!dictionary.Keys.Contains<int>(rankTemplateInfo.ID))
          dictionary.Add(rankTemplateInfo.ID, rankTemplateInfo);
      }
      return dictionary;
    }

    public static RankTemplateInfo FindRankTemplate(int ID)
    {
      return RankTemplateMgr.dictionary_0.ContainsKey(ID) ? RankTemplateMgr.dictionary_0[ID] : (RankTemplateInfo) null;
    }
  }
}
