// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ChargeSpendRewardTemplateMgr
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
  public class ChargeSpendRewardTemplateMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ChargeSpendRewardTemplateInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        ChargeSpendRewardTemplateInfo[] ChargeSpendRewardTemplate = ChargeSpendRewardTemplateMgr.LoadChargeSpendRewardTemplateDb();
        Dictionary<int, ChargeSpendRewardTemplateInfo> dictionary = ChargeSpendRewardTemplateMgr.LoadChargeSpendRewardTemplates(ChargeSpendRewardTemplate);
        if (ChargeSpendRewardTemplate != null)
          Interlocked.Exchange<Dictionary<int, ChargeSpendRewardTemplateInfo>>(ref ChargeSpendRewardTemplateMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (ChargeSpendRewardTemplateMgr.ilog_0.IsErrorEnabled)
          ChargeSpendRewardTemplateMgr.ilog_0.Error((object) "ReLoad ChargeSpendRewardTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => ChargeSpendRewardTemplateMgr.ReLoad();

    public static ChargeSpendRewardTemplateInfo[] LoadChargeSpendRewardTemplateDb()
    {
      ChargeSpendRewardTemplateInfo[] spendRewardTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        spendRewardTemplate = produceBussiness.GetAllChargeSpendRewardTemplate();
      return spendRewardTemplate;
    }

    public static Dictionary<int, ChargeSpendRewardTemplateInfo> LoadChargeSpendRewardTemplates(
      ChargeSpendRewardTemplateInfo[] ChargeSpendRewardTemplate)
    {
      Dictionary<int, ChargeSpendRewardTemplateInfo> dictionary = new Dictionary<int, ChargeSpendRewardTemplateInfo>();
      for (int index = 0; index < ChargeSpendRewardTemplate.Length; ++index)
      {
        ChargeSpendRewardTemplateInfo rewardTemplateInfo = ChargeSpendRewardTemplate[index];
        if (!dictionary.Keys.Contains<int>(rewardTemplateInfo.ID))
          dictionary.Add(rewardTemplateInfo.ID, rewardTemplateInfo);
      }
      return dictionary;
    }

    public static ChargeSpendRewardTemplateInfo FindChargeSpendRewardTemplate(int ID)
    {
      return ChargeSpendRewardTemplateMgr.dictionary_0.ContainsKey(ID) ? ChargeSpendRewardTemplateMgr.dictionary_0[ID] : (ChargeSpendRewardTemplateInfo) null;
    }
  }
}
