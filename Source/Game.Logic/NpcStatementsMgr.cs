// Decompiled with JetBrains decompiler
// Type: Game.Logic.NpcStatementsMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using log4net;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

#nullable disable
namespace Game.Logic
{
  public class NpcStatementsMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static List<string> list_0 = new List<string>();
    private static string string_0;
    private static Random random_0;

    public static bool Init()
    {
      NpcStatementsMgr.string_0 = Directory.GetCurrentDirectory() + "\\ai\\npc\\npc_statements.txt";
      NpcStatementsMgr.random_0 = new Random();
      return NpcStatementsMgr.ReLoad();
    }

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        string empty = string.Empty;
        StreamReader streamReader = new StreamReader(NpcStatementsMgr.string_0, Encoding.Default);
        string str;
        while (!string.IsNullOrEmpty(str = streamReader.ReadLine()))
          NpcStatementsMgr.list_0.Add(str);
        flag = true;
      }
      catch (Exception ex)
      {
        NpcStatementsMgr.ilog_0.Error((object) "NpcStatementsMgr.Reload()", ex);
        flag = false;
      }
      return flag;
    }

    public static int[] RandomStatementIndexs(int count)
    {
      int[] source = new int[count];
      int index = 0;
      while (index < count)
      {
        int num = NpcStatementsMgr.random_0.Next(0, NpcStatementsMgr.list_0.Count);
        if (!((IEnumerable<int>) source).Contains<int>(num))
        {
          source[index] = num;
          ++index;
        }
      }
      return source;
    }

    public static string[] RandomStatement(int count)
    {
      string[] strArray = new string[count];
      int[] numArray = NpcStatementsMgr.RandomStatementIndexs(count);
      for (int index1 = 0; index1 < count; ++index1)
      {
        int index2 = numArray[index1];
        strArray[index1] = NpcStatementsMgr.list_0[index2];
      }
      return strArray;
    }

    public static string GetStatement(int index)
    {
      return index >= 0 && index <= NpcStatementsMgr.list_0.Count ? NpcStatementsMgr.list_0[index] : (string) null;
    }

    public static string GetRandomStatement()
    {
      int index = NpcStatementsMgr.random_0.Next(0, NpcStatementsMgr.list_0.Count);
      return NpcStatementsMgr.list_0[index];
    }
  }
}
