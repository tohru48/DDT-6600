// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.SuitMgr
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
  public class SuitMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, SuitTemplateInfo> dictionary_0;
    private static Dictionary<int, List<SuitPartEquipInfo>> dictionary_1;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        SuitTemplateInfo[] suitTemplateInfoArray = SuitMgr.LoadSuitTemplateDb();
        Dictionary<int, SuitTemplateInfo> dictionary1 = SuitMgr.LoadSuitTemplates(suitTemplateInfoArray);
        Dictionary<int, List<SuitPartEquipInfo>> dictionary2 = SuitMgr.LoadSuitPartEquips(suitTemplateInfoArray);
        if (suitTemplateInfoArray.Length > 0)
        {
          Interlocked.Exchange<Dictionary<int, SuitTemplateInfo>>(ref SuitMgr.dictionary_0, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<SuitPartEquipInfo>>>(ref SuitMgr.dictionary_1, dictionary2);
        }
        return true;
      }
      catch (Exception ex)
      {
        if (SuitMgr.ilog_0.IsErrorEnabled)
          SuitMgr.ilog_0.Error((object) "ReLoad SuitTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => SuitMgr.ReLoad();

    public static Dictionary<int, List<SuitPartEquipInfo>> LoadSuitPartEquips(
      SuitTemplateInfo[] SuitPartEquip)
    {
      Dictionary<int, List<SuitPartEquipInfo>> dictionary = new Dictionary<int, List<SuitPartEquipInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        SuitPartEquipInfo[] allSuitPartEquip = produceBussiness.GetAllSuitPartEquip();
        for (int index = 0; index < SuitPartEquip.Length; ++index)
        {
          SuitTemplateInfo info = SuitPartEquip[index];
          if (!dictionary.Keys.Contains<int>(info.SuitId))
          {
            IEnumerable<SuitPartEquipInfo> source = Enumerable.Where<SuitPartEquipInfo>((IEnumerable<SuitPartEquipInfo>) allSuitPartEquip, (Func<SuitPartEquipInfo, bool>) (s => s.ID == info.SuitId));
            dictionary.Add(info.SuitId, source.ToList<SuitPartEquipInfo>());
          }
        }
      }
      return dictionary;
    }

    public static List<SuitPartEquipInfo> FindSuitPartEquip(int Id)
    {
      return SuitMgr.dictionary_1.ContainsKey(Id) ? SuitMgr.dictionary_1[Id] : (List<SuitPartEquipInfo>) null;
    }

    public static SuitTemplateInfo[] LoadSuitTemplateDb()
    {
      SuitTemplateInfo[] allSuitTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allSuitTemplate = produceBussiness.GetAllSuitTemplate();
      return allSuitTemplate;
    }

    public static Dictionary<int, SuitTemplateInfo> LoadSuitTemplates(
      SuitTemplateInfo[] SuitTemplate)
    {
      Dictionary<int, SuitTemplateInfo> dictionary = new Dictionary<int, SuitTemplateInfo>();
      for (int index = 0; index < SuitTemplate.Length; ++index)
      {
        SuitTemplateInfo suitTemplateInfo = SuitTemplate[index];
        if (!dictionary.Keys.Contains<int>(suitTemplateInfo.SuitId))
          dictionary.Add(suitTemplateInfo.SuitId, suitTemplateInfo);
      }
      return dictionary;
    }

    public static SuitTemplateInfo FindSuitTemplate(int ID)
    {
      return SuitMgr.dictionary_0.ContainsKey(ID) ? SuitMgr.dictionary_0[ID] : (SuitTemplateInfo) null;
    }
  }
}
