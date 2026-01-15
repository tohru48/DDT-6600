// Decompiled with JetBrains decompiler
// Type: Bussiness.IniReader
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.Runtime.InteropServices;
using System.Text;

#nullable disable
namespace Bussiness
{
  public class IniReader
  {
    private string string_0;

    [DllImport("kernel32")]
    private static extern int GetPrivateProfileString(
      string string_1,
      string string_2,
      string string_3,
      StringBuilder stringBuilder_0,
      int int_0,
      string string_4);

    public IniReader(string _FilePath) => this.string_0 = _FilePath;

    public string GetIniString(string Section, string Key)
    {
      StringBuilder stringBuilder_0 = new StringBuilder(2550);
      IniReader.GetPrivateProfileString(Section, Key, "", stringBuilder_0, 2550, this.string_0);
      return stringBuilder_0.ToString();
    }
  }
}
