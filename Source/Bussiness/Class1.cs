// Decompiled with JetBrains decompiler
// Type: Class1
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System;
using System.Reflection;

#nullable disable
internal class Class1
{
  internal static Module module_0 = typeof (Class1).Assembly.ManifestModule;

  internal static void EpvsXdrrrSyCl(int typemdt)
  {
    Type type = Class1.module_0.ResolveType(33554432 + typemdt);
    foreach (FieldInfo field in type.GetFields())
    {
      MethodInfo method = (MethodInfo) Class1.module_0.ResolveMethod(field.MetadataToken + 100663296);
      field.SetValue((object) null, (object) (MulticastDelegate) Delegate.CreateDelegate(type, method));
    }
  }

  internal delegate void Delegate0(object o);
}
