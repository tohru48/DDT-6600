// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.AllQuestionsMgr
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
  public class AllQuestionsMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<AllQuestionsInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        AllQuestionsInfo[] AllQuestions = AllQuestionsMgr.LoadAllQuestionsDb();
        Dictionary<int, List<AllQuestionsInfo>> dictionary = AllQuestionsMgr.LoadAllQuestionss(AllQuestions);
        if (AllQuestions.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<AllQuestionsInfo>>>(ref AllQuestionsMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (AllQuestionsMgr.ilog_0.IsErrorEnabled)
          AllQuestionsMgr.ilog_0.Error((object) "ReLoad AllQuestions", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => AllQuestionsMgr.ReLoad();

    public static AllQuestionsInfo[] LoadAllQuestionsDb()
    {
      AllQuestionsInfo[] allAllQuestions;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allAllQuestions = produceBussiness.GetAllAllQuestions();
      return allAllQuestions;
    }

    public static Dictionary<int, List<AllQuestionsInfo>> LoadAllQuestionss(
      AllQuestionsInfo[] AllQuestions)
    {
      Dictionary<int, List<AllQuestionsInfo>> dictionary = new Dictionary<int, List<AllQuestionsInfo>>();
      for (int index = 0; index < AllQuestions.Length; ++index)
      {
        AllQuestionsInfo info = AllQuestions[index];
        if (!dictionary.Keys.Contains<int>(info.QuestionCatalogID))
        {
          IEnumerable<AllQuestionsInfo> source = Enumerable.Where<AllQuestionsInfo>((IEnumerable<AllQuestionsInfo>) AllQuestions, (Func<AllQuestionsInfo, bool>) (s => s.QuestionCatalogID == info.QuestionCatalogID));
          dictionary.Add(info.QuestionCatalogID, source.ToList<AllQuestionsInfo>());
        }
      }
      return dictionary;
    }

    public static List<AllQuestionsInfo> FindAllQuestions(int DataId)
    {
      return AllQuestionsMgr.dictionary_0.ContainsKey(DataId) ? AllQuestionsMgr.dictionary_0[DataId] : (List<AllQuestionsInfo>) null;
    }
  }
}
