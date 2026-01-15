// Decompiled with JetBrains decompiler
// Type: Bussiness.CheckCode
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

#nullable disable
namespace Bussiness
{
  public class CheckCode
  {
    public static ThreadSafeRandom rand = new ThreadSafeRandom();
    private static Color[] color_0 = new Color[2]
    {
      Color.Gray,
      Color.DimGray
    };
    private static string[] string_0 = new string[5]
    {
      "Verdana",
      "Terminal",
      "Comic Sans MS",
      "Arial",
      "Tekton Pro"
    };
    private static char[] char_0 = new char[9]
    {
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    };
    private static char[] char_1 = new char[21]
    {
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'h',
      'k',
      'm',
      'n',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    };
    private static char[] char_2 = new char[22]
    {
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'K',
      'M',
      'N',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    };
    private static char[] char_3 = new char[50]
    {
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    };
    private static char[] char_4 = new char[51]
    {
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'h',
      'k',
      'm',
      'n',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'K',
      'M',
      'N',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    };

    public static byte[] CreateImage(string randomcode)
    {
      int maxValue = 30;
      Bitmap bitmap = new Bitmap(randomcode.Length * 30, 32);
      Graphics graphics = Graphics.FromImage((Image) bitmap);
      graphics.SmoothingMode = SmoothingMode.HighQuality;
      byte[] array;
      try
      {
        graphics.Clear(Color.Transparent);
        int index1 = CheckCode.rand.Next(2);
        Brush brush = (Brush) new SolidBrush(CheckCode.color_0[index1]);
        for (int index2 = 0; index2 < 1; ++index2)
        {
          int x1 = CheckCode.rand.Next(bitmap.Width / 2);
          int x4 = CheckCode.rand.Next(bitmap.Width * 3 / 4, bitmap.Width);
          int y1 = CheckCode.rand.Next(bitmap.Height);
          int y4 = CheckCode.rand.Next(bitmap.Height);
          graphics.DrawBezier(new Pen(CheckCode.color_0[index1], 2f), (float) x1, (float) y1, (float) ((x1 + x4) / 4), 0.0f, (float) ((x1 + x4) * 3 / 4), (float) bitmap.Height, (float) x4, (float) y4);
        }
        char[] charArray = randomcode.ToCharArray();
        StringFormat format = new StringFormat(StringFormatFlags.NoClip);
        format.Alignment = StringAlignment.Center;
        format.LineAlignment = StringAlignment.Center;
        for (int index3 = 0; index3 < charArray.Length; ++index3)
        {
          int index4 = CheckCode.rand.Next(5);
          Font font = new Font(CheckCode.string_0[index4], 22f, FontStyle.Bold);
          Point point = new Point(16, 16);
          float angle = (float) ThreadSafeRandom.NextStatic(-maxValue, maxValue);
          graphics.TranslateTransform((float) point.X, (float) point.Y);
          graphics.RotateTransform(angle);
          graphics.DrawString(charArray[index3].ToString(), font, brush, 1f, 1f, format);
          graphics.RotateTransform(-angle);
          graphics.TranslateTransform(2f, -(float) point.Y);
        }
        MemoryStream memoryStream = new MemoryStream();
        bitmap.Save((Stream) memoryStream, ImageFormat.Png);
        array = memoryStream.ToArray();
      }
      finally
      {
        graphics.Dispose();
        bitmap.Dispose();
      }
      return array;
    }

    private static string smethod_0(int int_0, CheckCode.Enum0 enum0_0)
    {
      string empty = string.Empty;
      if (int_0 == 0)
        return empty;
      switch (enum0_0)
      {
        case (CheckCode.Enum0) 0:
          for (int index = 0; index < int_0; ++index)
            empty += (string) (object) CheckCode.char_1[CheckCode.rand.Next(0, CheckCode.char_1.Length)];
          break;
        case (CheckCode.Enum0) 1:
          for (int index = 0; index < int_0; ++index)
            empty += (string) (object) CheckCode.char_2[CheckCode.rand.Next(0, CheckCode.char_2.Length)];
          break;
        case (CheckCode.Enum0) 2:
          for (int index = 0; index < int_0; ++index)
            empty += (string) (object) CheckCode.char_3[CheckCode.rand.Next(0, CheckCode.char_3.Length)];
          break;
        case (CheckCode.Enum0) 3:
          for (int index = 0; index < int_0; ++index)
            empty += (string) (object) CheckCode.char_0[CheckCode.rand.Next(0, CheckCode.char_0.Length)];
          break;
        default:
          for (int index = 0; index < int_0; ++index)
            empty += (string) (object) CheckCode.char_4[CheckCode.rand.Next(0, CheckCode.char_4.Length)];
          break;
      }
      return empty;
    }

    public static string GenerateCheckCode() => CheckCode.smethod_0(4, (CheckCode.Enum0) 4);

    private enum Enum0
    {
    }
  }
}
