// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.PetMoePropertyMgr
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
  public class PetMoePropertyMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, PetMoePropertyInfo> dictionary_0 = new Dictionary<int, PetMoePropertyInfo>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        PetMoePropertyInfo[] PetMoeProperty = PetMoePropertyMgr.LoadPetMoePropertyDb();
        Dictionary<int, PetMoePropertyInfo> dictionary = PetMoePropertyMgr.LoadPetMoePropertys(PetMoeProperty);
        if (PetMoeProperty.Length > 0)
          Interlocked.Exchange<Dictionary<int, PetMoePropertyInfo>>(ref PetMoePropertyMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (PetMoePropertyMgr.ilog_0.IsErrorEnabled)
          PetMoePropertyMgr.ilog_0.Error((object) "ReLoad PetMoeProperty", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => PetMoePropertyMgr.ReLoad();

    public static PetMoePropertyInfo[] LoadPetMoePropertyDb()
    {
      PetMoePropertyInfo[] allPetMoeProperty;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allPetMoeProperty = produceBussiness.GetAllPetMoeProperty();
      return allPetMoeProperty;
    }

    public static Dictionary<int, PetMoePropertyInfo> LoadPetMoePropertys(
      PetMoePropertyInfo[] PetMoeProperty)
    {
      Dictionary<int, PetMoePropertyInfo> dictionary = new Dictionary<int, PetMoePropertyInfo>();
      for (int index = 0; index < PetMoeProperty.Length; ++index)
      {
        PetMoePropertyInfo petMoePropertyInfo = PetMoeProperty[index];
        if (!dictionary.Keys.Contains<int>(petMoePropertyInfo.Level))
          dictionary.Add(petMoePropertyInfo.Level, petMoePropertyInfo);
      }
      return dictionary;
    }

    public static PetMoePropertyInfo FindPetMoeProperty(int Level)
    {
      return PetMoePropertyMgr.dictionary_0.ContainsKey(Level) ? PetMoePropertyMgr.dictionary_0[Level] : (PetMoePropertyInfo) null;
    }

    public static int FindMaxLevel() => PetMoePropertyMgr.dictionary_0.Count;
  }
}
