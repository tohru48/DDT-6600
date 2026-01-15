// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.QuestMgr
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
  public class QuestMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, QuestInfo> dictionary_0 = new Dictionary<int, QuestInfo>();
    private static Dictionary<int, List<QuestConditionInfo>> dictionary_1 = new Dictionary<int, List<QuestConditionInfo>>();
    private static Dictionary<int, List<QuestAwardInfo>> dictionary_2 = new Dictionary<int, List<QuestAwardInfo>>();

    public static bool Init() => QuestMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, QuestInfo> quests = QuestMgr.LoadQuestInfoDb();
        Dictionary<int, List<QuestConditionInfo>> dictionary1 = QuestMgr.LoadQuestCondictionDb(quests);
        Dictionary<int, List<QuestAwardInfo>> dictionary2 = QuestMgr.LoadQuestGoodDb(quests);
        if (quests.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, QuestInfo>>(ref QuestMgr.dictionary_0, quests);
          Interlocked.Exchange<Dictionary<int, List<QuestConditionInfo>>>(ref QuestMgr.dictionary_1, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<QuestAwardInfo>>>(ref QuestMgr.dictionary_2, dictionary2);
        }
        return true;
      }
      catch (Exception ex)
      {
        QuestMgr.ilog_0.Error((object) nameof (QuestMgr), ex);
      }
      return false;
    }

    public static Dictionary<int, QuestInfo> LoadQuestInfoDb()
    {
      Dictionary<int, QuestInfo> dictionary = new Dictionary<int, QuestInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (QuestInfo questInfo in produceBussiness.method_1())
        {
          if (!dictionary.ContainsKey(questInfo.ID))
            dictionary.Add(questInfo.ID, questInfo);
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<QuestConditionInfo>> LoadQuestCondictionDb(
      Dictionary<int, QuestInfo> quests)
    {
      Dictionary<int, List<QuestConditionInfo>> dictionary = new Dictionary<int, List<QuestConditionInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        QuestConditionInfo[] allQuestCondiction = produceBussiness.GetAllQuestCondiction();
        foreach (QuestInfo questInfo in quests.Values)
        {
          QuestInfo quest = questInfo;
          IEnumerable<QuestConditionInfo> source = Enumerable.Where<QuestConditionInfo>((IEnumerable<QuestConditionInfo>) allQuestCondiction, (Func<QuestConditionInfo, bool>) (s => s.QuestID == quest.ID));
          dictionary.Add(quest.ID, source.ToList<QuestConditionInfo>());
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<QuestAwardInfo>> LoadQuestGoodDb(
      Dictionary<int, QuestInfo> quests)
    {
      Dictionary<int, List<QuestAwardInfo>> dictionary = new Dictionary<int, List<QuestAwardInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        QuestAwardInfo[] allQuestGoods = produceBussiness.GetAllQuestGoods();
        foreach (QuestInfo questInfo in quests.Values)
        {
          QuestInfo quest = questInfo;
          IEnumerable<QuestAwardInfo> source = Enumerable.Where<QuestAwardInfo>((IEnumerable<QuestAwardInfo>) allQuestGoods, (Func<QuestAwardInfo, bool>) (s => s.QuestID == quest.ID));
          dictionary.Add(quest.ID, source.ToList<QuestAwardInfo>());
        }
      }
      return dictionary;
    }

    public static QuestInfo GetSingleQuest(int id)
    {
      if (QuestMgr.dictionary_0.Count == 0)
        QuestMgr.ReLoad();
      return QuestMgr.dictionary_0.ContainsKey(id) ? QuestMgr.dictionary_0[id] : (QuestInfo) null;
    }

    public static QuestInfo[] GetAllBuriedQuest()
    {
      if (QuestMgr.dictionary_0.Count == 0)
        QuestMgr.ReLoad();
      return Enumerable.Where<QuestInfo>((IEnumerable<QuestInfo>) QuestMgr.dictionary_0.Values, (Func<QuestInfo, bool>) (questInfo_0 => questInfo_0.QuestID == 10)).ToArray<QuestInfo>();
    }

    public static List<QuestAwardInfo> GetQuestGoods(QuestInfo info)
    {
      return QuestMgr.dictionary_2.ContainsKey(info.ID) ? QuestMgr.dictionary_2[info.ID] : (List<QuestAwardInfo>) null;
    }

    public static List<QuestConditionInfo> GetQuestCondiction(QuestInfo info)
    {
      return QuestMgr.dictionary_1.ContainsKey(info.ID) ? QuestMgr.dictionary_1[info.ID] : (List<QuestConditionInfo>) null;
    }
  }
}
