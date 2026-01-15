// Decompiled with JetBrains decompiler
// Type: Class32
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Reflection;

#nullable disable
internal class Class32
{
  internal static Module module_0 = typeof (Class32).Assembly.ManifestModule;

  internal static void GAj2fQ88d2dtL(int typemdt)
  {
    Type type = Class32.module_0.ResolveType(33554432 + typemdt);
    foreach (FieldInfo field in type.GetFields())
    {
      MethodInfo method = (MethodInfo) Class32.module_0.ResolveMethod(field.MetadataToken + 100663296);
      field.SetValue((object) null, (object) (MulticastDelegate) Delegate.CreateDelegate(type, method));
    }
  }

  internal delegate void Delegate6(object o);
}
