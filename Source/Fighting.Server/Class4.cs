// Decompiled with JetBrains decompiler
// Type: Class4
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using System;
using System.Reflection;

#nullable disable
internal class Class4
{
  internal static Module module_0 = typeof (Class4).Assembly.ManifestModule;

  internal static void HFfweHcc0H8Uo(int typemdt)
  {
    Type type = Class4.module_0.ResolveType(33554432 + typemdt);
    foreach (FieldInfo field in type.GetFields())
    {
      MethodInfo method = (MethodInfo) Class4.module_0.ResolveMethod(field.MetadataToken + 100663296);
      field.SetValue((object) null, (object) (MulticastDelegate) Delegate.CreateDelegate(type, method));
    }
  }

  internal delegate void Delegate1(object o);
}
