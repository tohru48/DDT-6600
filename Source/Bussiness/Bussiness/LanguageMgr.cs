// Decompiled with JetBrains decompiler
// Type: Bussiness.LanguageMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using System;
using System.Collections;
using System.Configuration;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading;

#nullable disable
namespace Bussiness
{
  public class LanguageMgr
  {
    private static readonly ILog dyeHxkqFm = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Hashtable hashtable_0 = new Hashtable();

    private static string smethod_0() => ConfigurationManager.AppSettings["LanguagePath"];

    public static bool Setup(string path) => LanguageMgr.Reload(path);

    public static bool Reload(string path)
    {
      try
      {
        Hashtable hashtable = LanguageMgr.smethod_1(path);
        if (hashtable.Count > 0)
        {
          Interlocked.Exchange<Hashtable>(ref LanguageMgr.hashtable_0, hashtable);
          return true;
        }
      }
      catch (Exception ex)
      {
        LanguageMgr.dyeHxkqFm.Error((object) "Load language file error:", ex);
      }
      return false;
    }

    private static Hashtable smethod_1(string string_0)
    {
      Hashtable hashtable = new Hashtable();
      string path = string_0 + LanguageMgr.smethod_0();
      if (!File.Exists(path))
      {
        LanguageMgr.dyeHxkqFm.Error((object) ("Language file : " + path + " not found !"));
      }
      else
      {
        foreach (string str in (IEnumerable) new ArrayList((ICollection) File.ReadAllLines(path, Encoding.UTF8)))
        {
          if (!str.StartsWith("#") && str.IndexOf(':') != -1)
          {
            string[] strArray = new string[2]
            {
              str.Substring(0, str.IndexOf(':')),
              str.Substring(str.IndexOf(':') + 1)
            };
            strArray[1] = strArray[1].Replace("\t", "");
            hashtable[(object) strArray[0]] = (object) strArray[1];
          }
        }
      }
      return hashtable;
    }

    public static string GetTranslation(string translateId, params object[] args)
    {
      if (!LanguageMgr.hashtable_0.ContainsKey((object) translateId))
        return translateId;
      string format = (string) LanguageMgr.hashtable_0[(object) translateId];
      try
      {
        format = string.Format(format, args);
      }
      catch (Exception ex)
      {
        LanguageMgr.dyeHxkqFm.Error((object) ("Parameters number error, ID: " + translateId + " (Arg count=" + (object) args.Length + ")"), ex);
      }
      return format ?? translateId;
    }
  }
}
