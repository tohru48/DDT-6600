// Decompiled with JetBrains decompiler
// Type: Bussiness.XmlExtends
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.Text;
using System.Xml;
using System.Xml.Linq;

#nullable disable
namespace Bussiness
{
  public static class XmlExtends
  {
    public static string ToString(this XElement node, bool check)
    {
      StringBuilder stringBuilder = new StringBuilder();
      StringBuilder output = stringBuilder;
      XmlWriterSettings settings = new XmlWriterSettings()
      {
        CheckCharacters = check,
        OmitXmlDeclaration = true,
        Indent = true
      };
      using (XmlWriter writer = XmlWriter.Create(output, settings))
        node.WriteTo(writer);
      return stringBuilder.ToString();
    }
  }
}
