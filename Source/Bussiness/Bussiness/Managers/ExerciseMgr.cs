// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ExerciseMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

#nullable disable
namespace Bussiness.Managers
{
  public class ExerciseMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ExerciseInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool Init()
    {
      bool flag;
      try
      {
        ExerciseMgr.dictionary_0 = new Dictionary<int, ExerciseInfo>();
        ExerciseMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = ExerciseMgr.smethod_0(ExerciseMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (ExerciseMgr.ilog_0.IsErrorEnabled)
          ExerciseMgr.ilog_0.Error((object) "ExercisesMgr", ex);
        flag = false;
      }
      return flag;
    }

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ExerciseInfo> Exercise = new Dictionary<int, ExerciseInfo>();
        if (ExerciseMgr.smethod_0(Exercise))
        {
          try
          {
            ExerciseMgr.dictionary_0 = Exercise;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (ExerciseMgr.ilog_0.IsErrorEnabled)
          ExerciseMgr.ilog_0.Error((object) nameof (ExerciseMgr), ex);
      }
      return false;
    }

    private static bool smethod_0(Dictionary<int, ExerciseInfo> Exercise)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (ExerciseInfo exerciseInfo in playerBussiness.GetAllExercise())
        {
          if (!Exercise.ContainsKey(exerciseInfo.Grage))
            Exercise.Add(exerciseInfo.Grage, exerciseInfo);
        }
      }
      return true;
    }

    public static ExerciseInfo FindExercise(int Grage)
    {
      if (Grage == 0)
        Grage = 1;
      try
      {
        if (ExerciseMgr.dictionary_0.ContainsKey(Grage))
          return ExerciseMgr.dictionary_0[Grage];
      }
      catch
      {
      }
      return (ExerciseInfo) null;
    }

    public static int GetMaxLevel()
    {
      if (ExerciseMgr.dictionary_0 == null)
        ExerciseMgr.Init();
      return ExerciseMgr.dictionary_0.Values.Count;
    }

    public static int GetExercise(int GP, string type)
    {
      int exercise = 0;
      for (int Grage = 1; Grage <= ExerciseMgr.GetMaxLevel(); ++Grage)
      {
        switch (type)
        {
          case null:
            if (GP > ExerciseMgr.FindExercise(Grage).GP)
              continue;
            goto label_11;
          case "A":
            exercise = ExerciseMgr.FindExercise(Grage).ExerciseA;
            goto default;
          case "AG":
            exercise = ExerciseMgr.FindExercise(Grage).ExerciseAG;
            goto default;
          case "D":
            exercise = ExerciseMgr.FindExercise(Grage).ExerciseD;
            goto default;
          case "H":
            exercise = ExerciseMgr.FindExercise(Grage).ExerciseH;
            goto default;
          case "L":
            exercise = ExerciseMgr.FindExercise(Grage).ExerciseL;
            goto default;
          default:
            goto case null;
        }
      }
label_11:
      return exercise;
    }
  }
}
