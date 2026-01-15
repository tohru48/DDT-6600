using System;
using System.Reflection;

internal class Class25
{
	internal delegate void Delegate3(object o);

	internal static Module module_0;

	internal static void t8i37R55kyZLw(int typemdt)
	{
		Type type = module_0.ResolveType(33554432 + typemdt);
		FieldInfo[] fields = type.GetFields();
		foreach (FieldInfo fieldInfo in fields)
		{
			MethodInfo method = (MethodInfo)module_0.ResolveMethod(fieldInfo.MetadataToken + 100663296);
			fieldInfo.SetValue(null, (MulticastDelegate)Delegate.CreateDelegate(type, method));
		}
	}

	static Class25()
	{
		module_0 = typeof(Class25).Assembly.ManifestModule;
	}
}
