// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.LotteryShowTemplateMgr
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
  public class LotteryShowTemplateMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<LotteryShowTemplateInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        LotteryShowTemplateInfo[] LotteryShowTemplate = LotteryShowTemplateMgr.LoadLotteryShowTemplateDb();
        Dictionary<int, List<LotteryShowTemplateInfo>> dictionary = LotteryShowTemplateMgr.LoadLotteryShowTemplates(LotteryShowTemplate);
        if (LotteryShowTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<LotteryShowTemplateInfo>>>(ref LotteryShowTemplateMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (LotteryShowTemplateMgr.ilog_0.IsErrorEnabled)
          LotteryShowTemplateMgr.ilog_0.Error((object) "ReLoad LotteryShowTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => LotteryShowTemplateMgr.ReLoad();

    public static LotteryShowTemplateInfo[] LoadLotteryShowTemplateDb()
    {
      LotteryShowTemplateInfo[] lotteryShowTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        lotteryShowTemplate = produceBussiness.GetAllLotteryShowTemplate();
      return lotteryShowTemplate;
    }

    public static Dictionary<int, List<LotteryShowTemplateInfo>> LoadLotteryShowTemplates(
      LotteryShowTemplateInfo[] LotteryShowTemplate)
    {
      Dictionary<int, List<LotteryShowTemplateInfo>> dictionary = new Dictionary<int, List<LotteryShowTemplateInfo>>();
      for (int index = 0; index < LotteryShowTemplate.Length; ++index)
      {
        LotteryShowTemplateInfo info = LotteryShowTemplate[index];
        if (!dictionary.Keys.Contains<int>(info.BoxType))
        {
          IEnumerable<LotteryShowTemplateInfo> source = Enumerable.Where<LotteryShowTemplateInfo>((IEnumerable<LotteryShowTemplateInfo>) LotteryShowTemplate, (Func<LotteryShowTemplateInfo, bool>) (s => s.BoxType == info.BoxType));
          dictionary.Add(info.BoxType, source.ToList<LotteryShowTemplateInfo>());
        }
      }
      return dictionary;
    }

    public static List<LotteryShowTemplateInfo> FindLotteryShowTemplate(int DataId)
    {
      return LotteryShowTemplateMgr.dictionary_0.ContainsKey(DataId) ? LotteryShowTemplateMgr.dictionary_0[DataId] : (List<LotteryShowTemplateInfo>) null;
    }
  }
}
