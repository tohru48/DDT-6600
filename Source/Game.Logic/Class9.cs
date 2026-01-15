// Decompiled with JetBrains decompiler
// Type: Class9
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System;
using System.Reflection;

#nullable disable
internal class Class9
{
  internal static Module module_0 = typeof (Class9).Assembly.ManifestModule;

  internal static void OcI3IHllm7vWf(int typemdt)
  {
    Type type = Class9.module_0.ResolveType(33554432 + typemdt);
    foreach (FieldInfo field in type.GetFields())
    {
      MethodInfo method = (MethodInfo) Class9.module_0.ResolveMethod(field.MetadataToken + 100663296);
      field.SetValue((object) null, (object) (MulticastDelegate) Delegate.CreateDelegate(type, method));
    }
  }

  internal delegate void Delegate2(object o);
}
