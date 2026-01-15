// Decompiled with JetBrains decompiler
// Type: Game.Logic.WindMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Reflection;

#nullable disable
namespace Game.Logic
{
  public class WindMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static readonly int[] int_0 = new int[9]
    {
      1001,
      1002,
      1003,
      1004,
      1005,
      1005,
      1007,
      1008,
      1009
    };
    private static readonly int[] int_1 = new int[11]
    {
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10
    };
    private static readonly string[] string_0 = new string[11]
    {
      ".",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "0"
    };
    private static readonly Color[] color_0 = new Color[8]
    {
      Color.Yellow,
      Color.Red,
      Color.Blue,
      Color.Green,
      Color.Orange,
      Color.Aqua,
      Color.DarkCyan,
      Color.Purple
    };
    private static readonly string[] string_1 = new string[3]
    {
      "Verdana",
      "Comic Sans MS",
      "Tahoma"
    };
    private static Dictionary<int, WindInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool Init()
    {
      bool flag;
      try
      {
        WindMgr.dictionary_0 = new Dictionary<int, WindInfo>();
        WindMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = WindMgr.smethod_0(WindMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (WindMgr.ilog_0.IsErrorEnabled)
          WindMgr.ilog_0.Error((object) "WindInfoMgr", ex);
        flag = false;
      }
      return flag;
    }

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, WindInfo> Winds = new Dictionary<int, WindInfo>();
        if (WindMgr.smethod_0(Winds))
        {
          try
          {
            WindMgr.dictionary_0 = Winds;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (WindMgr.ilog_0.IsErrorEnabled)
          WindMgr.ilog_0.Error((object) nameof (WindMgr), ex);
      }
      return false;
    }

    public static byte[] CreateImage(string randomcode)
    {
      int maxValue = 20;
      Bitmap bitmap = new Bitmap(16, 29);
      Graphics graphics = Graphics.FromImage((Image) bitmap);
      int index = WindMgr.threadSafeRandom_0.Next(WindMgr.string_1.Length);
      FontFamily family = new FontFamily(WindMgr.string_1[index]);
      GraphicsPath path = new GraphicsPath();
      Pen pen = new Pen(Color.Black, 5f);
      int num = WindMgr.threadSafeRandom_0.Next(2);
      Color white1 = Color.White;
      Color burlyWood = Color.BurlyWood;
      Color white2;
      Color white3;
      if (num == 1)
      {
        white2 = WindMgr.color_0[WindMgr.threadSafeRandom_0.Next(6)];
        white3 = Color.White;
      }
      else
      {
        white3 = WindMgr.color_0[WindMgr.threadSafeRandom_0.Next(6)];
        white2 = Color.White;
      }
      LinearGradientMode linearGradientMode;
      switch (WindMgr.threadSafeRandom_0.Next(4))
      {
        case 1:
          linearGradientMode = LinearGradientMode.BackwardDiagonal;
          break;
        case 2:
          linearGradientMode = LinearGradientMode.ForwardDiagonal;
          break;
        case 3:
          linearGradientMode = LinearGradientMode.Vertical;
          break;
        default:
          linearGradientMode = LinearGradientMode.Horizontal;
          break;
      }
      LinearGradientBrush linearGradientBrush = new LinearGradientBrush(new Rectangle(10, 10, 16, 26), white3, white2, linearGradientMode);
      byte[] array;
      try
      {
        graphics.SmoothingMode = SmoothingMode.AntiAlias;
        graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
        StringFormat format = new StringFormat(StringFormatFlags.NoClip)
        {
          Alignment = StringAlignment.Center,
          LineAlignment = StringAlignment.Center
        };
        path.AddString(randomcode, family, 1, 16f, new Point(1, 1), format);
        pen.LineJoin = LineJoin.Round;
        Point point = new Point(7, 12);
        float angle = (float) WindMgr.threadSafeRandom_0.Next(-maxValue, maxValue);
        graphics.TranslateTransform((float) point.X, (float) point.Y);
        graphics.RotateTransform(angle);
        graphics.DrawPath(pen, path);
        graphics.FillPath((Brush) linearGradientBrush, path);
        graphics.RotateTransform(-angle);
        MemoryStream memoryStream = new MemoryStream();
        bitmap.Save((Stream) memoryStream, ImageFormat.Png);
        array = memoryStream.ToArray();
      }
      finally
      {
        graphics.Dispose();
        bitmap.Dispose();
        family.Dispose();
        path.Dispose();
        pen.Dispose();
        linearGradientBrush.Dispose();
      }
      return array;
    }

    private static bool smethod_0(Dictionary<int, WindInfo> Winds)
    {
      foreach (int key in WindMgr.int_1)
      {
        WindInfo windInfo = new WindInfo();
        byte[] image = WindMgr.CreateImage(WindMgr.string_0[key]);
        if (image == null || image.Length <= 0)
        {
          if (WindMgr.ilog_0.IsErrorEnabled)
            WindMgr.ilog_0.Error((object) "Load Wind Error!");
          return false;
        }
        windInfo.WindID = key;
        windInfo.WindPic = image;
        if (!Winds.ContainsKey(key))
          Winds.Add(key, windInfo);
      }
      return true;
    }

    public static List<WindInfo> GetWind()
    {
      List<WindInfo> windInfoList = new List<WindInfo>();
      for (int key = 0; key < WindMgr.dictionary_0.Values.Count; ++key)
        windInfoList.Add(WindMgr.dictionary_0[key]);
      return windInfoList.Count > 0 ? windInfoList : (List<WindInfo>) null;
    }

    public static byte GetWindID(int wind, int pos)
    {
      if (wind < 10)
      {
        switch (pos)
        {
          case 1:
            return 10;
          case 3:
            return wind == 0 ? (byte) 10 : (byte) wind;
        }
      }
      if (wind >= 10 && wind < 20)
      {
        switch (pos)
        {
          case 1:
            return 1;
          case 3:
            return wind - 10 == 0 ? (byte) 10 : (byte) (wind - 10);
        }
      }
      if (wind >= 20 && wind < 30)
      {
        switch (pos)
        {
          case 1:
            return 2;
          case 3:
            return wind - 20 == 0 ? (byte) 10 : (byte) (wind - 20);
        }
      }
      if (wind >= 30 && wind < 40)
      {
        switch (pos)
        {
          case 1:
            return 3;
          case 3:
            return wind - 30 == 0 ? (byte) 10 : (byte) (wind - 30);
        }
      }
      if (wind >= 40 && wind < 50)
      {
        switch (pos)
        {
          case 1:
            return 4;
          case 3:
            return wind - 40 == 0 ? (byte) 10 : (byte) (wind - 40);
        }
      }
      return 0;
    }
  }
}
